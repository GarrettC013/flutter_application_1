import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Home_Page.dart';
import 'package:flutter_application_1/Pages/Calendar_Page.dart';
import 'package:flutter_application_1/Pages/Video_Page.dart';
import 'FirestoreService.dart';
import 'firebase_options.dart';

void main() async {
  //final storage = FirebaseStorage.instance;
  //final storageRef = FirebaseStorage.instance.ref();

  WidgetsFlutterBinding.ensureInitialized();
  await FirestoreService.initializeFirebase(
      options: DefaultFirebaseOptions.currentPlatform);
  //runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyLoginApp()));
}

class BottomNavigationBarExampleApp extends StatefulWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  State<BottomNavigationBarExampleApp> createState() =>
      _BottomNavigationBarExampleAppState();
}

class _BottomNavigationBarExampleAppState
    extends State<BottomNavigationBarExampleApp> {
  final eventController = TextEditingController();

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 1;

  final List _Pages = [
    Video_Page(),
    Home_Page(),
    Calendar_Page(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar'),
      ),
      body: _Pages[_selectedIndex],
      drawer: const Drawer(backgroundColor: Colors.blue),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Events/Schedule',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
