import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardUtils {
  const DashBoardUtils._();

  static Stream<LocalUserModel> get userDataStream =>
      serviceLocator<FirebaseFirestore>()
          .collection('users')
          .doc(serviceLocator<FirebaseAuth>().currentUser?.uid)
          .snapshots()
          .map(
            (snapShot) => LocalUserModel.fromMap(snapShot.data()!),
          );

  static Stream<List<CreditCardModel>> get creditCardsStream {
    return serviceLocator<FirebaseFirestore>()
        .collection('cards')
        .where(
          'ownerId',
          isEqualTo: serviceLocator<FirebaseAuth>().currentUser?.uid,
        )
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot document) {
        return CreditCardModel.fromMap(
          document.data()! as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  static Stream<List<TransactionModel>> get transactionsStream {
    final currentUserUid = serviceLocator<FirebaseAuth>().currentUser?.uid;
    final query =
        serviceLocator<FirebaseFirestore>().collection('transactions');

    final senderQuery =
        query.where('senderCardOwnerId', isEqualTo: currentUserUid).snapshots();
    final receiverQuery = query
        .where('receiverCardOwnerId', isEqualTo: currentUserUid)
        .snapshots();

    final combinedStream = Rx.combineLatest2<
        QuerySnapshot<Map<String, dynamic>>,
        QuerySnapshot<Map<String, dynamic>>,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      senderQuery,
      receiverQuery,
      (senderSnapshots, receiverSnapshots) {
        return [...senderSnapshots.docs, ...receiverSnapshots.docs];
      },
    );

    return combinedStream
        .map((List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
      return documents.map((DocumentSnapshot<Map<String, dynamic>> document) {
        return TransactionModel.fromMap(
          document.data()!,
        );
      }).toList()
        ..sort((a, b) {
          return b.transactionDate.compareTo(a.transactionDate);
        });
    }).asBroadcastStream();
  }

  static Future<LocalUserModel?> getUser(String userId) async {
    try {
      final docSnapshot = await serviceLocator<FirebaseFirestore>()
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        return LocalUserModel.fromMap(data);
      } else {
        return null; // User document not found
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null; // Error occurred while fetching data
    }
  }

  static Future<List<LocalUserModel>> getUsersByUsername(String input) async {
    try {
      final snapshot = await serviceLocator<FirebaseFirestore>()
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: input)
          .get();

      final users = <LocalUserModel>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        users.add(LocalUserModel.fromMap(data));
      }

      return users;
    } catch (e) {
      print('Error fetching users by username: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  static Future<List<CreditCardModel>> getCardsByOwnerId(String ownerId) async {
    try {
      final snapshot = await serviceLocator<FirebaseFirestore>()
          .collection('cards')
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final cards = <CreditCardModel>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        cards.add(CreditCardModel.fromMap(data));
      }

      return cards;
    } catch (e) {
      print('Error fetching users by username: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }
}
