import 'package:cric_flutter/LiveStreamC/pages/home_page.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/team/team_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConnectWithMatch extends StatefulWidget {
  const ConnectWithMatch({Key? key}) : super(key: key);

  @override
  State<ConnectWithMatch> createState() => _ConnectWithMatchState();
}

class _ConnectWithMatchState extends State<ConnectWithMatch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Connect With A Match"),
          backgroundColor: Color(0xff233743),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomOptionButton(
                innerText: "Video Recording",
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (_) => LiveStreamHomePage("video"));
                  Navigator.push(context, route);
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomOptionButton(
                innerText: "Audio Commentry",
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (_) => LiveStreamHomePage("audio"));
                  Navigator.push(context, route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
