import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// The app which hosts the home page which contains the calendar on it.
class Calendar_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
    );
  }
}
