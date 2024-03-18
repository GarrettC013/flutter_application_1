import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Calendar_Page_Loader.dart';
import 'package:flutter_application_1/events.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable, camel_case_types
class Calendar_Page extends StatefulWidget {
  const Calendar_Page({super.key, required this.events, required this.userId});
  final Map<String, List<Event>> events;
  final String userId;
  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

// ignore: camel_case_types
class _Calendar_PageState extends State<Calendar_Page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime today = DateTime.now();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from selected day
    //print("Events for day Line 30 $day: ${widget.events[fromDateTime(day)]}"); // Added for debugging
    return widget.events[fromDateTime(day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    debugPrint(
        "Selected Day: $selectedDay, Focused Day: $focusedDay"); //Addedd for debugging

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
        print(
            "Events for day (Line 44) $selectedDay: ${_selectedEvents.value}"); // Debug: to see if the events are saving with the day
        print("Debug Line (Line 102) ${widget.events}");

        List<Event> events = _selectedEvents.value;
        print("Events for the $selectedDay: ");
        for (Event event in events) {
          print("  Title: ${event.title}: ");
        }
      });
    }
  }

  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //store the events created
    print("(Line 64)Events in Calendar_Page: ${widget.events}");
    return Scaffold(
      body: content(widget.events),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //show a dialog for user to input event name
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text("Event Name"),
                  content: Padding(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: _eventController,
                      )),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        // Get the current user
                        User? currentUser = _auth.currentUser;

                        if (currentUser != null) {
                          await FirestoreService.addEventData(
                            _eventController.text,
                            timestamp: Timestamp.fromDate(_selectedDay!),
                            userId: currentUser.uid,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            _selectedEvents.value =
                                _getEventsForDay(_selectedDay!);
                          }
                        }
                      },
                      child: Text("Submit"),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget content(Map<String, List<Event>> events) {
    //print("Received events 127 : $events"); // Added for debuging
    return Column(
      children: [
        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 43,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                //print("Selected Events 151: value"); // Added for debugging

                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () => print(""),
                          title: Text('${value[index].title}'),
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
