import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/events.dart';
//import 'package:table_calendar/table_calendar.dart';
//import 'package:flutter_application_1/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Calendar_Page.dart';

String fromDateTime(DateTime t) {
  return "${t.toUtc().day}-${t.toUtc().month}-${t.toUtc().year}";
}

// ignore: must_be_immutable, camel_case_types
class Calendar_Page_Loader extends StatefulWidget {
  const Calendar_Page_Loader({super.key});

  @override
  State<Calendar_Page_Loader> createState() => _Calendar_Page_LoaderState();
}

class _Calendar_Page_LoaderState extends State<Calendar_Page_Loader> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //store the events created
    Map<String, List<Event>> events = {};
    return Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("Events").snapshots(),
            builder: (context, snapshot) {
              debugPrint(
                  "hi I'm going to process a snapshot now ${snapshot.connectionState}");
              events.clear();
              if (snapshot.connectionState != ConnectionState.waiting) {
                debugPrint("connection is done");
                if (snapshot.data != null) {
                  debugPrint(
                      "snapshot is not null length= ${snapshot.data!.docs.length}");
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    Map<String, dynamic> m = snapshot.data!.docs[i].data();
                    if (m["time"] == null) {
                      continue;
                    }
                    DateTime t = m["time"]?.toDate() ?? DateTime.now();
                    String date = fromDateTime(t);
                    // DateTime t = DateTime.now();
                    // t = t.add(Duration(days: i));
                    if (events[date]?.isNotEmpty ?? false) {
                      events[date]!.add(Event(m["name"] ?? "no name"));
                    } else {
                      events[date] = [Event(m["name"] ?? "no name")];
                    }
                    for (String keys in m.keys) {
                      debugPrint("doc $i: key: $keys data: ${m[keys]}");
                    }
                    debugPrint("$t and ${events[t]}");
                  }
                }
              }
              User? currentUser = FirebaseAuth.instance.currentUser;
              return Calendar_Page(events: events, userId: currentUser!.uid);
            }));
  }
}
