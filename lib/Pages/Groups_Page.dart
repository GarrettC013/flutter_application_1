import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsPage extends StatefulWidget {
  @override
  JoinGroup createState() => JoinGroup();
}

class JoinGroup extends State<GroupsPage> {
  late List<String> items;
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    // Fetch data from Firestore collection "groups"
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Groups').get();
    List<String> groupsNames = [];
    querySnapshot.docs.forEach((doc) {
      // Add "names" field from each document to the list
      groupsNames.add(doc.get('name'));
    });
    setState(() {
      items = groupsNames;
      selectedItem = groupsNames.isNotEmpty
          ? groupsNames[0]
          : null; // Select the first item by default
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      // Show loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    }
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
            ),
          ],
        ),
      ),
      floatingActionButton: PositionedActionButton(
        onAddGroup: (newGroup) {
          addGroupToFirestore(newGroup);
        },
      ),
    );
  }

  Future<void> addGroupToFirestore(String groupName) async {
    if (items.contains(groupName)) {
      // Display snackbar if group already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group already exists.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Add a new group to the "groups" collection
    await FirebaseFirestore.instance
        .collection('Groups')
        .add({'name': groupName});

    // Create a subcollection called "events" within the newly added group
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('Groups')
        .where('name', isEqualTo: groupName)
        .get()
        .then((value) => value.docs.first.reference);
    await groupRef.collection('Events').add({
      'eventName': 'Example Event', // Example event data
      'eventDate': DateTime.now(), // Example event data
    });

    // Update the UI to reflect the changes
    setState(() {
      items.add(groupName);
    });
  }
}

class PositionedActionButton extends StatelessWidget {
  final Function(String) onAddGroup;

  PositionedActionButton({required this.onAddGroup});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddItem(onAddGroup: onAddGroup);
                },
              );
            },
            tooltip: 'Add Item',
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class AddItem extends StatefulWidget {
  final Function(String) onAddGroup;

  AddItem({required this.onAddGroup});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Group'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter Group Name'),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newGroup = _controller.text;
            widget.onAddGroup(newGroup);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
