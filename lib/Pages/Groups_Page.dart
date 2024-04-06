import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String name, id;
  Group(this.name, this.id);
}

class GroupsPage extends StatefulWidget {
  final Function(String)? onGroupSelected;

  GroupsPage({this.onGroupSelected});

  @override
  JoinGroup createState() => JoinGroup();
}

class JoinGroup extends State<GroupsPage> {
  List<Group> items = [];
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    // Fetch data from Firestore collection "Groups"
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Groups').get();
    List<Group> groupsNames = [];
    querySnapshot.docs.forEach((doc) {
      // Add "name" field from each document to the list
      //doc.id
      groupsNames.add(Group(doc.get('name'), doc.id));
    });
    debugPrint("Groups: ${groupsNames.length}");
    setState(() {
      items = groupsNames;
      debugPrint("Items: ${items.length}");
      selectedItem = groupsNames.isNotEmpty
          ? groupsNames[0].id
          : null; // Select the first item by default
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) {
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
                if (selectedItem != null) {
                  debugPrint("Selected Item: ${selectedItem}");
                  widget.onGroupSelected?.call(selectedItem!);
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                }
              },
              child: Text('Select'),
            ),
            DropdownButton(
              dropdownColor: Color.fromARGB(255, 255, 255, 255),
              items: items.map((Group item) {
                return DropdownMenuItem(value: item.id, child: Text(item.name));
              }).toList(),
              onChanged: (String? newValue) {
                debugPrint("New value: ${newValue}");
                setState(() {
                  selectedItem = newValue!;
                });
                widget.onGroupSelected
                    ?.call(newValue!); // Call the callback here
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

    // Add a new group to the "Groups" collection
    DocumentReference doc = await FirebaseFirestore.instance
        .collection('Groups')
        .add({'name': groupName});
    Group g = Group(groupName, doc.id);

    // Create a subcollection called "Events" within the newly added group
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('Groups')
        .where('name', isEqualTo: groupName)
        .get()
        .then((value) => value.docs.first.reference);
    await groupRef.collection('Events').add({
      // 'eventName': 'Example Event', // Example event data
      // 'eventDate': DateTime.now(), // Example event data
    });

    setState(() {
      items.add(g);
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
