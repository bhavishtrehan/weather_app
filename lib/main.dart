import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat.yMMMMd().format(currentDate);

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
                      Center(
                        child: Text(
                          '$formattedDate',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'SourceSans3'),
                        ),
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
                                  fontSize: 60,
                                  fontFamily: 'SourceSans3',
                                  color: Colors.white),
                            );
                          }
                        },
                      ),
                      Expanded(
                        flex: 10,
                        child: Image(
                          image: AssetImage('images/sunnyy.png'),
                          height: 500,
                          width: 300,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: fetchWeatherData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              double temperature =
                                  snapshot.data?['current']['temp_c'];
                              int temp = temperature.toInt();
                              return Text(
                                " $temp°",
                                style: TextStyle(
                                    fontSize: 110,
                                    color: Colors.white,
                                    // fontWeight: FontWeight.w600,
                                    fontFamily: 'Work Sans'),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFF0E55B7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: fetchWeatherData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      final wind =
                                          snapshot.data?['current']['humidity'];
                                      return Text(
                                        "  $wind%",
                                        style: TextStyle(
                                            fontFamily: 'SourceSans3',
                                            color: Colors.white,
                                            fontSize: 15),
                                      );
                                    }
                                  },
                                ),
                                Icon(
                                  Ionicons.water_outline,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Humidity',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                  fontSize: 100,
                                  color: Colors.white24,
                                  fontWeight: FontWeight.w100),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: fetchWeatherData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      final wind =
                                          snapshot.data?['current']['wind_kph'];
                                      return Text(
                                        "$wind km/h",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'SourceSans3',
                                            color: Colors.white),
                                      );
                                    }
                                  },
                                ),
                                Icon(
                                  WeatherIcons.windy,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Wind',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 15),
                                )
                              ],
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                  fontSize: 100,
                                  color: Colors.white24,
                                  fontWeight: FontWeight.w100),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: fetchWeatherData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      final ppt = snapshot.data?['current']
                                          ['precip_mm'];
                                      return Text(
                                        "  $ppt mm",
                                        style: TextStyle(
                                            fontFamily: 'SourceSans3',
                                            color: Colors.white,
                                            fontSize: 15),
                                      );
                                    }
                                  },
                                ),
                                Icon(
                                  WeatherIcons.sprinkle,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Precipitation',
                                  style: TextStyle(
                                      fontFamily: 'SourceSans3',
                                      color: Colors.white,
                                      fontSize: 15),
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
      "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=28.7197355,77.0663015";

  final response = await http.get(Uri.parse(apiUrl));
  debugPrint('$latitude,$longitude');

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load weather data");
  }
}
