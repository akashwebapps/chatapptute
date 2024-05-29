// ignore_for_file: prefer_final_fields

import 'package:chatapptute/models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((docs) {
        final user = docs.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, String message) async {
    String currentUserId = _auth.currentUser!.uid;
    String currentUseremail = _auth.currentUser!.email!;

    final Timestamp timestamp = Timestamp.now();

    Message obj = Message(
        senderId: currentUserId,
        senderEmail: currentUseremail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(obj.toMap());
  }

  Stream<QuerySnapshot> getMessages(String otherUserId) {
    String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
