import 'package:flutter/material.dart';
import 'package:isitsunny/app_screens/preferences_screen.dart';


const serverUrl = "https://isitssunny.herokuapp.com";

void displayDialog(
    BuildContext context,
    String title,
    String text, {
      bool barrierDisbarrierDismissible = false,
    }) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
      ),
      barrierDismissible: barrierDisbarrierDismissible,
    );
