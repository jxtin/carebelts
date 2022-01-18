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

// Function for alexa virtual button api call
Future<void> dogFeederRequest(bool status) async {
  String command = status ? "on" : "off";
  final response =
      await http.post(Uri.parse("https://pawllar.jxt1n.repl.co/dispense_food"),
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            "accessCode": accesCodeAlexa,
            "command": command,
          }));
  print(response.statusCode);
}

// Function for alexa virtual button api call
Future<void> alexaVirtualButtonCall(num vb) async {
  final response =
      await http.post(Uri.parse("https://api.virtualbuttons.com/v1"),
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            "virtualButton": vb,
            "accessCode": accesCodeAlexa,
          }));
  print(response.statusCode);
}

// Create a new db via request
Future<bool> createDB(String dbName, String IAM_Token) async {
  final response = await http.get(Uri.parse('$dbURL/$dbName'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $IAM_Token"});

  return (response.statusCode.toString() == '201');
}

// Add to the key_pass db
Future<bool> addToKEY_PASS(
    String dbName, String age, String password, String IAM_Token) async {
  final response = await http.put(Uri.parse('$dbURL/$dbName'), headers: {
    HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
    HttpHeaders.contentTypeHeader: "application/json"
  }, body: <String, dynamic>{
    "username": dbName,
    "age": age,
    "password": password
  });

  return (response.statusCode.toString() == '201');
}
