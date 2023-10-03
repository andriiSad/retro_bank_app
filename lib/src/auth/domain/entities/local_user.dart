import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.id,
    required this.email,
    required this.username,
    required this.photoUrl,
  });

  factory LocalUser.empty() => const LocalUser(
        id: '_empty.id',
        email: '_empty.email',
        username: '_empty.username',
        photoUrl: null,
      );

  final String id;
  final String email;
  final String username;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, email, username, photoUrl];
}
