import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/extensions/credit_card_extension.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class LocalUser extends Equatable {
  LocalUser({
    required this.id,
    required this.email,
    required this.username,
    required this.cards,
    required this.photoUrl,
  }) : totalBalance = cards.totalBalance;

  factory LocalUser.empty() => LocalUser(
        id: '_empty.id',
        email: '_empty.email',
        username: '_empty.username',
        cards: const [],
        photoUrl: null,
      );

  final String id;
  final String email;
  final String username;
  final List<CreditCard> cards;
  final String? photoUrl;
  final int totalBalance;

  @override
  List<Object?> get props => [id, email, username, cards, photoUrl];
}
