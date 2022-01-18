import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Heart rate data class
class HeartRateData {
  HeartRateData(this.HeartRate, this.datetime);
  final int HeartRate;
  final DateTime datetime;
}

// Health check calculation class
class HealthCheck {
  final List<HeartRateData> data;
  late int average;
  late Color color;

  // Constructor
  HealthCheck(this.data) {
    this.calculate();
    if (this.average < 75 || this.average > 120)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    int sum = 0;
    for (int count = 0; count < data.length; count++)
      sum += data[count].HeartRate;
    // Get the average
    average = sum ~/ data.length;
  }
}

// Initial 0 DateTime HeartRateData
List<HeartRateData> getChartData() {
  List<HeartRateData> values = [];
  for (int count = 0; count < 10; count++)
    values.add(HeartRateData(0, DateTime(2000, 01, 01, 0, 0, count)));
  return values;
}
