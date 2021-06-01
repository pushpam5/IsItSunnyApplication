import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isitsunny/app_screens/city_list_screen.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


import '../common_widgets/common_widgets.dart';

class Preferences extends StatefulWidget {
  static final routeName = 'preferences-screen';

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Map<String, bool> cities = {
    "Bangalore": false,
    "Ahmedabad" :false,
    "Hyderabad": false,
    "Delhi": false,
    "Chennai": false,
    "Mumbai": false,
    "Pune": false,
    "Kolkata": false,
    "Agra":false,
    "Shimla":false
  };
  bool issetting = false;

  List<String> _selectedCities = [];
  Future setPreferences(String username) async{

    setState(() {
      issetting = true;
    });
    String url = "$serverUrl/setUserPreferences";
    try{

      var resp =await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: JsonEncoder().convert({
          "username":username,
          "preferences":_selectedCities
        })
      );
      if(resp.statusCode==200){
        setState(() {
          issetting = false;
        });
        return resp;
      }
      else{
        setState(() {
          issetting = false;
        });
        return null;
      }
    }
    on SocketException{
       return "null";
    }
    catch(e){
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final Map args = ModalRoute.of(context).settings.arguments;
    String username = args['data'];
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height / 8,
              ),
              Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Preferences",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: issetting,
                child: Container(
                  height: height - height/3,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: cities.keys.map((String city) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.5
                              )
                            )
                          ),
                          child: CheckboxListTile(

                              controlAffinity: ListTileControlAffinity.leading,
                              value: cities[city],
                              title: Text(city),

                              onChanged: (bool value) {
                                if(value){
                                  if(_selectedCities.indexOf(city.toLowerCase()) == -1)
                                   {
                                     _selectedCities.add(city.toLowerCase());
                                   }
                                }
                                else{
                                  _selectedCities.remove(city.toLowerCase());
                                }
                                setState(() {
                                  cities[city] = value;
                                });
                              }),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: issetting
                    ? null
                    : () async {
                  if(_selectedCities.length == 0){
                    displayDialog(
                      context,
                      "No Cities Selected",
                      "Please Select Any City",
                      barrierDisbarrierDismissible: true,
                    );
                  }
                  else if(_selectedCities.length > 3){
                    displayDialog(
                      context,
                      "Atmost Three Cities Are Allowed",
                      "Please Select Atmost Three Cities",
                      barrierDisbarrierDismissible: true,
                    );
                  }
                  else{
                  var resp = await setPreferences(username);
                    if (resp == "null") {
                      setState(() {
                        issetting = true;
                      });
                      displayDialog(
                        context,
                        "No Internet Connection",
                        "Please Check Your Internet Settings",
                        barrierDisbarrierDismissible: true,
                      );

                    } else if (resp != null) {
                      Navigator.of(context).pushNamed(
                          CityList.routeName,
                          arguments: {'data': _selectedCities});
                    } else {
                      setState(() {
                        issetting = false;
                      });
                      displayDialog(
                        context,
                        "An Error Occured",
                        "Please Enter Correct Credentials",
                        barrierDisbarrierDismissible: true,
                      );
                    }
                  }},
                child: issetting ?CircularProgressIndicator():Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                  child: Container(
                    width: width - 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
