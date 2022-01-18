import 'package:CareBelts/src/classes.dart';
import 'package:CareBelts/globals.dart';
import 'package:CareBelts/utils/helperfunctions.dart';

import 'package:intl/intl.dart';
import 'dart:async';

// Sign in method
Future<Map<String, dynamic>> signIn(String dbName, String password) async {
  late Map<String, dynamic> results;
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  if (!(await checkDB(dbName, IAM_Token))) {
    return {"status": false, 'reason': 'error'};
  }
  // Get the database's data
  Map<String, dynamic> logInCheck = await fetchDocDB("key_pass", dbName);

  if (password != logInCheck['password']) {
    return {"status": false, 'reason': 'password'};
  }

  // Clean and give data
  results = {
    "status": true,
    "age": logInCheck['age'],
    "username": dbName,
  };
  return results;
}

// Process the rows
Future<List<TemperatureData>> updateTemperatureBandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<TemperatureData> temperatureValues = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    temperatureValues.add(TemperatureData(
        allRows[i]['doc']['temperature_value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  return temperatureValues;
}

// Process the rows
Future<List<SpO2Data>> updateSpO2BandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<SpO2Data> spo2Values = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    spo2Values.add(SpO2Data(allRows[i]['doc']['spo2_value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  return spo2Values;
}

// Process the rows
Future<List<HealthIndexData>> updateHealthIndexBandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<HealthIndexData> indexValues = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    indexValues.add(HealthIndexData(allRows[i]['doc']['health_index'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  return indexValues;
}
