// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:retro_bank_app/core/utils/typedefs.dart';
// import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
// import 'package:retro_bank_app/src/transactions/data/datasources/transactions_remote_datasource.dart';

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// class MockUser extends Mock implements User {
//   String _uid = '_mock.uid';

//   @override
//   String get uid => _uid;

//   set uid(String value) {
//     if (_uid != value) _uid = value;
//   }
// }

// class MockUserCredential extends Mock implements UserCredential {
//   MockUserCredential([User? user]) : _user = user;

//   User? _user;

//   @override
//   User? get user => _user;

//   set user(User? value) {
//     if (_user != value) _user = value;
//   }
// }

// class MockAuthCredential extends Mock implements AuthCredential {}

// void main() {
//   late FirebaseAuth authClient;
//   late FirebaseFirestore cloudStoreClient;

//   late TransactionsRemoteDatasourceImpl dataSource;
//   late DocumentReference<DataMap> documentReference;
//   late UserCredential userCredential;
//   late MockUser mockUser;

//   final tUser = LocalUserModel.empty();

//   setUp(() async {
//     authClient = MockFirebaseAuth();
//     cloudStoreClient = FakeFirebaseFirestore();

//     //get doc ref, but not putting anything there
//     documentReference = cloudStoreClient.collection('users').doc();

//     //put into cloud store tUser, but with uid: documentReference.id
//     await documentReference.set(
//       tUser.copyWith(id: documentReference.id).toMap(),
//     );

//     mockUser = MockUser()..uid = documentReference.id;

//     userCredential = MockUserCredential(mockUser);

//     dataSource = TransactionsRemoteDatasourceImpl(
//       authClient: authClient,
//       cloudStoreClient: cloudStoreClient,
//     );

//     when(() => authClient.currentUser).thenReturn(mockUser);
//   });
// }
