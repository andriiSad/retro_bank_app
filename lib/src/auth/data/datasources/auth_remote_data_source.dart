import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<void> forgotPassword({
    required String email,
  });
  Future<void> updateUser({
    required dynamic userData,
    required UpdateUserAction action,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }
      //upload the user, if he is not exist in cloudStore
      await _setUserData(user, email);

      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } on ServerException {
      //because ServerException can be thrown if (user == null)
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      throw const ServerException(
        message: 'Error signing out',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(username);

      await userCred.user?.updatePhotoURL(kDefaultAvatar);

      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser!.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.username:
          await _authClient.currentUser!.updateDisplayName(userData as String);
          await _updateUserData({'username': userData});
        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser!.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser!.updatePhotoURL(url);
          await _updateUserData({'prifilePic': url});
        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser!.updatePassword(
            newData['newPassword'] as String,
          );
          await _updateUserData(newData);
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(
    String uid,
  ) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(
    User user,
    String fallbackEmail,
  ) async {
    return _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            id: user.uid,
            email: user.email ?? fallbackEmail,
            username: user.displayName ?? 'Anonymous',
            photoUrl: user.photoURL,
            cards: [
              CreditCardModel.generateNew(
                cardId: generateCardId(),
                ownerId: user.uid,
              ),
            ],
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(
          _authClient.currentUser!.uid,
        )
        .update(data);
  }

  String generateCardId() {
    final random = Random();
    // Generate a random 4-digit ID between 1000 and 9999 (inclusive)
    final id = 1000 + random.nextInt(9000);
    return id.toString();
  }
}
