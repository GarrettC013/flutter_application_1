//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Calendar_Page_Loader.dart';
import 'package:flutter_application_1/events.dart';
import 'package:flutter_application_1/models/weather_model.dart';
import 'package:flutter_application_1/services/weather_service.dart';

// class EventFetcher {
//   static List<Event> getEventsForDay(
//     Map<String, List<Event>> events,
//     DateTime day,
//   ) {
//     return events[fromDateTime(day)] ?? [];
//   }
// }

class Home_Page extends StatefulWidget {
  const Home_Page({super.key, required this.events, required this.userId});

  final Map<String, List<Event>> events;
  final String userId;
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  //API Key
  final _weatherService = WeatherService('90ea71efc87f21a78fcd28e5ce69802f');
  late Weather _weather;

  //get weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();
    //print('Line 33:' + cityName);
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //error catching
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    _weather = Weather.empty();
    //get weather on start up
    _fetchWeather();
  }

  Widget build(BuildContext context) {
    int? temp_F = _weather?.temperature.round();
    temp_F = ((temp_F! * 1.8) + 32).round();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city..."),

            //Temp
            Text('${temp_F.toString()} F'),
          ],
        ),
      ),
    );
  }
}
