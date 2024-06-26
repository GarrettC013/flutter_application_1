// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class FirestoreService {
  // Ensure Firebase is initialized
  static Future<void> initializeFirebase(
      {required FirebaseOptions options}) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  // Add data to the 'Events' collection
  static Future<void> addEventData(String eventName,
      {required String userId,
      required Timestamp timestamp,
      required String groupId}) async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('Groups/$groupId/Events');
    await collRef.add({'name': eventName, 'userId': userId, 'time': timestamp});
  }

  // Gets event data for specific user
  static Stream<QuerySnapshot> getEventsForUser(String userId) {
    return FirebaseFirestore.instance
        .collection('Events')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
