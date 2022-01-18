import 'package:CareBelts/utils/helperfunctions.dart';
import 'package:CareBelts/src/classes.dart';
import 'package:CareBelts/globals.dart';

import 'package:intl/intl.dart';
import 'dart:async';

// Process the rows
Future<List<HeartRateData>> updateHRBandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<HeartRateData> hrValues = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    hrValues.add(HeartRateData(allRows[i]['doc']['hr_value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  return hrValues;
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

// Process the rows
Future<List<List<dynamic>>> updateBandData(String db) async {
  List<List<dynamic>> allData = [];
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<TemperatureData> tempValues = [];
  List<HealthIndexData> indexValues = [];
  List<HeartRateData> hrValues = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    hrValues.add(HeartRateData(allRows[i]['doc']['hr_value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
    indexValues.add(HealthIndexData(allRows[i]['doc']['health_index'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
    tempValues.add(TemperatureData(allRows[i]['doc']['temperature_value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  allData.add([hrValues, tempValues, indexValues]);
  return allData;
}

// Sign up function for the user
Future<bool> signUp(String dbName, String age, String password) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  // Check if new database is created
  bool dbCreated = await createDB(dbName, IAM_Token);

  // Return false if new database is not created
  if (!dbCreated) return false;

  // Add attributes to the created database
  return await addToKEY_PASS(dbName, age, password, IAM_Token);
}

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
