import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(String uid, String username, String email, String? photoUrl) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'photoUrl': photoUrl ?? '',
        'lastSeen': FieldValue.serverTimestamp(), 
      }, SetOptions(merge: true)); 
    } catch (e) {
      print("Erreur lors de la sauvegarde de l'utilisateur : ${e.toString()}");
    }
  }

  Future<void> sendMessage(String senderId, String senderName, String text, String? senderPhoto) async {
    try {
      if (text.trim().isEmpty) return; 

      await _db.collection('messages').add({
        'senderId': senderId,
        'senderName': senderName,
        'senderPhoto': senderPhoto ?? '',
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(), 
      });
    } catch (e) {
      print("Erreur lors de l'envoi du message : ${e.toString()}");
    }
  }

  Stream<QuerySnapshot> getMessagesStream() {
    return _db
        .collection('messages')
        .orderBy('timestamp', descending: true) 
        .snapshots();
  }
}