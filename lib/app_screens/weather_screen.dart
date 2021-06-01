import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../models/weather_report.dart';
import '../common_widgets/common_widgets.dart';

class Weather extends StatefulWidget {
  static final routename = 'weather-screen';

  @override
  _WeatherState createState() => _WeatherState();
}

WeatherReport data;

class _WeatherState extends State<Weather> {


  Future<WeatherReport> getWeather(String city) async {
    String url = "$serverUrl/userWeatherData/?city=$city";
    try {
      http.Response resp =
      await http.get(url, headers: {"Content-Type": "application/json"});
      if (resp.statusCode == 200) {
        var responseData = json.decode(resp.body);
        data = WeatherReport(
            responseData[0]['city'],
            (responseData[0]['weather']['temp'] - 273.00),
            responseData[0]['weather']['temp_max'] - 273.00,
            responseData[0]['weather']['temp_min'] - 273.00,
            responseData[0]['weather']['description']);
        return data;
      } else {
        displayDialog(context, "Error Occured", "Please Try Again",
            barrierDisbarrierDismissible: false);
      }
    } on SocketException {
      displayDialog(context, "No Internet Connection",
          "Please Check Your Internet Settings");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    final Map args = ModalRoute
        .of(context)
        .settings
        .arguments;
    String imagename = args['image'];
    String city = args['title'];

    final _random = Random();
    const int $deg = 0x00B0;
    return FutureBuilder(
      future: getWeather(imagename),
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.data == null) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(

                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme
                      .of(context)

                      .primaryColor,
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: height,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                              AssetImage('assets/images/${imagename}.jpg'),
                              alignment: Alignment.center,
                              fit: BoxFit.fitHeight)),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(_random.nextInt(256),
                                  _random.nextInt(256), _random.nextInt(256),
                                  0.8),
                              Color.fromRGBO(_random.nextInt(256),
                                  _random.nextInt(256), _random.nextInt(256),
                                  0.6),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.4, 0.7, 1],
                          )),
                    ),
                    Positioned(
                      top: height / 8,
                      left: width / 4,
                      right: width / 4,
                      child: Container(
                        height: height,
                        child: Column(
                          children: [
                            Text(city,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 30),
                            Text(
                              DateFormat('EEEE')
                                  .format(DateTime.now())
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat("MMMM d y")
                                  .format(DateTime.now())
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 40),
                            Text(
                              "${snapShot.data.temperature.round()}\u00B0 c",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "-------",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: Text(

                                snapShot.data.description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Text(
                              "${snapShot.data.min_temperature
                                  .round()}\u00B0 c / ${snapShot.data
                                  .max_temperature.round()}\u00B0 c",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20,),
                            Container(
                                height: 100,
                                child: Image.asset(
                                  snapShot.data.temperature.round() <= 15 ?
                                  './assets/images/snowflake.png' : snapShot
                                      .data.temperature.round() < 30
                                      ? './assets/images/cloudy.png':data.temperature.round() < 35 ?'./assets/images/sun.png':'./assets/images/sunny.png',
                                  scale: 0.5,
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
