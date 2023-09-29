import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/extensions/credit_card_extension.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class LocalUser extends Equatable {
  LocalUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.cards = const [],
    this.prifilePic,
  }) : totalBalance = cards.totalBalance;

  factory LocalUser.empty() => LocalUser(
        uid: '_empty.uid',
        email: '_empty.email',
        displayName: '_empty.displayName',
      );

  final String uid;
  final String email;
  final String displayName;
  final List<CreditCard> cards;
  final String? prifilePic;
  final int totalBalance;

  @override
  List<Object?> get props => [uid, email, displayName, cards, prifilePic];

  @override
  String toString() {
    return 'LocalUser(uid: $uid, email: $email, displayName: $displayName, '
        'cards: $cards)';
  }
}
