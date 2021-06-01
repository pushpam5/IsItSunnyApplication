import 'package:flutter/material.dart';
import 'package:isitsunny/app_screens/preferences_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


import '../common_widgets/common_widgets.dart';

class Login extends StatefulWidget {
  static final routeName = 'login-screen';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool islogging = false;
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final keyboardInsets = MediaQuery.of(context).viewInsets.bottom;


    Future loginAttempt() async {

      setState(() {
        islogging = true;
        _isEnabled = false;
      });
      String url = "$serverUrl/registerUser";
      try{
        var resp =await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: JsonEncoder().convert({
                "username":"$username",
                "password":"$password"
          })
        ).timeout(Duration(seconds: 5));
        if(resp.statusCode==200){
          setState(() {
            islogging = false;
          });
          return resp;
        }
        else{
          setState(() {
            islogging = false;
          });
          return null;
        }
      }
      on SocketException catch (e){
        return "null";
      }
      catch(e){
          return null;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 4),
            Container(
//              height: height / 2,
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text("Signup",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          enabled: _isEnabled,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey.shade500)),
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username Can\'t Be Empty';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            username = value.trimLeft().trimRight();
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          enabled: _isEnabled,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: .5, color: Colors.grey.shade500)),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password Can\'t Be Empty';
                            }
                            return null;
                          },
                          onChanged: (value) {
//                            print(password);
                            password = value.trimLeft().trimRight();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: islogging
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                final form = _form.currentState;
                                if (form.validate()) {
                                  form.save();
                                  var resp = await loginAttempt();
                                  if (resp == "null") {
                                    setState(() {
                                      _isEnabled = true;
                                    });
                                    displayDialog(
                                        context,
                                        "No Internet Connection",
                                        "Please Check Your Internet Settings",
                                      barrierDisbarrierDismissible: true,
                                    );

                                  } else if (resp != null) {
                                    Navigator.of(context).pushReplacementNamed(
                                        Preferences.routeName,
                                        arguments: {'data': username});
                                  } else {
                                    setState(() {
                                      _isEnabled = true;
                                      islogging = false;
                                    });
                                    displayDialog(
                                      context,
                                      "An Error Occured",
                                      "Please Enter Correct Credentials",
                                      barrierDisbarrierDismissible: true,
                                    );
                                  }
                                }
                              },
                        child: islogging ?CircularProgressIndicator():Container(
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
