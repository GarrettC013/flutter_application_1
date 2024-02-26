// import 'package:flutter/material.dart';
// import "CustomBottomNav.dart";
import 'package:flutter_application_1/Pages/Login_Page.dart';
// import 'FirestoreService.dart';
// import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FirestoreService.initializeFirebase(
//       options: DefaultFirebaseOptions.currentPlatform);
//   // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyLoginApp()));
//   runApp(const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BottomNavigationBarExampleApp()));
// }
//StreamBuilder
//stream: firebaseauth.instance.onAuthStateChanged

import 'package:flutter/material.dart';
import 'CustomBottomNav.dart';
import 'FirestoreService.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirestoreService.initializeFirebase(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      home: _getLandingPage(),
    );
  }

  Widget _getLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong!"));
        } else if (snapshot.hasData) {
          return BottomNavigationBarExampleApp(snapshot.data?.uid ?? "-");
        } else {
          return LoginPage();
        }
      },
    );
  }
}
