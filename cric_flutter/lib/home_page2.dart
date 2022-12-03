import 'package:cric_flutter/LiveStream/videotest.dart';
import 'package:cric_flutter/LiveStreamC/pages/home_page.dart';
import 'package:cric_flutter/ScorecardWritting/scorecard_writing.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Score Writting"),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (_) => ScorePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Video Recording"),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (_) => MyHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Audio Commentry"),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (_) => MyHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
