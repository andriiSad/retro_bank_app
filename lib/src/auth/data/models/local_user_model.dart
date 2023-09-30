import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  LocalUserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.cards,
    required super.photoUrl,
  });

  factory LocalUserModel.empty() => LocalUserModel(
        id: '_empty.id',
        email: '_empty.email',
        username: '_empty.username',
        cards: const [],
        photoUrl: null,
      );

  factory LocalUserModel.fromMap(DataMap map) => LocalUserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        username: map['username'] as String,
        cards: (map['cards'] as List<dynamic>)
            .map((card) => CreditCardModel.fromMap(card as DataMap))
            .toList(),
        photoUrl: map['photoUrl'] as String?,
      );

  DataMap toMap() => {
        'id': id,
        'email': email,
        'username': username,
        'cards':
            cards.map((card) => (card as CreditCardModel).toMap()).toList(),
        'photoUrl': photoUrl,
      };

  LocalUserModel copyWith({
    String? id,
    String? email,
    String? username,
    List<CreditCardModel>? cards,
    String? photoUrl,
  }) {
    return LocalUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      cards: cards ?? this.cards,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
