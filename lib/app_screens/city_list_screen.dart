import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isitsunny/app_screens/preferences_screen.dart';
import 'package:isitsunny/app_screens/weather_screen.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../common_widgets/common_widgets.dart';

class CityList extends StatefulWidget {
  static final routeName = 'citylist-screen';

  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {


  void fetchUpdates() async{

    var url = "$serverUrl/updateWeatherData";
    var resp = await http.get(url,headers: {"Content-Type": "application/json"});

  }


  Future<void> _updateData() async{
    setState(() {
      fetchUpdates();
    });
  }




  final _random = Random();
  Widget _gridItem(templateName,imagename) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Weather.routename, arguments: {
          'title': templateName,
          'image':imagename
        });
      },
      child: Container(
      child: Stack(
        children: [
//            Container(
//              child:
//                  Image.asset('assets/images/${imagename}.jpg'),
//            ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
              Color.fromRGBO(
              _random.nextInt(256),
                _random.nextInt(256),
                _random.nextInt(256),
                0.8
            ),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.4,1],
              ),
            ),
          ),
          Positioned(
            bottom: 3,
            left: 15,
            right: 15,
            child: Text(
              templateName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(image: AssetImage('assets/images/${imagename}.jpg'),alignment: Alignment.center,fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(15)
      ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final Map args = ModalRoute.of(context).settings.arguments;
    List<String> cities = args['data'];
    return (cities.length==0)?Scaffold(body:Container(
      height: height,
      width: height,
      child: Center(
        child: Text("No Cities Selected",style:TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold,fontSize: 25)),
      ),
    )):Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 8),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,8.0,0,8),
                child: Text(
                  "Select City",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: Container(
                height: height - height/5,
                child: RefreshIndicator(
                  child: GridView.count(crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 30,
                    padding: EdgeInsets.all(20),
                    children: List.generate(cities.length, (index) =>
                    _gridItem(cities[index][0].toUpperCase() + cities[index].substring(1),cities[index].toLowerCase())
                    ),

                  ),
                  onRefresh: _updateData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
