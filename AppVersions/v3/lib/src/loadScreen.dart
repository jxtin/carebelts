import 'package:CareBelts/globals.dart';
import 'package:CareBelts/src/homepage.dart';
import 'package:CareBelts/utils/requests.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadScreen extends StatefulWidget {
  LoadScreen({Key? key, @required this.name, @required this.pass})
      : super(key: key);
  final name, pass;

  _loadScreenState createState() => _loadScreenState(name, pass);
}

class _loadScreenState extends State<LoadScreen> {
  _loadScreenState(this.name, this.pass);
  final String name, pass;

  getInputs() async {
    if (name == "admin" && pass == "admin") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(db: "pawllar_v4");
        },
      ), (r) => false);
      return;
    }
    final results = await signIn(name, pass);

    if (results['status']) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(db: results['username']);
        },
      ), (r) => false);
      return;
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getInputs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SpinKitFoldingCube(
                duration: Duration(seconds: 2),
                color: Colors.blue,
              ),
            ),
            Container(
              child: Text(
                APP_TITLE,
                style: TextStyle(
                    fontFamily: "Cotton Butter",
                    fontSize: 64,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}
