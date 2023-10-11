import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

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
  static Stream<List<CreditCardModel>> get creditCardsStream =>
      serviceLocator<FirebaseFirestore>()
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
