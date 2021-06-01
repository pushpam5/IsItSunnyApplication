import 'package:flutter/material.dart';

class WeatherReport {
  String city;
  double temperature;
  double max_temperature;
  double min_temperature;
  String description;

  WeatherReport(
      this.city,
      this.temperature,
      this.max_temperature,
      this.min_temperature,
      this.description);
}
