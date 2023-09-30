import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
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
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword({required String email}) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser({
    required userData,
    required UpdateUserAction action,
  }) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
