import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.photoUrl,
  });

  factory LocalUserModel.empty() => const LocalUserModel(
        id: '_empty.id',
        email: '_empty.email',
        username: '_empty.username',
        photoUrl: null,
      );

  factory LocalUserModel.fromMap(DataMap map) => LocalUserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        photoUrl: map['photoUrl'] as String?,
      );

  DataMap toMap() => {
        'id': id,
        'email': email,
        'username': username,
        'photoUrl': photoUrl,
      };

  LocalUserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? photoUrl,
  }) {
    return LocalUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() =>
      '$LocalUserModel(id: $id, email: $email, username: $username, '
      'photoUrl: $photoUrl)';
}
