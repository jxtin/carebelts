import 'package:CareBelts/src/classes.dart';
import 'package:CareBelts/globals.dart';
import 'package:CareBelts/utils/helperfunctions.dart';

import 'package:intl/intl.dart';
import 'dart:async';

// Process the rows
Future<List<HeartRateData>> updateBandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<HeartRateData> values = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--)
    values.add(HeartRateData(
        allRows[i]['doc']['value'],
        DateFormat("dd-MM-yy hh:mm:ss")
            .parse(allRows[i]['key'].replaceAll("/", "-"))));

  return values;
}

// Sign in method
Future<Map<String, dynamic>> signIn(String dbName, String password) async {
  late Map<String, dynamic> results;
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  if (!(await checkDB(dbName, IAM_Token)))
    return {"status": false, 'reason': 'error'};

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
