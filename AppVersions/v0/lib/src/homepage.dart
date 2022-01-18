import 'package:CareBelts/globals.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:CareBelts/utils/requests.dart';
import 'package:CareBelts/src/classes.dart';

// Home page of the app
class HomePage extends StatefulWidget {
  final String db;
  final int temperature, age;

  HomePage({Key? key, this.db = "miband3", this.temperature = 37, this.age = 5})
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

  // Variables to be used later
  late List<HeartRateData> values, all_values;
  late List<HealthCheck> parameter;
  late String displayHeartRate;
  late int i;
  late String status_image;

  @override
  void initState() {
    // Load the data every 1 second
    Timer.periodic(const Duration(seconds: 1), loadChartData);
    i = 0;

    // Get initial data
    values = getChartData();
    parameter = [HealthCheck(values)];
    displayHeartRate = "";
    status_image = "optimal.png";

    // Start the main application
    super.initState();
  }

  // Load data function to update the source of the SFCartesian graph
  void loadChartData(Timer timer) async {
    // Get the database values
    all_values = await updateBandData(this.db);

    // Update values to the data source of the SFCartesian
    values = all_values;

    // Update values to the data source of the SfCircular
    HealthCheck newData = HealthCheck(values);
    parameter.removeAt(0);
    parameter.add(newData);

    // Set state
    setState(
      () {
        values = all_values;

        parameter.removeAt(0);
        parameter.add(newData);

        displayHeartRate = parameter[0].average.toString();

        if (parameter[0].average < 75 || parameter[0].average > 120)
          status_image = "not_optimal.png";
        else
          status_image = "optimal.png";
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
      initialIndex: 1,
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
            labelColor: Colors.blueGrey,
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

        // Drawer configuration
        drawer: Drawer(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue.shade300),
                child: Center(
                    child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    PROFILE_PICTURE,
                    fit: BoxFit.contain,
                  ),
                ))),
            Container(
              height: 5,
            ),
            Card(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: Text(
                    "USERNAME",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  title: Text(
                    "$db",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ])),
            Container(
              height: 5,
            ),
            Card(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: Text(
                    "AGE",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  title: Text(
                    "$age",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ])),
            Container(
              height: 5,
            ),
            Card(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: Text(
                    "TEMPERATURE",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  title: Text(
                    "$temperature",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ])),
            Container(
              height: 5,
            ),
            Card(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: Text(
                    "HEARTRATE",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  title: Text(
                    "$displayHeartRate",
                    style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ])),
            Container(
              height: 50,
            ),
            Container(
              child: Text(
                """Made with Love
Rushour0""",
                style: TextStyle(fontFamily: "Dandelion", fontSize: 36),
                textAlign: TextAlign.center,
              ),
            )
          ])),
        ),
        // Content of the tabs
        body: TabBarView(
          children: <Widget>[
            // First tab

            Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                    )
                  ],
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: screenWidth,
                child: Column(children: <Widget>[
                  Expanded(
                      // The SFCartesian chart
                      child: SfCartesianChart(
                          // Set X axis to DateTime
                          primaryXAxis:
                              DateTimeAxis(dateFormat: DateFormat('hh:mm:ss')),
                          title: ChartTitle(
                              text: "Live Data",
                              textStyle: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 28)),
                          // Providing the data source and mapping the data
                          series: <LineSeries<HeartRateData, DateTime>>[
                        LineSeries<HeartRateData, DateTime>(
                            onRendererCreated:
                                (ChartSeriesController controller) {
                              // _chartSeriesController = controller;
                            },
                            animationDuration: 0,
                            dataSource: values,
                            xValueMapper: (HeartRateData value, _) =>
                                value.datetime,
                            yValueMapper: (HeartRateData value, _) =>
                                value.HeartRate),
                      ])),
                ])),

            // Second tab
            Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                    )
                  ],
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                height: screenHeight * 2 / 3,
                width: screenWidth,
                child: Stack(children: <Widget>[
                  Center(
                      child: Text(displayHeartRate,
                          style: TextStyle(
                              fontFamily: "Montserrat", fontSize: 32))),
                  Center(child: Text("""


BPM""", style: TextStyle(fontFamily: "Montserrat", fontSize: 32))),
                  Column(children: <Widget>[
                    Expanded(
                        child: SfCircularChart(
                            title: ChartTitle(
                                text: "Health Check",
                                textStyle: TextStyle(
                                    fontFamily: "Montserrat", fontSize: 28)),
                            series: <CircularSeries<HealthCheck, int>>[
                          RadialBarSeries(
                            onRendererCreated:
                                (CircularSeriesController controller) {
                              // _circularChartSeriesController = controller;
                            },
                            maximumValue: 200,
                            dataSource: parameter,
                            radius: '70%',
                            innerRadius: '80%',
                            xValueMapper: (HealthCheck data, _) => data.average,
                            yValueMapper: (HealthCheck data, _) => data.average,
                            pointColorMapper: (HealthCheck data, _) =>
                                data.color,
                            cornerStyle: CornerStyle.bothCurve,
                          )
                        ])),
                  ]),
                ])),
          ],
        ),
      ),
    );
  }
}
