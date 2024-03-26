import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> savePin(String userId, String pin) async {
    await _userCollection.doc(userId).set({'pin': pin});
  }

  Future<bool> verifyPin(String userId, String enteredPin) async {
    final snapshot = await _userCollection.doc(userId).get();
    final storedPin =
        (snapshot.data() as Map<String, dynamic>?)?['pin'] as String?;
    return storedPin == enteredPin;
  }
}
