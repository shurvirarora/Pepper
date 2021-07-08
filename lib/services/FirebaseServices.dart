import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class FirebaseServices {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('Messages');

  Stream<DocumentSnapshot> getMessageSnapshots() {
    return messagesCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> getUserSnapshots() {
    return userCollection.doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getSpecificChatSnapshots(String id) {
    return messagesCollection.doc(uid).collection(id).snapshots();
  }
}
