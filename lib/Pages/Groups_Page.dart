import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/firebase_auth_services.dart';

class GroupsPage extends StatefulWidget {
  @override
  JoinGroup createState() => JoinGroup();
}

class JoinGroup extends State<GroupsPage> {
  @override
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  String? selectedItem = 'Item 1';
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your onPressed logic here
              },
              child: Text('Select'),
            ),
            DropdownButton(
              dropdownColor: Color.fromARGB(255, 255, 255, 255),
              items: items.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedItem = newValue!;
                });
              },
              value: selectedItem,
            )
          ],
        ),
      ),
    );
  }
}
