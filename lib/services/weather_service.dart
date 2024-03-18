import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final lat = 39.2;
    final lon = -76;
    print('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey');
    final response = await http.get(
        Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //Get permission from user to use location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //Convert location to placemark object
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //get city name from placemark
    String? city = placemark[0].locality;

    return city ?? "";
  }
}
