import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xFF010C1E),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                width: double.infinity,
                height: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50), bottom: Radius.circular(60)),
                  color: Color(0xFF1379F5),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'September 15, 2023',
                        style: TextStyle(
                            fontFamily: 'SourceSans3',
                            color: Colors.white38,
                            fontSize: 20),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchWeatherData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            final place = snapshot.data?['location']['region'];
                            return Text(
                              "$place",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'SourceSans3',
                                  color: Colors.white),
                            );
                          }
                        },
                      ),
                      Image(
                        image: AssetImage('images/sunny.png'),
                        height: 300,
                        width: 300,
                      ),
                      Expanded(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: fetchWeatherData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              final temperature =
                                  snapshot.data?['current']['temp_c'];
                              return Text(
                                "Temperature: $temperature°C",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontFamily: 'SourceSans3'),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 140,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E55B7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Wind',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 20),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Humidity',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 20),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Precipitation',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 20),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Location location = Location();

LocationData? _locationData;

Future<void> getLocation() async {
  try {
    _locationData = await location.getLocation();
  } catch (e) {
    print("Error getting location: $e");
  }
}

Future<Map<String, dynamic>> fetchWeatherData() async {
  final apiKey = "8c5560cb2d3c40a6bca185246231909";
  final latitude = _locationData?.latitude;
  final longitude = _locationData?.longitude;
  final apiUrl =
      "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude";

  final response = await http.get(Uri.parse(apiUrl));
  debugPrint('$latitude,$longitude');

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load weather data");
  }
}
