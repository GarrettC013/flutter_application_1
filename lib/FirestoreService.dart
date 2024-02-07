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
  static Future<void> addEventData(String eventName) async {
    CollectionReference collRef =
        FirebaseFirestore.instance.collection('Events');
    await collRef.add({'name': eventName});
  }
}
