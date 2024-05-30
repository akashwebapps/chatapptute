// ignore_for_file: prefer_final_fields

import 'package:chatapptute/models/ProfileModel.dart';
import 'package:chatapptute/services/profile/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ProfileService _profileService = ProfileService();

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      /* saving the user to firestore */
      /*   _firebaseFirestore.collection("Users").doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
      }); */

      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      _profileService.createProfileData(ProfileModel(
              email: userCredential.user!.email!, uid: userCredential.user!.uid)
          .toCreateMap());

      /* saving the user to firestore */
      /*    _firebaseFirestore.collection("Users").doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
      }); */

      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
