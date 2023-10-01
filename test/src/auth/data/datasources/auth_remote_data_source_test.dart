import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = '_mock.uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;

  late IAuthRemoteDataSource dataSource;
  late DocumentReference<DataMap> documentReference;
  late UserCredential userCredential;
  late MockUser mockUser;

  final tUser = LocalUserModel.empty();

  setUp(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    dbClient = MockFirebaseStorage();

    //get doc ref, but not putting anything there
    documentReference = cloudStoreClient.collection('users').doc();

    //put into cloud store tUser, but with uid: documentReference.id
    await documentReference.set(
      tUser.copyWith(id: documentReference.id).toMap(),
    );

    mockUser = MockUser()..uid = documentReference.id;

    userCredential = MockUserCredential(mockUser);

    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = '_test.password';
  const tUsername = '_test.username';
  const tEmail = '_test.email';
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user_not_found',
    message: 'There is no user record, corresponding to the provided ID.',
  );

  group('forgotPassword', () {
    test(
      'should complete successfully, when no exception is thrown',
      () async {
        // arrange
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        final call = dataSource.forgotPassword(email: tEmail);

        // assert
        expect(call, completes);

        verify(
          () => authClient.sendPasswordResetEmail(
            email: tEmail,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException], '
      'when authClent.sendPasswordResetEmail throws [FirebaseAuthException]',
      () async {
        // arrange
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(tFirebaseAuthException);

        // act
        final call = dataSource.forgotPassword;

        // assert
        expect(
          () => call(email: tEmail),
          throwsA(
            ServerException(
              statusCode: tFirebaseAuthException.code,
              message: tFirebaseAuthException.message!,
            ),
          ),
        );

        verify(
          () => authClient.sendPasswordResetEmail(
            email: tEmail,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] '
      'when no exception is thrown',
      () async {
        //arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        //act
        final result = await dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result.id,
          userCredential.user!.uid,
        );

        expect(result.cards, tUser.cards);

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] '
      'when authClent throws [FirebaseAuthException]',
      () async {
        //arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        //act
        final call = dataSource.signIn;

        // assert
        expect(
          () => call(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(
            ServerException(
              statusCode: tFirebaseAuthException.code,
              message: tFirebaseAuthException.message!,
            ),
          ),
        );

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] '
      'when user is null after signing in',
      () async {
        //arrange
        final emptyUserCredential = MockUserCredential();
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emptyUserCredential);

        //act
        final call = dataSource.signIn;

        // assert
        expect(
          () => call(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });
  group('signUp', () {
    test(
      'should complete successfully, '
      'when no exception is thrown',
      () async {
        //arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        when(() => userCredential.user!.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );
        when(() => userCredential.user!.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        //act
        final call = dataSource.signUp(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        );

        // assert
        expect(
          call,
          completes,
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        await untilCalled(() => userCredential.user!.updateDisplayName(any()));
        await untilCalled(() => userCredential.user!.updatePhotoURL(any()));

        verify(
          () => userCredential.user!.updateDisplayName(
            tUsername,
          ),
        ).called(1);
        verify(
          () => userCredential.user!.updatePhotoURL(
            kDefaultAvatar,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] '
      'when authClient throws [FirebaseAuthException]',
      () async {
        //arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        //act
        final call = dataSource.signUp;

        // assert
        expect(
          () => call(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
          throwsA(
            ServerException(
              statusCode: tFirebaseAuthException.code,
              message: tFirebaseAuthException.message!,
            ),
          ),
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test(
      'should update user email successfully '
      'when no exception is thrown',
      () async {
        // arrange
        when(() => mockUser.updateEmail(any())).thenAnswer(
          (_) async => Future.value(),
        );

        // act
        await dataSource.updateUser(
          userData: tEmail,
          action: UpdateUserAction.email,
        );

        // assert
        verify(
          () => mockUser.updateEmail(
            tEmail,
          ),
        ).called(1);

        verifyNever(
          () => mockUser.updatePhotoURL(any()),
        );
        verifyNever(
          () => mockUser.updateDisplayName(any()),
        );
        verifyNever(
          () => mockUser.updatePassword(any()),
        );

        final user = await cloudStoreClient
            .collection('users')
            .doc(
              mockUser.uid,
            )
            .get();

        expect(user.data()!['email'], tEmail);
      },
    );
    test(
      'should update user username successfully '
      'when no exception is thrown',
      () async {
        // arrange
        when(() => mockUser.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        // act
        await dataSource.updateUser(
          userData: tUsername,
          action: UpdateUserAction.username,
        );

        // assert
        verify(
          () => mockUser.updateDisplayName(
            tUsername,
          ),
        ).called(1);

        verifyNever(
          () => mockUser.updatePhotoURL(any()),
        );
        verifyNever(
          () => mockUser.updateEmail(any()),
        );
        verifyNever(
          () => mockUser.updatePassword(any()),
        );

        final user = await cloudStoreClient
            .collection('users')
            .doc(
              mockUser.uid,
            )
            .get();

        expect(user.data()!['username'], tUsername);
      },
    );
    test(
      'should update user password '
      'when no [Exception] is thrown',
      () async {
        // arrange
        when(() => mockUser.updatePassword(any()))
            .thenAnswer((_) => Future.value());
        when(() => mockUser.reauthenticateWithCredential(any()))
            .thenAnswer((_) async => userCredential);
        when(() => mockUser.email).thenReturn(tEmail);

        // act
        await dataSource.updateUser(
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          }),
          action: UpdateUserAction.password,
        );

        // assert
        verify(() => mockUser.updatePassword(tPassword)).called(1);

        verifyNever(
          () => mockUser.updatePhotoURL(any()),
        );
        verifyNever(
          () => mockUser.updateEmail(any()),
        );
        verifyNever(
          () => mockUser.updateDisplayName(any()),
        );
        final user = await cloudStoreClient
            .collection('users')
            .doc(
              documentReference.id,
            )
            .get();

        // assert
        expect(user.data()!['password'], null);
      },
    );
    test(
      'should update profilePic '
      'when no [Exception] is thrown',
      () async {
        // arrange
        final newProfilePic = File('assets/images/sun.png');

        when(() => mockUser.updatePhotoURL(any()))
            .thenAnswer((invocation) => Future.value());

        // act
        await dataSource.updateUser(
          userData: newProfilePic,
          action: UpdateUserAction.profilePic,
        );

        // assert
        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(
          () => mockUser.updatePassword(any()),
        );
        verifyNever(
          () => mockUser.updateEmail(any()),
        );
        verifyNever(
          () => mockUser.updateDisplayName(any()),
        );

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });

  group('signOut', () {
    test(
      'should complete successfully, '
      'when no exception is thrown',
      () async {
        //arrange
        when(() => authClient.signOut())
            .thenAnswer((_) async => Future.value());

        // act
        final call = dataSource.signOut();

        // assert
        expect(
          call,
          completes,
        );

        verify(
          () => authClient.signOut(),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] '
      'when authClient throws [FirebaseAuthException]',
      () async {
        //arrange
        when(() => authClient.signOut()).thenThrow(tFirebaseAuthException);

        //act
        final call = dataSource.signOut;

        // assert
        expect(
          call,
          throwsA(
            isA<ServerException>(),
          ),
        );

        verify(
          () => authClient.signOut(),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
  });
}
