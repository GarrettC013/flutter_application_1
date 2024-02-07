//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/events.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/FirestoreService.dart';
//import 'package:flutter_application_1/CustomBottomNav.dart';

// ignore: must_be_immutable, camel_case_types
class Calendar_Page extends StatefulWidget {
  Calendar_Page({super.key});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  DateTime today = DateTime.now();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //store the events created
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from selected day
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
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
                        //store the event name into the map
                        events.addAll({
                          _selectedDay!: [Event(_eventController.text)]
                        });
                        await FirestoreService.addEventData(
                            _eventController.text);
                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
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

  Widget content() {
    return Column(
      children: [
        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 43,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
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
        SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () => print(""),
                          title: Text('${value[index]}'),
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
