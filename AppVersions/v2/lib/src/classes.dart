import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Heart rate data class
class HeartRateData {
  HeartRateData(this.HeartRate, this.datetime);
  final num HeartRate;
  final DateTime datetime;
}

// SpO2 data class
class SpO2Data {
  SpO2Data(this.SpO2, this.datetime);
  final num SpO2;
  final DateTime datetime;
}

// Temperature data class
class TemperatureData {
  TemperatureData(this.Temperature, this.datetime);
  final num Temperature;
  final DateTime datetime;
}

// Health Index data class
class HealthIndexData {
  HealthIndexData(this.HealthIndex, this.datetime);
  final num HealthIndex;
  final DateTime datetime;
}

// Heart check calculation class
class HeartCheck {
  final List<HeartRateData> data;
  late num average;
  late Color color;

  // Constructor
  HeartCheck(this.data) {
    this.calculate();
    if (this.average < 75 || this.average > 120)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    num sum = 0;
    for (int count = 0; count < data.length; count++)
      sum += data[count].HeartRate;
    // Get the average
    average = sum ~/ data.length;
  }
}

// Temperature check calculation class
class TemperatureCheck {
  final List<TemperatureData> data;
  late num average;
  late Color color;

  // Constructor
  TemperatureCheck(this.data) {
    this.calculate();
    if (this.average < 98 || this.average > 106)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    num sum = 0;
    for (int count = 0; count < data.length; count++)
      sum += data[count].Temperature;
    // Get the average
    average = sum ~/ data.length;
  }
}

// SpO2 check calculation class
class SpO2Check {
  final List<SpO2Data> data;
  late num average;
  late Color color;

  // Constructor
  SpO2Check(this.data) {
    this.calculate();
    if (this.average < 97)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    num sum = 0;
    for (int count = 0; count < data.length; count++) sum += data[count].SpO2;
    // Get the average
    average = sum ~/ data.length;
  }
}

// Health index check calculation class
class HealthIndexCheck {
  final List<HealthIndexData> data;
  late num average;
  late Color color;

  // Constructor
  HealthIndexCheck(this.data) {
    this.calculate();
    if (this.average < 80)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    num sum = 0;
    for (int count = 0; count < data.length; count++)
      sum += data[count].HealthIndex;
    // Get the average
    average = sum ~/ data.length;
  }
}
