import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/LiveStreamC/pages/home_page.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/model/Model.dart';
import 'package:cric_flutter/ScorecardWritting/scorecard_writing.dart';
import 'package:cric_flutter/ScorecardWritting/setting_opening_player.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class MatchHomePage extends StatefulWidget {
  const MatchHomePage({Key? key}) : super(key: key);

  @override
  State<MatchHomePage> createState() => _MatchHomePageState();
}

class _MatchHomePageState extends State<MatchHomePage> {
  late Match match;
  late String matchId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMatch();
  }

  void getMatch() async {
    match = Match.fromJson(await Glutton.vomit("Match"));
    matchId = await Glutton.vomit("MatchId");
    setState(() {});
    getTeam();
  }

  void getTeam() async {
    FirebaseFirestore.instance
        .collection('Team')
        .doc(match.team1Uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        // Team team = Team.fromJson(documentSnapshot.data());
        // print(team.players[1].battingStyle);
        await Glutton.eat("Team1", documentSnapshot.data());
      }
    });

    FirebaseFirestore.instance
        .collection('Team')
        .doc(match.team2Uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        // Team team = Team.fromJson(documentSnapshot.data());
        // print(team.players[1].battingStyle);
        await Glutton.eat("Team2", documentSnapshot.data());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Match Home Page"),
          backgroundColor: Color(0xff233743),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomOptionButton(
                innerText: 'Score Writting',
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (_) => SettingOpeningPlayer());
                  Navigator.push(context, route);
                },
              ),
              SizedBox(
                height: 30,
              ),
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
