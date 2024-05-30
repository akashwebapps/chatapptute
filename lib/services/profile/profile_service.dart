import 'package:chatapptute/helper/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/ProfileModel.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createProfileData(Map<String, dynamic> model,
      {bool isUpdate = false}) async {
    try {
      if (isUpdate) {
        await _firebaseFirestore
            .collection("Users")
            .doc(_auth.currentUser?.uid)
            .update(model);
      } else {
        await _firebaseFirestore
            .collection("Users")
            .doc(_auth.currentUser?.uid)
            .set(model);
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    //   getdata();
    return _firebaseFirestore
        .collection("Users")
        .doc(_auth.currentUser?.uid)
        .snapshots();
  }

  Future<void> getdata() async {
    try {
      var userDoc = await _firebaseFirestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data();
        if (userData != null) {
          CustomLogger.debug('user details  -> ${userDoc.id} => $userData');
        } else {
          CustomLogger.debug('Document data is null for user ${userDoc.id}');
        }
      } else {
        CustomLogger.debug(
            'No document found for user ${FirebaseAuth.instance.currentUser!.uid}');
      }
    } catch (e) {
      CustomLogger.debug('Error fetching user details: $e');
    }
  }
}
