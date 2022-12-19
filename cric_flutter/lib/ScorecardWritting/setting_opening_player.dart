import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/model/Model.dart';
import 'package:cric_flutter/ScorecardWritting/scorecard_writing.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class SettingOpeningPlayer extends StatefulWidget {
  final String innings;
  const SettingOpeningPlayer({Key? key, required this.innings})
      : super(key: key);

  @override
  State<SettingOpeningPlayer> createState() => _SettingOpeningPlayerState();
}

class _SettingOpeningPlayerState extends State<SettingOpeningPlayer> {
  var firebaseUser;
  List<String> selectedPlayer = ["", "", ""];

  List<String> teamNameList1 = [];
  List<String> teamNameList2 = [];
  // final Map<String, String> teamList = new Map<String, String>();

  late Team team1;
  late Team team2;
  late Match match;
  late String matchId;

  int flag = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeamPlayerList();
  }

  void getTeamPlayerList() async {
    match = Match.fromJson(await Glutton.vomit("Match"));
    team1 = Team.fromJson(await Glutton.vomit("Team1"));
    team2 = Team.fromJson(await Glutton.vomit("Team2"));
    matchId = await Glutton.vomit("MatchId");

    if (widget.innings == "First Innings") {
      if (match.firstInnings.onBatting == match.team1Uid) {
        for (int i = 0; i < 16; i++) {
          teamNameList1.add((i + 1).toString() + ". " + team1.players[i].name);
          teamNameList2.add((i + 1).toString() + ". " + team2.players[i].name);
        }
      } else {
        for (int i = 0; i < 16; i++) {
          teamNameList1.add((i + 1).toString() + ". " + team2.players[i].name);
          teamNameList2.add((i + 1).toString() + ". " + team1.players[i].name);
        }
      }

      selectedPlayer[0] = teamNameList1[0];
      selectedPlayer[1] = teamNameList1[1];
      selectedPlayer[2] = teamNameList2[10];
    } else {
      if (match.firstInnings.onBatting == match.team1Uid) {
        for (int i = 0; i < 16; i++) {
          teamNameList1.add((i + 1).toString() + ". " + team2.players[i].name);
          teamNameList2.add((i + 1).toString() + ". " + team1.players[i].name);
        }
      } else {
        for (int i = 0; i < 16; i++) {
          teamNameList1.add((i + 1).toString() + ". " + team1.players[i].name);
          teamNameList2.add((i + 1).toString() + ". " + team2.players[i].name);
        }
      }

      selectedPlayer[0] = teamNameList1[0];
      selectedPlayer[1] = teamNameList1[1];
      selectedPlayer[2] = teamNameList2[10];
    }

    print(selectedPlayer[0]);
    print(selectedPlayer[1]);
    print(selectedPlayer[2]);

    setState(() {
      flag = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Select Opening Players"),
              backgroundColor: Color(0xff233743),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.innings,
                    style: TextStyle(fontSize: 20),
                  ),
                  flag == 1
                      ? Text(match.tossWin +
                          " won the toss and opted to " +
                          match.optedTo +
                          " first ")
                      // match.firstInnings.onBatting == match.team1Uid &&
                      //         match.tossWin == match.team1Name
                      //     ? Text(team1.teamName +
                      //         " won the toss and opted to bat first.")
                      //     : match.firstInnings.onBatting == match.team2Uid &&
                      //             match.tossWin == match.team2Name
                      //         ? Text(team2.teamName +
                      //             " won the toss and opted to bat first.")
                      //         : match.firstInnings.onBatting ==
                      //                     match.team2Uid &&
                      //                 match.tossWin == match.team1Name
                      //             ? Text(team1.teamName +
                      //                 " won the toss and opted to field first.")
                      //             : Text(team2.teamName +
                      //                 " won the toss and opted to field first.")
                      : Container(),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Striker",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  dropDownField(context, "Striker", teamNameList1, 0),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Non-Striker",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  dropDownField(context, "Non-Striker", teamNameList1, 1),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Opening Bowler",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  dropDownField(context, "Bowler", teamNameList2, 2),
                  SizedBox(height: 40),
                  CustomOptionButton(
                    innerText: 'Next',
                    onPressed: () {
                      saveToFireBase();
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ))));
  }

  Widget dropDownField(
      BuildContext context, String label, List<String> dropDownList, int i) {
    return Column(
      children: [
        Container(
          //width: double.infinity,
          child: Text(
            label,
            //style: banglaTextStyleClass.customTextStyle(textColor),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                elevation: 5,
                //iconEnabledColor: appBarColor,
                isExpanded: true,
                //dropdownColor: dropDownBackgroundColor,
                value: selectedPlayer[i],
                onChanged: (String? value) {
                  setState(() {
                    selectedPlayer[i] = value!;
                  });
                },
                focusColor: Colors.blue,
                autofocus: true,
                items:
                    dropDownList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )),
        ),
      ],
    );
  }

  void saveToFireBase() async {
    if (widget.innings == "First Innings") {
      Dismissal dismissal = Dismissal("", "", "", "");
      Batting batting = Batting(0, 0, false, 1, dismissal);
      Bowling bowling = Bowling(0, 0, 0, 0);
      PlayerInnings player1 =
          PlayerInnings(selectedPlayer[0], batting, bowling);
      PlayerInnings player2 =
          PlayerInnings(selectedPlayer[1], batting, bowling);
      PlayerInnings player3 =
          PlayerInnings(selectedPlayer[2], batting, bowling);

      match.firstInnings.batsmanOnStrike = selectedPlayer[0];
      match.firstInnings.batsmanOnNonStrike = selectedPlayer[1];
      match.firstInnings.bowler = selectedPlayer[2];
      List<dynamic> team1Players = [];
      List<dynamic> team2Players = [];

      if (match.firstInnings.onBatting == match.team1Uid) {
        team1Players.add(player1.toJson());
        team1Players.add(player2.toJson());
        team2Players.add(player3.toJson());
      } else {
        team2Players.add(player1.toJson());
        team2Players.add(player2.toJson());
        team1Players.add(player3.toJson());
      }

      List<dynamic> firstInningsOverTracking = [];
      List<dynamic> secondInningsOverTracking = [];

      match.team1Players = team1Players;
      match.team2Players = team2Players;

      match.firstInningsOverTracking = firstInningsOverTracking;
      match.secondInningsOverTracking = secondInningsOverTracking;
    } else {
      if (match.firstInnings.onBatting == match.team1Uid) {
        List<dynamic> team2players = [];
        bool flag1 = false, flag2 = false;
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name +
              ":bbbbbbbbbbbb:" +
              selectedPlayer[0] +
              ":ccccccccccc:" +
              selectedPlayer[1] +
              ":ddddddddd:" +
              selectedPlayer[2]);
          if (playerInnings.name == selectedPlayer[0]) {
            match.secondInnings.batsmanOnStrike = selectedPlayer[0];
            flag1 = true;
          } else if (playerInnings.name == selectedPlayer[1]) {
            match.secondInnings.batsmanOnNonStrike = selectedPlayer[1];
            flag2 = true;
          }

          team2players.add(playerInnings.toJson());
        });

        Dismissal dismissal = Dismissal("", "", "", "");
        Batting batting = Batting(0, 0, false, 1, dismissal);
        Bowling bowling = Bowling(0, 0, 0, 0);

        if (!flag1) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[0], batting, bowling);
          match.secondInnings.batsmanOnStrike = selectedPlayer[0];
          team2players.add(player1.toJson());
        }

        if (!flag2) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[1], batting, bowling);
          match.secondInnings.batsmanOnStrike = selectedPlayer[1];
          team2players.add(player1.toJson());
        }

        match.team2Players = team2players;

        List<dynamic> team1players = [];
        bool flag3 = false;
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == selectedPlayer[2]) {
            match.secondInnings.bowler = selectedPlayer[2];
            flag3 = true;
          }

          team1players.add(playerInnings.toJson());
        });

        if (!flag3) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[2], batting, bowling);
          match.secondInnings.bowler = selectedPlayer[2];
          team1players.add(player1.toJson());
        }

        match.team1Players = team1players;
      } else {
        List<dynamic> team1players = [];
        bool flag1 = false, flag2 = false;
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name +
              ":bbbbbbbbbbbb:" +
              selectedPlayer[0] +
              ":ccccccccccc:" +
              selectedPlayer[1] +
              ":ddddddddd:" +
              selectedPlayer[2]);
          if (playerInnings.name == selectedPlayer[0]) {
            match.secondInnings.batsmanOnStrike = selectedPlayer[0];
            print("***" + match.secondInnings.batsmanOnStrike);
            flag1 = true;
          } else if (playerInnings.name == selectedPlayer[1]) {
            match.secondInnings.batsmanOnNonStrike = selectedPlayer[1];
            print("***2" + match.secondInnings.batsmanOnStrike);
            flag2 = true;
          }

          team1players.add(playerInnings.toJson());
        });

        Dismissal dismissal = Dismissal("", "", "", "");
        Batting batting = Batting(0, 0, false, 1, dismissal);
        Bowling bowling = Bowling(0, 0, 0, 0);

        if (!flag1) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[0], batting, bowling);
          match.secondInnings.batsmanOnStrike = selectedPlayer[0];
          team1players.add(player1.toJson());
        }

        if (!flag2) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[1], batting, bowling);
          match.secondInnings.batsmanOnNonStrike = selectedPlayer[1];
          team1players.add(player1.toJson());
        }

        match.team1Players = team1players;

        List<dynamic> team2players = [];
        bool flag3 = false;
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == selectedPlayer[2]) {
            match.secondInnings.bowler = selectedPlayer[2];
            flag3 = true;
          }

          team2players.add(playerInnings.toJson());
        });

        if (!flag3) {
          PlayerInnings player1 =
              PlayerInnings(selectedPlayer[2], batting, bowling);
          match.secondInnings.bowler = selectedPlayer[2];
          team2players.add(player1.toJson());
        }

        match.team2Players = team2players;
      }
    }

    print("***34" + match.secondInnings.batsmanOnStrike);

    await FirebaseFirestore.instance
        .collection("Match")
        .doc(matchId)
        .set(match.toJson())
        .then((value) async {
      await Glutton.eat("Match", match.toJson());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScorePage()));
    });
  }
}
