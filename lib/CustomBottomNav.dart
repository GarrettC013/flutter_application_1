import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Calendar_Page_Loader.dart';
import 'package:flutter_application_1/Pages/Home_Page_Loader.dart';
import 'package:flutter_application_1/Pages/Video_Page.dart';
import 'package:flutter_application_1/Pages/Groups_Page.dart';
import 'FirestoreService.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirestoreService.initializeFirebase(
      options: DefaultFirebaseOptions.currentPlatform);
}

class BottomNavigationBarExampleApp extends StatefulWidget {
  const BottomNavigationBarExampleApp(this.uid, {super.key});
  final String uid;

  @override
  State<BottomNavigationBarExampleApp> createState() =>
      _BottomNavigationBarExampleAppState();
}

class _BottomNavigationBarExampleAppState
    extends State<BottomNavigationBarExampleApp> {
  final eventController = TextEditingController();
  late String _selectedGroup;

  @override
  void initState() {
    super.initState();
    _selectedGroup = "";
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkSelectedGroup();
    });
  }

  void _checkSelectedGroup() {
    if (_selectedGroup.isEmpty) {
      _showGroupSelectionDialog();
    }
  }

  void _showGroupSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Group'),
          content: Text('You need to select a group to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToGroupsPage();
              },
              child: Text('Select Group'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToGroupsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsPage(
          onGroupSelected: (selectedGroup) {
            setState(() {
              _selectedGroup = selectedGroup;
            });
          },
        ),
      ),
    );
    setState(() {
      _checkSelectedGroup(); // Check if a group is selected after returning
    });
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 1;

  final List _Pages = [
    Video_Page(),
    Home_Page_Loader(),
    Calendar_Page_Loader(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
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
