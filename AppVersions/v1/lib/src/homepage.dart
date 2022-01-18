import 'package:CareBelts/src/loginpage.dart' show LoginPage;
import 'package:CareBelts/utils/requests.dart';
import 'package:CareBelts/src/classes.dart';
import 'package:CareBelts/utils/helperfunctions.dart';
import 'package:CareBelts/globals.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// Home page of the app
class HomePage extends StatefulWidget {
  final String db;
  final int temperature, age;

  HomePage(
      {Key? key, this.db = "track_data", this.temperature = 37, this.age = 5})
      : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(this.db, this.temperature, this.age);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.db, this.temperature, this.age);

  // Variables to be accepted
  final String db;
  final int temperature, age;
  late String dogFeederStatus;

  // Variables to be used later
  late List<HeartRateData> hrValues;
  late List<TemperatureData> temperatureValues;
  late List<SpO2Data> spo2Values;
  late List<HealthIndexData> indexValues;

  late List<HeartCheck> hrParameter;
  late List<TemperatureCheck> temperatureParameter;
  late List<SpO2Check> spo2Parameter;
  late List<HealthIndexCheck> indexParameter;

  late String displayHR;
  late String displayTemperature;
  late String displaySpO2;
  late String displayIndex;

  late int i;
  late String status_image;
  late String healthStatus;
  late Timer _timer;

  @override
  void initState() {
    // Load the data every 1 second
    Timer.periodic(const Duration(seconds: 1), loadChartData);
    i = 0;

    // Get initial data
    hrValues = hrZero();
    temperatureValues = temperatureZero();
    spo2Values = spo2Zero();
    indexValues = indexZero();

    hrParameter = [HeartCheck(hrValues)];
    temperatureParameter = [TemperatureCheck(temperatureValues)];
    spo2Parameter = [SpO2Check(spo2Values)];
    indexParameter = [HealthIndexCheck(indexValues)];

    displayHR = "";
    displayTemperature = "";
    displaySpO2 = "";
    displayIndex = "";
    status_image = "optimal.png";
    healthStatus = "You are good to go!";

    // Start the main application
    super.initState();
  }

  // Load data function to update the source of the SFCartesian graph
  void loadChartData(Timer timer) async {
    _timer = timer;
    // Get the database values
    List<HeartRateData> hrTemp = await updateHRBandData(this.db);
    List<TemperatureData> temperatureTemp =
        await updateTemperatureBandData(this.db);
    List<SpO2Data> spo2Temp = await updateSpO2BandData(this.db);
    List<HealthIndexData> indexTemp = await updateHealthIndexBandData(this.db);

    // Update values to the data source of the SFCartesian
    for (int j = 0; j < 10; j++) {
      hrValues.add((hrTemp[j]));
      hrValues.removeAt(0);
      temperatureValues.add((temperatureTemp[j]));
      temperatureValues.removeAt(0);
      spo2Values.add((spo2Temp[j]));
      spo2Values.removeAt(0);
      indexValues.add((indexTemp[j]));
      indexValues.removeAt(0);
    }

    // Update values to the data source of the SfCircular
    HeartCheck newHeart = HeartCheck(hrValues);
    TemperatureCheck newTemperature = TemperatureCheck(temperatureValues);
    SpO2Check newSpO2 = SpO2Check(spo2Values);
    HealthIndexCheck newIndex = HealthIndexCheck(indexValues);

    // Set state
    setState(
      () {
        hrParameter.removeAt(0);
        hrParameter.add(newHeart);

        temperatureParameter.removeAt(0);
        temperatureParameter.add(newTemperature);

        spo2Parameter.removeAt(0);
        spo2Parameter.add(newSpO2);

        indexParameter.removeAt(0);
        indexParameter.add(newIndex);

        displayHR = hrParameter[0].average.toString();
        displayTemperature = temperatureParameter[0].average.toString();
        displaySpO2 = spo2Parameter[0].average.toString();
        displayIndex = indexParameter[0].average.toString();

        if (indexParameter[0].average < 80) {
          healthStatus = "Health is not in optimal state";
          status_image = "not_optimal.png";
        } else {
          healthStatus = "You are good to go!";
          status_image = "optimal.png";
        }
      },
    );
  }

  // Setting up title text style
  static const titleStyle =
      TextStyle(fontFamily: "Cotton Butter", fontSize: 72);

  @override
  Widget build(BuildContext context) {
    // Caching images
    precacheImage(AssetImage(PROFILE_PICTURE), context);
    precacheImage(AssetImage(NOT_OPTIMAL_IMAGE), context);
    precacheImage(AssetImage(OPTIMAL_IMAGE), context);

    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Making 3 tab application
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: Text(APP_TITLE, style: titleStyle),
          centerTitle: true,
        ),
        // Navigation bar configuration
        bottomNavigationBar: Container(
          color: Colors.black,
          child: TabBar(
            labelStyle: TextStyle(fontFamily: "Dandelion", fontSize: 28),
            unselectedLabelStyle:
                TextStyle(fontFamily: "Dandelion", fontSize: 28),
            labelColor: Colors.blue.shade200,
            unselectedLabelColor: Colors.grey[700],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue.shade200,
            tabs:
                // Setting up tab visual attributes ( icon )
                <Widget>[
              Tab(
                height: screenHeight / 15,
                icon: Icon(Icons.analytics_outlined),
              ),
              Tab(
                height: screenHeight / 15,
                icon: Icon(Icons.circle_notifications_outlined),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue.shade300),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 5, color: Colors.blue.shade100),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        PROFILE_PICTURE,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "USERNAME",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$db",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "AGE",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$age",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "TEMPERATURE",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$displayTemperature F",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "HEARTRATE",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$displayHR BPM",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "SPO2",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$displaySpO2%",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white)),
                    primary: Colors.blue.shade300,
                  ),
                  child: Text(" Log out ",
                      style: TextStyle(
                        fontFamily: "BebasNeue",
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    _timer.cancel();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage();
                        },
                      ),
                    );
                  },
                ),
                Container(
                  height: 50,
                ),
                Container(
                  child: Text(
                    """By  Rushour0""",
                    style: TextStyle(fontFamily: "Dandelion", fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content of the tabs
        body: TabBarView(
          children: <Widget>[
            // First tab

            Scaffold(
              backgroundColor: Colors.blue.shade50,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade500,
                centerTitle: true,
                title: Text(
                  "LIVE DATA",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      height: screenHeight * 2 / 3,
                      width: screenWidth,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // The SFCartesian chart
                            child: SfCartesianChart(
                              // Set X axis to DateTime
                              primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat('hh:mm:ss')),
                              title: ChartTitle(
                                  text: "Heart Rate",
                                  textStyle: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 28)),
                              // Providing the data source and mapping the data
                              series: <LineSeries<HeartRateData, DateTime>>[
                                LineSeries<HeartRateData, DateTime>(
                                    animationDuration: 0,
                                    dataSource: hrValues,
                                    xValueMapper: (HeartRateData value, _) =>
                                        value.datetime,
                                    yValueMapper: (HeartRateData value, _) =>
                                        value.HeartRate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      height: screenHeight * 2 / 3,
                      width: screenWidth,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // The SFCartesian chart
                            child: SfCartesianChart(
                              // Set X axis to DateTime
                              primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat('hh:mm:ss')),
                              title: ChartTitle(
                                  text: "Temperature",
                                  textStyle: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 28)),
                              // Providing the data source and mapping the data
                              series: <LineSeries<TemperatureData, DateTime>>[
                                LineSeries<TemperatureData, DateTime>(
                                    animationDuration: 0,
                                    dataSource: temperatureValues,
                                    xValueMapper: (TemperatureData value, _) =>
                                        value.datetime,
                                    yValueMapper: (TemperatureData value, _) =>
                                        value.Temperature),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      height: screenHeight * 2 / 3,
                      width: screenWidth,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // The SFCartesian chart
                            child: SfCartesianChart(
                              // Set X axis to DateTime
                              primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat('hh:mm:ss')),
                              title: ChartTitle(
                                  text: "SpO2",
                                  textStyle: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 28)),
                              // Providing the data source and mapping the data
                              series: <LineSeries<SpO2Data, DateTime>>[
                                LineSeries<SpO2Data, DateTime>(
                                    animationDuration: 0,
                                    dataSource: spo2Values,
                                    xValueMapper: (SpO2Data value, _) =>
                                        value.datetime,
                                    yValueMapper: (SpO2Data value, _) =>
                                        value.SpO2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Second tab
            Scaffold(
              backgroundColor: Colors.blue.shade100,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade500,
                centerTitle: true,
                title: Text(
                  "HEALTH CHECK",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Row 1
                    Row(
                      children: <Widget>[
                        // First Radial chart
                        Container(
                          width: screenWidth / 3,
                          height: screenHeight / 3,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                height: screenHeight / 3,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Heart Rate",
                                    style: TextStyle(
                                        fontFamily: "Montserrat", fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  """$displayHR
BPM""",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SfCircularChart(
                                series: <CircularSeries<HeartCheck, num>>[
                                  RadialBarSeries(
                                    maximumValue: 200,
                                    dataSource: hrParameter,
                                    radius: '100%',
                                    innerRadius: '80%',
                                    xValueMapper: (HeartCheck data, _) =>
                                        data.average,
                                    yValueMapper: (HeartCheck data, _) =>
                                        data.average,
                                    pointColorMapper: (HeartCheck data, _) =>
                                        data.color,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Second Radial Chart
                        Container(
                          width: screenWidth / 3,
                          height: screenHeight / 3,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                height: screenHeight / 3,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Temperature",
                                    style: TextStyle(
                                        fontFamily: "Montserrat", fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "$displayTemperature F",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SfCircularChart(
                                series: <CircularSeries<TemperatureCheck, num>>[
                                  RadialBarSeries(
                                    maximumValue: 120,
                                    dataSource: temperatureParameter,
                                    radius: '100%',
                                    innerRadius: '80%',
                                    xValueMapper: (TemperatureCheck data, _) =>
                                        data.average,
                                    yValueMapper: (TemperatureCheck data, _) =>
                                        data.average,
                                    pointColorMapper:
                                        (TemperatureCheck data, _) =>
                                            data.color,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth / 3,
                          height: screenHeight / 3,
                          child: Stack(children: [
                            Container(
                              alignment: Alignment.topCenter,
                              height: screenHeight / 3,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "SpO2",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "$displaySpO2 %",
                                style: TextStyle(
                                    fontFamily: "Montserrat", fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SfCircularChart(
                              series: <CircularSeries<SpO2Check, num>>[
                                RadialBarSeries(
                                  maximumValue: 100,
                                  dataSource: spo2Parameter,
                                  radius: '100%',
                                  innerRadius: '80%',
                                  xValueMapper: (SpO2Check data, _) =>
                                      data.average,
                                  yValueMapper: (SpO2Check data, _) =>
                                      data.average,
                                  pointColorMapper: (SpO2Check data, _) =>
                                      data.color,
                                  cornerStyle: CornerStyle.bothCurve,
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        // First Radial chart
                        Container(
                          width: screenWidth,
                          height: screenHeight * 2 / 5,
                          child: Stack(
                            children: [
                              Container(
                                width: screenWidth,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Health Index",
                                    style: TextStyle(
                                        fontFamily: "Montserrat", fontSize: 28),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "$displayIndex",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 32),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SfCircularChart(
                                series: <CircularSeries<HealthIndexCheck, num>>[
                                  RadialBarSeries(
                                    maximumValue: 100,
                                    dataSource: indexParameter,
                                    radius: '70%',
                                    innerRadius: '80%',
                                    xValueMapper: (HealthIndexCheck data, _) =>
                                        data.average,
                                    yValueMapper: (HealthIndexCheck data, _) =>
                                        data.average,
                                    pointColorMapper:
                                        (HealthIndexCheck data, _) =>
                                            data.color,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
