import 'package:CareBelts/src/classes.dart';
import 'package:CareBelts/globals.dart';

import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Initial 0 DateTime Data
List<HeartRateData> hrZero() {
  List<HeartRateData> hrZeroData = [];
  for (int count = 0; count < 10; count++)
    hrZeroData.add(HeartRateData(0, DateTime(2000, 01, 01, 0, 0, count)));

  return hrZeroData;
}

List<TemperatureData> temperatureZero() {
  List<TemperatureData> temperatureZeroData = [];
  for (int count = 0; count < 10; count++)
    temperatureZeroData
        .add(TemperatureData(0, DateTime(2000, 01, 01, 0, 0, count)));
  return temperatureZeroData;
}

List<SpO2Data> spo2Zero() {
  List<SpO2Data> spo2ZeroData = [];
  for (int count = 0; count < 10; count++)
    spo2ZeroData.add(SpO2Data(0, DateTime(2000, 01, 01, 0, 0, count)));
  return spo2ZeroData;
}

List<HealthIndexData> indexZero() {
  List<HealthIndexData> indexZeroData = [];
  for (int count = 0; count < 10; count++)
    indexZeroData.add(HealthIndexData(0, DateTime(2000, 01, 01, 0, 0, count)));
  return indexZeroData;
}

// Get IAM token
Future<String> getIAMToken(String IAM_api_key) async {
  // Cloudant
  // String IAM_api_key = "9jtFMX0LC5cab8x5I5OYermeMeDYf0hQKCegLnT0z50L";
  final response = await http.post(
      Uri.parse('https://iam.cloud.ibm.com/identity/token'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body:
          "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$IAM_api_key");

  final responseJson = jsonDecode(response.body);
  return responseJson['access_token'];
}

// Get data from cloudant
Future<Map<String, dynamic>> fetchCloudantData(String db) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  final response = await http.post(Uri.parse('$dbURL/$db/_all_docs'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "include_docs": true,
        "descending": true,
        "limit": 10,
      }));

  final responseJson = jsonDecode(response.body);

  return responseJson;
}

// Get document specific data from a db
Future<Map<String, dynamic>> fetchDocDB(String db, String doc_id) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  final response =
      await http.get(Uri.parse('$dbURL/$db/$doc_id'), headers: <String, String>{
    HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  final responseJson = jsonDecode(response.body);

  return responseJson;
}

// Check db existence
Future<bool> checkDB(String dbName, String IAM_Token) async {
  final response = await http.get(Uri.parse('$dbURL/$dbName'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $IAM_Token"});

  print(response.statusCode);
  return (response.statusCode.toString() == '200');
}

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
