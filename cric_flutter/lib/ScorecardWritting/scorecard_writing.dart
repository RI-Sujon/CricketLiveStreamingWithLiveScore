import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/model/Model.dart';
import 'package:cric_flutter/ScorecardWritting/setting_opening_player.dart';
// import 'package:cric_flutter/ScorecardWritting/json_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:glutton/glutton.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // ScoreCard card = ScoreCard([], []);
  String textBar = "";
  List jsonDataInList = [];

  int totalRun = 0;
  int wicket = 0;
  int overs = 0, ballInAOver = 0;
  int extraRun = 0;

  bool isChangeBatsmanScreenOpen = false;
  bool isChangeBowlerScreenOpen = false;

  String battingTeamName = " ", bowlingTeamName = " ", innings = "1st Innings";

  String batsmanOneName = "Player1",
      batsmanTwoName = "Player2",
      isOnStrikeBatsmanOne = "@",
      isOnStrikeBatsmanTwo = "";

  int batsmanOneRun = 0,
      batsmanTwoRun = 0,
      batsmanOneBallConceded = 0,
      batsmanTwoBallConceded = 0;

  bool batsmanOneOnStrike = true,
      batsmanTwoOnStrike = false,
      batsmanOneIsOut = false,
      batsmanTwoIsOut = false;
  int batsmanOneBattingPosition = 1, batsmanTwoBattingPosition = 2;

  String bowlerName = " ";
  int bowlerOvers = 0,
      bowlerBallInAOver = 0,
      bowlerWicket = 0,
      bowlerRunConceded = 0;
  String ball1 = "",
      ball2 = "",
      ball3 = "",
      ball4 = "",
      ball5 = "",
      ball6 = "",
      ball7 = "",
      ball8 = "",
      ball9 = "",
      ball10 = "";
  var ball = ['', '', '', '', '', '', '', '', '', ''];
  int n = 0;

  String lastLastKeyPressed = "", lastKeyPressed = "";
  var arraylastKeyType = ['', '', '', '', '', '', '', '', '', ''];
  int nKey = 0;
  int plusFlag = 0,
      loopFlag = 0,
      undoFlag = -1,
      lastKeyRun = 0,
      lastLastKeyRun = 0;
  String isLastKeyPlus = "";

  String x = "", y = "", z = "", xy = "", xylast = "", xyz = "";
  var validDoublePressed = [
    '1B',
    '2B',
    '3B',
    '4B',
    '1L',
    '2L',
    '3L',
    '4L',
    '1D',
    '2D',
    '3D',
    '4D',
    '1N',
    '2N',
    '3N',
    '4N',
    '5N',
    '6N',
    '1W',
    '2W',
    '3W',
    'NW',
    'DW'
  ];
  var validTriplePressed = [
    "1BW",
    "2BW",
    "3BW",
    "1LW",
    "2LW",
    "3LW",
    "1DW",
    "2DW",
    "3DW",
    "1NW",
    "2NW",
    "3NW",
    "1BN",
    "2BN",
    "3BN",
    "4BN",
    "1LN",
    "2LN",
    "3LN",
    "4LN"
  ];

  List<String> dismissalList = [
    "Bowled",
    "Caught",
    "Leg Before Wicket",
    "Stumped",
    "Run Out",
    "Hit Wicket",
    "Handle The Ball",
    "Obstructing The Field",
    "Hit The Ball Twice",
    "Timed Out"
  ];

  List<String> selectedPlayer = ["", "", ""];
  String selectedDismissalType = "";
  List<String> teamNameList1 = [];
  List<String> teamNameList2 = [];

  late Match match;
  late Team team1;
  late Team team2;
  late String matchId;

  int flag = 0;

  @override
  void initState() {
    getMatchInfo();
  }

  void getMatchInfo() async {
    match = Match.fromJson(await Glutton.vomit("Match"));
    team1 = Team.fromJson(await Glutton.vomit("Team1"));
    team2 = Team.fromJson(await Glutton.vomit("Team2"));
    matchId = await Glutton.vomit("MatchId");

    bool b1Out = false, b2Out = false;

    if (match.secondInnings.target == 0) {
      if (match.firstInnings.onBatting == match.team1Uid) {
        battingTeamName = match.team1Name;
        bowlingTeamName = match.team2Name;
      } else {
        battingTeamName = match.team2Name;
        bowlingTeamName = match.team1Name;
      }

      totalRun = match.firstInnings.totalRun;
      wicket = match.firstInnings.wicket;
      overs = match.firstInnings.overs;
      ballInAOver = match.firstInnings.ballInAOver;
      extraRun = match.firstInnings.extras;

      batsmanOneName = match.firstInnings.batsmanOnStrike;
      batsmanTwoName = match.firstInnings.batsmanOnNonStrike;
      bowlerName = match.firstInnings.bowler;

      if (match.firstInnings.onBatting == match.team1Uid) {
        for (int i = 0; i < match.team1Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team1Players[i]);
          if (playerInnings.name == batsmanOneName) {
            batsmanOneRun = playerInnings.batting.run;
            batsmanOneBallConceded = playerInnings.batting.ball;
            if (playerInnings.batting.isOut == true) {
              b1Out = true;
            }
          } else if (playerInnings.name == batsmanTwoName) {
            batsmanTwoRun = playerInnings.batting.run;
            batsmanTwoBallConceded = playerInnings.batting.ball;
            if (playerInnings.batting.isOut == true) {
              b2Out = true;
            }
          }
        }

        for (int i = 0; i < match.team2Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team2Players[i]);
          if (playerInnings.name == bowlerName) {
            bowlerOvers = playerInnings.bowling.over;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerWicket = playerInnings.bowling.wicket;
            bowlerRunConceded = playerInnings.bowling.runConceded;
          }
        }
      } else {
        for (int i = 0; i < match.team2Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team2Players[i]);
          if (playerInnings.name == batsmanOneName) {
            batsmanOneRun = playerInnings.batting.run;
            batsmanOneBallConceded = playerInnings.batting.ball;
          } else if (playerInnings.name == batsmanTwoName) {
            batsmanTwoRun = playerInnings.batting.run;
            batsmanTwoBallConceded = playerInnings.batting.ball;
          }
        }

        for (int i = 0; i < match.team1Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team1Players[i]);
          if (playerInnings.name == bowlerName) {
            bowlerOvers = playerInnings.bowling.over;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerWicket = playerInnings.bowling.wicket;
            bowlerRunConceded = playerInnings.bowling.runConceded;
          }
        }
      }
    } else {
      innings = "2nd Innings";

      if (match.firstInnings.onBatting == match.team1Uid) {
        battingTeamName = match.team2Name;
        bowlingTeamName = match.team1Name;
      } else {
        battingTeamName = match.team1Name;
        bowlingTeamName = match.team2Name;
      }

      totalRun = match.secondInnings.totalRun;
      wicket = match.secondInnings.wicket;
      overs = match.secondInnings.overs;
      ballInAOver = match.secondInnings.ballInAOver;
      extraRun = match.secondInnings.extras;

      batsmanOneName = match.secondInnings.batsmanOnStrike;
      batsmanTwoName = match.secondInnings.batsmanOnNonStrike;
      bowlerName = match.secondInnings.bowler;

      if (match.secondInnings.onBatting == match.team1Uid) {
        for (int i = 0; i < match.team1Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team1Players[i]);
          if (playerInnings.name == batsmanOneName) {
            batsmanOneRun = playerInnings.batting.run;
            batsmanOneBallConceded = playerInnings.batting.ball;
            if (playerInnings.batting.isOut == true) {
              b1Out = true;
            }
          } else if (playerInnings.name == batsmanTwoName) {
            batsmanTwoRun = playerInnings.batting.run;
            batsmanTwoBallConceded = playerInnings.batting.ball;
            if (playerInnings.batting.isOut == true) {
              b2Out = true;
            }
          }
        }

        for (int i = 0; i < match.team2Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team2Players[i]);
          if (playerInnings.name == bowlerName) {
            bowlerOvers = playerInnings.bowling.over;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerWicket = playerInnings.bowling.wicket;
            bowlerRunConceded = playerInnings.bowling.runConceded;
          }
        }
      } else {
        for (int i = 0; i < match.team2Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team2Players[i]);
          if (playerInnings.name == batsmanOneName) {
            batsmanOneRun = playerInnings.batting.run;
            batsmanOneBallConceded = playerInnings.batting.ball;
          } else if (playerInnings.name == batsmanTwoName) {
            batsmanTwoRun = playerInnings.batting.run;
            batsmanTwoBallConceded = playerInnings.batting.ball;
          }
        }

        for (int i = 0; i < match.team1Players.length; i++) {
          PlayerInnings playerInnings =
              PlayerInnings.fromJson(match.team1Players[i]);
          if (playerInnings.name == bowlerName) {
            bowlerOvers = playerInnings.bowling.over;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerWicket = playerInnings.bowling.wicket;
            bowlerRunConceded = playerInnings.bowling.runConceded;
          }
        }
      }
    }
    //  else {
    //   batsmanOneName = match.secondInnings.batsmanOnStrike;
    //   batsmanTwoName = match.secondInnings.batsmanOnNonStrike;
    //   bowlerName = match.secondInnings.bowler;
    // }

    if (match.secondInnings.target == 0) {
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
    }

    selectedPlayer[0] = teamNameList1[0];
    selectedPlayer[1] = teamNameList2[10];
    selectedPlayer[2] = teamNameList2[0];
    selectedDismissalType = dismissalList[0];

    setState(() {
      flag = 1;
      if (ballInAOver == 0 && overs != 0) {
        print(ballInAOver.toString() + ":888888:" + overs.toString());
        isChangeBowlerScreenOpen = true;
      }
      if (b1Out) {
        isChangeBatsmanScreenOpen = true;
      } else if (b2Out) {
        changeBatsmanStrike();
        isChangeBatsmanScreenOpen = true;
      }
    });
  }

  updateFirestore() async {
    if (match.secondInnings.target == 0) {
      match.firstInnings.totalRun = totalRun;
      match.firstInnings.wicket = wicket;
      match.firstInnings.overs = overs;
      match.firstInnings.ballInAOver = ballInAOver;
      if (batsmanOneOnStrike) {
        match.firstInnings.batsmanOnStrike = batsmanOneName;
        match.firstInnings.batsmanOnNonStrike = batsmanTwoName;
      } else {
        match.firstInnings.batsmanOnStrike = batsmanTwoName;
        match.firstInnings.batsmanOnNonStrike = batsmanOneName;
      }
      match.firstInnings.bowler = bowlerName;
      match.firstInnings.extras = extraRun;

      List<dynamic> team1players = [];
      match.team1Players.forEach((element) {
        PlayerInnings playerInnings = PlayerInnings.fromJson(element);
        if (match.firstInnings.onBatting == match.team1Uid) {
          if (playerInnings.name == batsmanOneName) {
            playerInnings.batting.ball = batsmanOneBallConceded;
            playerInnings.batting.run = batsmanOneRun;
          } else if (element['name'] == batsmanTwoName) {
            playerInnings.batting.ball = batsmanTwoBallConceded;
            playerInnings.batting.run = batsmanTwoRun;
          }
        } else {
          if (playerInnings.name == bowlerName) {
            playerInnings.bowling.runConceded = bowlerRunConceded;
            playerInnings.bowling.over = bowlerOvers;
            playerInnings.bowling.ballInAOver = bowlerBallInAOver;
            playerInnings.bowling.wicket = bowlerWicket;
          }
        }

        team1players.add(playerInnings.toJson());
      });

      match.team1Players = team1players;

      List<dynamic> team2players = [];
      match.team2Players.forEach((element) {
        PlayerInnings playerInnings = PlayerInnings.fromJson(element);
        if (match.firstInnings.onBatting == match.team1Uid) {
          if (playerInnings.name == bowlerName) {
            playerInnings.bowling.runConceded = bowlerRunConceded;
            playerInnings.bowling.over = bowlerOvers;
            playerInnings.bowling.ballInAOver = bowlerBallInAOver;
            playerInnings.bowling.wicket = bowlerWicket;
          }
        } else {
          if (playerInnings.name == batsmanOneName) {
            playerInnings.batting.ball = batsmanOneBallConceded;
            playerInnings.batting.run = batsmanOneRun;
          } else if (element['name'] == batsmanTwoName) {
            playerInnings.batting.ball = batsmanTwoBallConceded;
            playerInnings.batting.run = batsmanTwoRun;
          }
        }

        team2players.add(playerInnings.toJson());
      });

      match.team2Players = team2players;

      await FirebaseFirestore.instance
          .collection("Match")
          .doc(matchId)
          .set(match.toJson())
          .then((value) async {
        print("Score Updated");
      });
    } else {
      match.secondInnings.totalRun = totalRun;
      match.secondInnings.wicket = wicket;
      match.secondInnings.overs = overs;
      match.secondInnings.ballInAOver = ballInAOver;
      if (batsmanOneOnStrike) {
        match.secondInnings.batsmanOnStrike = batsmanOneName;
        match.secondInnings.batsmanOnNonStrike = batsmanTwoName;
      } else {
        match.secondInnings.batsmanOnStrike = batsmanTwoName;
        match.secondInnings.batsmanOnNonStrike = batsmanOneName;
      }
      match.secondInnings.bowler = bowlerName;
      match.secondInnings.extras = extraRun;

      List<dynamic> team2players = [];
      match.team2Players.forEach((element) {
        PlayerInnings playerInnings = PlayerInnings.fromJson(element);
        if (match.firstInnings.onBatting == match.team1Uid) {
          if (playerInnings.name == batsmanOneName) {
            playerInnings.batting.ball = batsmanOneBallConceded;
            playerInnings.batting.run = batsmanOneRun;
          } else if (element['name'] == batsmanTwoName) {
            playerInnings.batting.ball = batsmanTwoBallConceded;
            playerInnings.batting.run = batsmanTwoRun;
          }
        } else {
          if (playerInnings.name == bowlerName) {
            playerInnings.bowling.runConceded = bowlerRunConceded;
            playerInnings.bowling.over = bowlerOvers;
            playerInnings.bowling.ballInAOver = bowlerBallInAOver;
            playerInnings.bowling.wicket = bowlerWicket;
          }
        }

        team2players.add(playerInnings.toJson());
      });

      match.team2Players = team2players;

      List<dynamic> team1players = [];
      match.team1Players.forEach((element) {
        PlayerInnings playerInnings = PlayerInnings.fromJson(element);
        if (match.firstInnings.onBatting == match.team1Uid) {
          if (playerInnings.name == bowlerName) {
            playerInnings.bowling.runConceded = bowlerRunConceded;
            playerInnings.bowling.over = bowlerOvers;
            playerInnings.bowling.ballInAOver = bowlerBallInAOver;
            playerInnings.bowling.wicket = bowlerWicket;
          }
        } else {
          if (playerInnings.name == batsmanOneName) {
            playerInnings.batting.ball = batsmanOneBallConceded;
            playerInnings.batting.run = batsmanOneRun;
          } else if (element['name'] == batsmanTwoName) {
            playerInnings.batting.ball = batsmanTwoBallConceded;
            playerInnings.batting.run = batsmanTwoRun;
          }
        }

        team1players.add(playerInnings.toJson());
      });

      match.team1Players = team1players;

      await FirebaseFirestore.instance
          .collection("Match")
          .doc(matchId)
          .set(match.toJson())
          .then((value) async {
        print("Score Updated");
      });
    }
  }

  textBarController(String keyType, int run) {
    if (n == 10) n--;
    if (keyType == "undo") {
      if (undoFlag != 0) return;
      if (plusFlag <= 1)
        undo();
      else if (plusFlag <= 3) undo2();
      plusFlag = 0;
      undoFlag = -1;
      return;
    }

    print("\n\nUP" + plusFlag.toString() + "  " + keyType);

    if (isLastKeyPlus != "plus" && keyType != "plus") {
      plusFlag = 0;
    }

    if (keyType == "plus") {
      textBar = textBar + " + ";
      if (plusFlag == 0) {
        plusFlag = 1;
      } else if (plusFlag == 2) {
        plusFlag = 3;
      }
    } else if (plusFlag == 3) {
      textBar = textBar + "" + keyType;
      plusOperation2Start(keyType, run);
      //plusOperation2(keyType,run) ;
    } else if (plusFlag == 1) {
      textBar = textBar + "" + keyType;
      plusOperationStart(keyType, run);
      lastLastKeyPressed = lastKeyPressed;
      lastKeyPressed = keyType;
      lastLastKeyRun = lastKeyRun;
      lastKeyRun = run;
      plusFlag = 2;
    } else {
      textBar = textBar + " | " + keyType + "(" + plusFlag.toString() + ")";
      scoreUpdateOnKeyPressed(keyType, run);
      lastKeyPressed = keyType;
      lastKeyRun = run;
      undoFlag = 0;
    }

    isLastKeyPlus = keyType;

    print("End" + plusFlag.toString() + "  " + keyType);
  }

  plusOperationStart(String newKeyPressed, int newKeyRun) {
    undo();
    int run = 0;
    x = "";
    y = "";
    z = "";
    xy = "";
    if (newKeyPressed == "one" ||
        newKeyPressed == "two" ||
        newKeyPressed == "three" ||
        newKeyPressed == "four" ||
        newKeyPressed == "five" ||
        newKeyPressed == "six") {
      x = newKeyRun.toString();
      run = newKeyRun;
    } else if (newKeyPressed == "wide")
      x = "D";
    else if (newKeyPressed == "noBall")
      x = "N";
    else if (newKeyPressed == "bye")
      x = "B";
    else if (newKeyPressed == "legBye")
      x = "L";
    else if (newKeyPressed == "wicket")
      x = "W";
    else {
      print(
          "Somthing Wrong in plusoperationstart newKeyPressed" + newKeyPressed);
      return;
    }
    if (lastKeyPressed == "one" ||
        lastKeyPressed == "two" ||
        lastKeyPressed == "three" ||
        lastKeyPressed == "four" ||
        lastKeyPressed == "five" ||
        lastKeyPressed == "six") {
      y = lastKeyRun.toString();
      run = lastKeyRun;
    } else if (lastKeyPressed == "wide")
      y = "D";
    else if (lastKeyPressed == "noBall")
      y = "N";
    else if (lastKeyPressed == "bye")
      y = "B";
    else if (lastKeyPressed == "legBye")
      y = "L";
    else if (lastKeyPressed == "wicket")
      y = "W";
    else {
      print("Somthing Wrong in plusoperationstart lastKeyPressed: " +
          lastKeyPressed);
      return;
    }

    if (x.codeUnitAt(0) > y.codeUnitAt(0)) {
      xy = y + x;
    } else
      xy = x + y;

    print("\nHELLO: " + xy);

    for (int i = 0; i < validDoublePressed.length; i++) {
      if (xy == validDoublePressed[i]) {
        print("Huhu milche:" + validDoublePressed[i]);
        plusOperation(i, run);
        xylast = xy;
        return;
      }
    }
    xylast = xy;
  }

  plusOperation2Start(String newKeyPressed, int newKeyRun) {
    //print("New key:" + newKeyPressed + "    lastKey:" + lastKeyPressed + "    lastLastKey:" + lastLastKeyPressed );
    undo2();

    int run = 0;
    x = "";
    y = "";
    z = "";
    xyz = "";
    if (newKeyPressed == "one" ||
        newKeyPressed == "two" ||
        newKeyPressed == "three" ||
        newKeyPressed == "four" ||
        newKeyPressed == "five" ||
        newKeyPressed == "six") {
      x = newKeyRun.toString();
      run = newKeyRun;
    } else if (newKeyPressed == "wide")
      x = "D";
    else if (newKeyPressed == "noBall")
      x = "N";
    else if (newKeyPressed == "bye")
      x = "B";
    else if (newKeyPressed == "legBye")
      x = "L";
    else if (newKeyPressed == "wicket")
      x = "W";
    else {
      print("Somthing Wrong in plusoperationstart2 newKeyPressed" +
          newKeyPressed);
      return;
    }
    if (lastKeyPressed == "one" ||
        lastKeyPressed == "two" ||
        lastKeyPressed == "three" ||
        lastKeyPressed == "four" ||
        lastKeyPressed == "five" ||
        lastKeyPressed == "six") {
      y = lastKeyRun.toString();
      run = lastKeyRun;
    } else if (lastKeyPressed == "wide")
      y = "D";
    else if (lastKeyPressed == "noBall")
      y = "N";
    else if (lastKeyPressed == "bye")
      y = "B";
    else if (lastKeyPressed == "legBye")
      y = "L";
    else if (lastKeyPressed == "wicket")
      y = "W";
    else {
      print("Somthing Wrong in plusoperationstart2 lastKeyPressed" +
          lastKeyPressed);
      return;
    }

    if (lastLastKeyPressed == "one" ||
        lastLastKeyPressed == "two" ||
        lastLastKeyPressed == "three" ||
        lastLastKeyPressed == "four" ||
        lastLastKeyPressed == "five" ||
        lastLastKeyPressed == "six") {
      z = lastLastKeyRun.toString();
      run = lastLastKeyRun;
    } else if (lastLastKeyPressed == "wide")
      z = "D";
    else if (lastLastKeyPressed == "noBall")
      z = "N";
    else if (lastLastKeyPressed == "bye")
      z = "B";
    else if (lastLastKeyPressed == "legBye")
      z = "L";
    else if (lastLastKeyPressed == "wicket")
      z = "W";
    else {
      print("Somthing Wrong in plusoperationstart2 lastLastKeyPressed: " +
          lastLastKeyPressed);
      return;
    }

    if (x.codeUnitAt(0) > y.codeUnitAt(0) &&
        y.codeUnitAt(0) > z.codeUnitAt(0)) {
      xyz = z + y + x;
    } else if (x.codeUnitAt(0) > z.codeUnitAt(0) &&
        z.codeUnitAt(0) > y.codeUnitAt(0)) {
      xyz = y + z + x;
    } else if (y.codeUnitAt(0) > x.codeUnitAt(0) &&
        x.codeUnitAt(0) > z.codeUnitAt(0)) {
      xyz = z + x + y;
    } else if (y.codeUnitAt(0) > z.codeUnitAt(0) &&
        z.codeUnitAt(0) > x.codeUnitAt(0)) {
      xyz = x + z + y;
    } else if (z.codeUnitAt(0) > x.codeUnitAt(0) &&
        x.codeUnitAt(0) > y.codeUnitAt(0)) {
      xyz = y + x + z;
    } else if (z.codeUnitAt(0) > y.codeUnitAt(0) &&
        y.codeUnitAt(0) > x.codeUnitAt(0)) {
      xyz = x + y + z;
    } else
      print("matha");

    print("\nHELLO: " + xyz);

    for (int i = 0; i < validTriplePressed.length; i++) {
      if (xyz == validTriplePressed[i]) {
        print("Huhu milche:" + validTriplePressed[i]);
        plusOperation2(i, run);
        //xylast = xy ;
      }
    }
  }

  undo() {
    print("\nobject\n");
    //if(plusFlag<=1){
    if (lastKeyPressed == "Dot") {
      n--;
      ball[n] = "";
      checkInverseOvers();
      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
    } else if (lastKeyPressed == "one" ||
        lastKeyPressed == "two" ||
        lastKeyPressed == "three" ||
        lastKeyPressed == "four" ||
        lastKeyPressed == "five" ||
        lastKeyPressed == "six") {
      n--;
      ball[n] = "";
      totalRun = totalRun - lastKeyRun;
      bowlerInverseRunConcededUpdate(lastKeyRun);
      batsmanInverseScoreUpdate(lastKeyRun);
      checkInverseOvers();

      if (lastKeyRun == 1 || lastKeyRun == 3 || lastKeyRun == 5) {
        changeBatsmanStrike();
      }
    } else if (lastKeyPressed == "wide") {
      n--;
      ball[n] = "";
      totalRun = totalRun - 1;
      bowlerInverseRunConcededUpdate(1);
      updateInverseExtraRun(1);
    } else if (lastKeyPressed == "noBall") {
      n--;
      ball[n] = "";
      totalRun = totalRun - 1;
      bowlerInverseRunConcededUpdate(1);
      updateInverseExtraRun(1);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
    } else if (lastKeyPressed == "bye") {
    } else if (lastKeyPressed == "legBye") {
    } else if (lastKeyPressed == "wicket") {
      n--;
      ball[n] = "";
      updateInverseWicket();
      checkInverseOvers();
      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
    }
    //}
  }

  undo2() {
    int casePoint, run = 0, index = -1;
    print("ssssss");
    switch (xylast[0]) {
      case '1':
        run = 1;
        break;
      case '2':
        run = 2;
        break;
      case '3':
        run = 3;
        break;
      case '4':
        run = 4;
        break;
      case '5':
        run = 5;
        break;
      case '6':
        run = 6;
        break;
    }

    for (int i = 0; i < validDoublePressed.length; i++) {
      if (xy == validDoublePressed[i]) {
        print("Huhu milche Abar:" + validDoublePressed[i]);
        index = i;
        break;
      }
    }

    print("\nsomthi:\n" + index.toString());
    casePoint = index;

    print("mile na kennnnnnnnnnnnnnnnnnnnn");

    if (casePoint >= 0 && casePoint <= 3) {
      n--;
      ball[n] = "";
      totalRun = totalRun - run;
      bowlerInverseRunConcededUpdate(0);
      checkInverseOvers();
      updateInverseExtraRun(run);

      if (run == 1 || run == 3) {
        changeBatsmanStrike();
      }
      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
    } else if (casePoint >= 4 && casePoint <= 7) {
      n--;
      ball[n] = "";
      totalRun = totalRun - run;
      bowlerInverseRunConcededUpdate(0);
      checkInverseOvers();
      updateInverseExtraRun(run);

      if (run == 1 || run == 3) {
        changeBatsmanStrike();
      }
      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
    } else if (casePoint >= 8 && casePoint <= 11) {
      n--;
      ball[n] = "";
      totalRun = totalRun - run - 1;
      bowlerInverseRunConcededUpdate(run + 1);
      updateInverseExtraRun(run - 1);

      if (run == 1 || run == 3) changeBatsmanStrike();
    } else if (casePoint >= 12 && casePoint <= 17) {
      n--;
      ball[n] = "";
      totalRun = totalRun - run - 1;
      bowlerInverseRunConcededUpdate(run + 1);
      batsmanInverseScoreUpdate(run);
      updateInverseExtraRun(1);

      if (run == 1 || run == 3 || run == 5) {
        changeBatsmanStrike();
      }
    } else if (casePoint >= 18 && casePoint <= 20) {
      n--;
      ball[n] = "";
      totalRun = totalRun - run;
      bowlerInverseRunConcededUpdate(run);
      batsmanInverseScoreUpdate(run);
      checkInverseOvers();
      updateInverseWicket();

      if (run == 1 || run == 3) {
        changeBatsmanStrike();
      }
    } else if (casePoint == 21) {
      //n-- ;
      print("amar matha");
      n--;
      ball[n] = "";
      totalRun = totalRun - 1;
      bowlerInverseRunConcededUpdate(1);
      updateInverseWicket();
      updateInverseExtraRun(1);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded--;
      else
        batsmanTwoBallConceded--;
      print("amar matha2");
    } else if (casePoint >= 22) {
      n--;
      ball[n] = "";
      totalRun = totalRun - 1;
      bowlerInverseRunConcededUpdate(1);
      updateInverseWicket();
      updateInverseExtraRun(1);
    }
  }

  scoreUpdateOnKeyPressed(String keyType, int run) {
    if (keyType == "Dot") {
      ball[n] = run.toString();
      n++;

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      checkOvers();
    } else if (keyType == "one" ||
        keyType == "two" ||
        keyType == "three" ||
        keyType == "four" ||
        keyType == "five" ||
        keyType == "six") {
      ball[n] = run.toString();
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(run);
      batsmanScoreUpdate(run);
      checkOvers();
    } else if (keyType == "wide") {
      ball[n] = "wd";
      n++;
      totalRun = totalRun + 1;
      bowlerRunConcededUpdate(1);
      updateExtraRun(1);
    } else if (keyType == "noBall") {
      ball[n] = "N";
      n++;
      totalRun = totalRun + 1;
      bowlerRunConcededUpdate(1);
      updateExtraRun(1);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
    } else if (keyType == "bye") {
    } else if (keyType == "legBye") {
    } else if (keyType == "wicket") {
      ball[n] = "W";
      n++;
      batsmanScoreUpdate(0);
      updateWicket();
      checkOvers();
    }
  }

  checkOvers() {
    ballInAOver++;
    bowlerBallInAOver++;
    if (ballInAOver == 6) {
      overs++;
      ballInAOver = 0;
      bowlerBallInAOver = 0;
      bowlerOvers++;
      // changeBatsmanStrike();
      setState(() {
        isChangeBowlerScreenOpen = true;
        if (overs == match.overs) {
          isChangeBowlerScreenOpen = false;
          match.secondInnings.target = totalRun + 1;
          addOverTrackingOperation();
          updateFirestore();
          Route route = MaterialPageRoute(
              builder: (_) => SettingOpeningPlayer(
                    innings: "Second Innings",
                  ));
          Navigator.push(context, route);
        }
      });
    }
  }

  checkInverseOvers() {
    if (overs == 0 && ballInAOver == 0) return;
    if (overs != 0 && ballInAOver == 0) {
      overs--;
      ballInAOver = 6;
    }
    ballInAOver--;
    bowlerBallInAOver--;
  }

  updateWicket() {
    wicket++;
    bowlerWicket++;
  }

  updateInverseWicket() {
    wicket--;
    bowlerWicket--;
  }

  updateExtraRun(int run) {
    extraRun = extraRun + run;
  }

  updateInverseExtraRun(int run) {
    extraRun = extraRun - run;
  }

  batsmanScoreUpdate(int run) {
    if (batsmanOneOnStrike) {
      batsmanOneRun = batsmanOneRun + run;
      if (run >= 0) batsmanOneBallConceded++;
      if (run == 1 || run == 3 || run == 5) {
        changeBatsmanStrike();
      }
    } else if (batsmanTwoOnStrike) {
      batsmanTwoRun = batsmanTwoRun + run;
      if (run >= 0) batsmanTwoBallConceded++;
      if (run == 1 || run == 3 || run == 5) {
        changeBatsmanStrike();
      }
    }
  }

  batsmanInverseScoreUpdate(int run) {
    if (overs != 0 && ballInAOver == 0) {
      if (run == 1 || run == 3 || run == 5) {
        if (batsmanTwoOnStrike) {
          batsmanTwoBallConceded--;
          batsmanTwoRun = batsmanTwoRun - run;
        } else {
          batsmanOneBallConceded--;
          batsmanOneRun = batsmanOneRun - run;
        }
      } else {
        if (batsmanOneOnStrike) {
          batsmanTwoBallConceded--;
          batsmanTwoRun = batsmanTwoRun - run;
        } else {
          batsmanOneBallConceded--;
          batsmanOneRun = batsmanOneRun - run;
        }
      }
    } else {
      if (run == 1 || run == 3 || run == 5) {
        if (batsmanOneOnStrike) {
          batsmanTwoBallConceded--;
          batsmanTwoRun = batsmanTwoRun - run;
        } else {
          batsmanOneBallConceded--;
          batsmanOneRun = batsmanOneRun - run;
        }
      } else {
        if (batsmanTwoOnStrike) {
          batsmanTwoBallConceded--;
          batsmanTwoRun = batsmanTwoRun - run;
        } else {
          batsmanOneBallConceded--;
          batsmanOneRun = batsmanOneRun - run;
        }
      }
    }
  }

  changeBatsmanStrike() {
    if (batsmanOneOnStrike) {
      batsmanOneOnStrike = false;
      batsmanTwoOnStrike = true;
      isOnStrikeBatsmanOne = "";
      isOnStrikeBatsmanTwo = "@";
    } else if (batsmanTwoOnStrike) {
      batsmanOneOnStrike = true;
      batsmanTwoOnStrike = false;
      isOnStrikeBatsmanOne = "@";
      isOnStrikeBatsmanTwo = "";
    }
  }

  bowlerRunConcededUpdate(int run) {
    bowlerRunConceded = bowlerRunConceded + run;
  }

  bowlerInverseRunConcededUpdate(int run) {
    bowlerRunConceded = bowlerRunConceded - run;
  }

  plusOperation(int casePoint, int run) {
    if (casePoint >= 0 && casePoint <= 3) {
      ball[n] = run.toString() + "B";
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(0);
      updateExtraRun(run);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
      checkOvers();
    } else if (casePoint >= 4 && casePoint <= 7) {
      ball[n] = run.toString() + "LB";
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(0);
      updateExtraRun(run);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
      checkOvers();
    } else if (casePoint >= 8 && casePoint <= 11) {
      ball[n] = run.toString() + "wd";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(run + 1);
      updateExtraRun(run + 1);

      if (run == 1 || run == 3) changeBatsmanStrike();
    } else if (casePoint >= 12 && casePoint <= 17) {
      ball[n] = run.toString() + "N";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(run + 1);
      batsmanScoreUpdate(run);
      updateExtraRun(1);
    } else if (casePoint >= 18 && casePoint <= 20) {
      ball[n] = "W+" + run.toString();
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(run);
      batsmanScoreUpdate(run);
      updateWicket();
      checkOvers();
    } else if (casePoint == 21) {
      ball[n] = "W+N";
      n++;
      totalRun = totalRun + 1;
      bowlerRunConcededUpdate(1);
      batsmanScoreUpdate(0);
      updateWicket();
      updateExtraRun(1);
    } else if (casePoint >= 22) {
      ball[n] = "W+wd";
      n++;
      totalRun = totalRun + 1;
      bowlerRunConcededUpdate(1);
      updateWicket();
      updateExtraRun(1);
    }
  }

  plusOperation2(int casePoint, int run) {
    if (casePoint >= 0 && casePoint <= 2) {
      ball[n] = "W+" + run.toString() + "B";
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(0);
      updateWicket();
      updateExtraRun(run);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
      checkOvers();
    } else if (casePoint >= 3 && casePoint <= 5) {
      ball[n] = "W+" + run.toString() + "LB";
      n++;
      totalRun = totalRun + run;
      bowlerRunConcededUpdate(0);
      updateWicket();
      updateExtraRun(run);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
      checkOvers();
    } else if (casePoint >= 6 && casePoint <= 8) {
      ball[n] = "W+" + run.toString() + "wd";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(run + 1);
      updateWicket();
      updateExtraRun(run + 1);

      if (run == 1 || run == 3) changeBatsmanStrike();
    } else if (casePoint >= 9 && casePoint <= 11) {
      ball[n] = "W+" + run.toString() + "N";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(run + 1);
      batsmanScoreUpdate(run);
      updateWicket();
      updateExtraRun(1);
    } else if (casePoint >= 12 && casePoint <= 15) {
      ball[n] = "N+" + run.toString() + "B";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(1);
      updateExtraRun(run + 1);

      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
    } else if (casePoint >= 16 && casePoint <= 19) {
      ball[n] = "N+" + run.toString() + "LB";
      n++;
      totalRun = totalRun + run + 1;
      bowlerRunConcededUpdate(1);
      updateExtraRun(run + 1);
      if (batsmanOneOnStrike)
        batsmanOneBallConceded++;
      else
        batsmanTwoBallConceded++;
      if (run == 1 || run == 3) changeBatsmanStrike();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return SafeArea(
        child: Scaffold(
            body: flag != 1
                ? Text("Loading")
                : isChangeBatsmanScreenOpen
                    ? changeBatsman(context)
                    : isChangeBowlerScreenOpen
                        ? changeBowler(context)
                        : writeScore(context)));
  }

  Widget writeScore(BuildContext context) {
    Color scoreBackgroundColor = Color.fromARGB(255, 22, 40, 52);
    Color scoreTextColor = Colors.white;
    Color totalRunByWicketBgColor = Color.fromARGB(255, 43, 77, 98);
    Color totalRunByWicketTextColor = Colors.white;

    return Scaffold(
        body: Container(
      color: Colors.black,
      // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(children: <Widget>[
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: scoreBackgroundColor,
                          padding: EdgeInsets.all(0),
                          child: Text(
                              style: TextStyle(
                                  color: scoreTextColor, fontSize: 11),
                              battingTeamName),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(1, 1, 0, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                color: scoreBackgroundColor,
                                child: Text(
                                    style: TextStyle(color: scoreTextColor),
                                    batsmanOneName[1] == '.'
                                        ? batsmanOneName.substring(
                                            2, batsmanOneName.length)
                                        : batsmanOneName.substring(
                                            3, batsmanOneName.length)),
                              ),
                              flex: 5,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      isOnStrikeBatsmanOne)),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      batsmanOneRun.toString())),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      batsmanOneBallConceded.toString())),
                              flex: 2,
                            ),
                          ],
                        ),
                        flex: 4,
                      ),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(1, 1, 0, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                color: scoreBackgroundColor,
                                child: Text(
                                    style: TextStyle(color: scoreTextColor),
                                    batsmanTwoName[1] == "."
                                        ? batsmanTwoName.substring(
                                            2, batsmanTwoName.length)
                                        : batsmanTwoName.substring(
                                            3, batsmanTwoName.length)),
                              ),
                              flex: 5,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      isOnStrikeBatsmanTwo)),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      batsmanTwoRun.toString())),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      batsmanTwoBallConceded.toString())),
                              flex: 2,
                            ),
                          ],
                        ),
                        flex: 4,
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          color: scoreBackgroundColor,
                          child: Text(
                              style: TextStyle(
                                  color: scoreTextColor, fontSize: 13),
                              " Extra Info"),
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  flex: 4,
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.all(1),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: scoreBackgroundColor,
                            child: Text(
                                style: TextStyle(
                                    color: scoreTextColor, fontSize: 12),
                                innings)),
                        flex: 2,
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: totalRunByWicketBgColor,
                          child: Text(
                              style: TextStyle(
                                  color: totalRunByWicketTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              totalRun.toString() + " - " + wicket.toString()),
                        ),
                        flex: 6,
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: scoreBackgroundColor,
                          child: Text(
                              style: TextStyle(
                                  color: scoreTextColor, fontSize: 12),
                              "OVERS: " +
                                  overs.toString() +
                                  "." +
                                  ballInAOver.toString()),
                        ),
                        flex: 3,
                      ),
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.all(1),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: scoreBackgroundColor,
                            child: Text(
                                style: TextStyle(
                                    color: scoreTextColor, fontSize: 13),
                                "EXTRA:" + extraRun.toString())),
                        flex: 3,
                      ),
                    ],
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: scoreBackgroundColor,
                          child: Text(
                              style: TextStyle(
                                  color: scoreTextColor, fontSize: 11),
                              bowlingTeamName),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(1, 1, 0, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                color: scoreBackgroundColor,
                                child: Text(
                                    style: TextStyle(color: scoreTextColor),
                                    bowlerName[1] == "."
                                        ? bowlerName.substring(
                                            2, bowlerName.length)
                                        : bowlerName.substring(
                                            3, bowlerName.length)),
                              ),
                              flex: 5,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      bowlerWicket.toString() +
                                          "-" +
                                          bowlerRunConceded.toString())),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: scoreBackgroundColor,
                                  child: Text(
                                      style: TextStyle(color: scoreTextColor),
                                      bowlerOvers.toString() +
                                          "." +
                                          bowlerBallInAOver.toString())),
                              flex: 2,
                            ),
                          ],
                        ),
                        flex: 4,
                      ),
                      Flexible(
                        child: Row(children: <Widget>[
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 0, right: 0, left: 1, bottom: 0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[0]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[1]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[2]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[3]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[4]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[5]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[6]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[7]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[8]),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 0, left: 0, bottom: 0, right: 1),
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: scoreBackgroundColor,
                              child: Text(
                                  style: TextStyle(color: scoreTextColor),
                                  ball[9]),
                            ),
                            flex: 1,
                          )
                        ]),
                        flex: 4,
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          color: scoreBackgroundColor,
                          child: Text(
                              style: TextStyle(
                                  color: scoreTextColor, fontSize: 13),
                              " LAST 10 BALLS"),
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  flex: 4,
                ),
              ],
            ),
          ),
          flex: 4,
        ),
        // Flexible(
        //   child: Container(
        //     height: double.infinity,
        //     width: double.infinity,
        //     child: Container(
        //         height: double.infinity,
        //         width: 5,
        //         alignment: Alignment.center,
        //         color: Colors.lightBlueAccent,
        //         child: Text(textBar)),
        //   ),
        //   flex: 1,
        // ),
        Flexible(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ButtonTheme(
                          height: double.infinity,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            child: Text("BYE"),
                            onPressed: () {
                              setState(() {
                                textBarController("bye", 0);
                                updateFirestore();
                              });
                            },
                          )),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ButtonTheme(
                          height: double.infinity,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            child: Text("LEG BYE"),
                            onPressed: () {
                              setState(() {
                                textBarController("legBye", 0);
                                updateFirestore();
                              });
                            },
                          )),
                    ),
                    flex: 1,
                  )
                ]),
                flex: 4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("WIDE"),
                        onPressed: () {
                          setState(() {
                            textBarController("wide", -1);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("W"),
                        onPressed: () {
                          setState(() {
                            textBarController("wicket", 0);
                            isChangeBatsmanScreenOpen = true;
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("1"),
                        onPressed: () {
                          setState(() {
                            textBarController("one", 1);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 5,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("2"),
                        onPressed: () {
                          setState(() {
                            textBarController("two", 2);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 3,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("4"),
                        onPressed: () {
                          setState(() {
                            textBarController("four", 4);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 5,
              ),
            ],
          ),
          flex: 4,
        ),
        Flexible(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "UNDO",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromARGB(255, 22, 40, 52),
                              onPressed: () {
                                setState(() {
                                  textBarController("undo", 0);
                                  updateFirestore();
                                });
                              },
                            )),
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              color: Color.fromARGB(255, 22, 40, 52),
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "MENU",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  textBarController("undo", 0);
                                  updateFirestore();
                                });
                              },
                            )),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                flex: 4,
              ),
              // Flexible(
              //   child: Container(
              //     margin: EdgeInsets.all(5),
              //     height: double.infinity,
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     child: ButtonTheme(
              //         height: double.infinity,
              //         minWidth: double.infinity,
              //         child: RaisedButton(
              //           child: Text("UNDO"),
              //           onPressed: () {
              //             setState(() {
              //               textBarController("undo", 0);
              //               updateFirestore();
              //             });
              //           },
              //         )),
              //   ),
              //   flex: 3,
              // ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("NO\nBALL"),
                        onPressed: () {
                          setState(() {
                            textBarController("noBall", -1);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            textBarController("plus", 0);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("DOT"),
                        onPressed: () {
                          setState(() {
                            textBarController("Dot", 0);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 5,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              child: Text("3"),
                              onPressed: () {
                                setState(() {
                                  textBarController("three", 3);
                                  updateFirestore();
                                });
                              },
                            )),
                      ),
                      flex: 3,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              child: Text("5"),
                              onPressed: () {
                                setState(() {
                                  textBarController("five", 5);
                                  updateFirestore();
                                });
                              },
                            )),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                flex: 3,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ButtonTheme(
                      height: double.infinity,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        child: Text("6"),
                        onPressed: () {
                          setState(() {
                            textBarController("six", 6);
                            updateFirestore();
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Change\nBatsman",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromARGB(255, 22, 40, 52),
                              onPressed: () {
                                setState(() {
                                  isChangeBatsmanScreenOpen = true;
                                });
                              },
                            )),
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ButtonTheme(
                            height: double.infinity,
                            minWidth: double.infinity,
                            child: RaisedButton(
                              color: Color.fromARGB(255, 22, 40, 52),
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Change\nBowler",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  isChangeBowlerScreenOpen = true;
                                });
                              },
                            )),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                flex: 4,
              ),
            ],
          ),
          flex: 4,
        ),
      ]),
    ));
  }

  Widget changeBatsman(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text("Dismissal Type",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          dropDownField(context, "Dismissal Type", dismissalList, 3),
          SizedBox(
            height: 40,
          ),
          selectedDismissalType == "Run Out" ||
                  selectedDismissalType == "Caught" ||
                  selectedDismissalType == "Stumped"
              ? Text(
                  selectedDismissalType == "Run Out"
                      ? "Run Out By"
                      : selectedDismissalType == "Caught"
                          ? "Caught By"
                          : "Stumped By",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              : Container(),
          selectedDismissalType == "Run Out" ||
                  selectedDismissalType == "Caught" ||
                  selectedDismissalType == "Stumped"
              ? dropDownField(context, "Player", teamNameList2, 2)
              : Container(),
          SizedBox(
            height: 40,
          ),
          Text("Next Batsman",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          dropDownField(context, "Batsman", teamNameList1, 0),
          SizedBox(height: 40),
          CustomOptionButton(
            innerText: 'Confirm',
            onPressed: () {
              changeBatsmanOperation();
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  void changeBatsmanOperation() {
    var batsmanName = "";

    if (batsmanOneOnStrike) {
      batsmanName = batsmanOneName;
    } else {
      batsmanName = batsmanTwoName;
    }
    Dismissal dismissal = Dismissal(
        selectedDismissalType, batsmanName, bowlerName, selectedPlayer[2]);

    if (match.secondInnings.target == 0) {
      if (match.firstInnings.onBatting == match.team1Uid) {
        List<dynamic> team1players = [];
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == batsmanOneName && batsmanOneOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          } else if (playerInnings.name == batsmanTwoName &&
              batsmanTwoOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          }

          team1players.add(playerInnings.toJson());
        });

        match.team1Players = team1players;
      } else {
        List<dynamic> team2players = [];
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == batsmanOneName && batsmanOneOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          } else if (playerInnings.name == batsmanTwoName &&
              batsmanTwoOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          }

          team2players.add(playerInnings.toJson());
        });

        match.team2Players = team2players;
      }
    } else {
      if (match.firstInnings.onBatting == match.team1Uid) {
        List<dynamic> team2players = [];
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == batsmanOneName && batsmanOneOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          } else if (playerInnings.name == batsmanTwoName &&
              batsmanTwoOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          }

          team2players.add(playerInnings.toJson());
        });

        match.team2Players = team2players;
      } else {
        List<dynamic> team1players = [];
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          if (playerInnings.name == batsmanOneName && batsmanOneOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          } else if (playerInnings.name == batsmanTwoName &&
              batsmanTwoOnStrike) {
            playerInnings.batting.isOut = true;
            playerInnings.batting.dismissal = dismissal;
          }

          team1players.add(playerInnings.toJson());
        });

        match.team2Players = team1players;
      }
    }

    Dismissal dismissal2 = Dismissal("", "", "", "");
    Batting batting = Batting(0, 0, false, 1, dismissal2);
    Bowling bowling = Bowling(0, 0, 0, 0);
    PlayerInnings playerInnings =
        PlayerInnings(selectedPlayer[0], batting, bowling);

    if (match.secondInnings.target == 0) {
      if (match.firstInnings.onBatting == match.team1Uid) {
        match.team1Players.add(playerInnings.toJson());
      } else {
        match.team2Players.add(playerInnings.toJson());
      }
    } else {
      if (match.firstInnings.onBatting == match.team1Uid) {
        match.team2Players.add(playerInnings.toJson());
      } else {
        match.team1Players.add(playerInnings.toJson());
      }
    }

    if (batsmanOneOnStrike) {
      batsmanOneName = selectedPlayer[0];
      batsmanOneBallConceded = playerInnings.batting.ball;
      batsmanOneRun = playerInnings.batting.run;
    } else {
      batsmanTwoName = selectedPlayer[0];
      batsmanTwoBallConceded = playerInnings.batting.ball;
      batsmanTwoRun = playerInnings.batting.run;
    }

    updateFirestore();
    setState(() {
      isChangeBatsmanScreenOpen = false;
    });
  }

  Widget changeBowler(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Text("New Bowler",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        dropDownField(context, "Bowler", teamNameList2, 1),
        SizedBox(
          height: 40,
        ),
        CustomOptionButton(
          innerText: 'Next',
          onPressed: () {
            // saveToFireBase();
            changeBowlerOperation();
          },
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  changeBowlerOperation() {
    changeBatsmanStrike();
    if (match.secondInnings.target == 0) {
      if (match.firstInnings.onBatting == match.team1Uid) {
        List<dynamic> team2players = [];
        int flag = 0;
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name + ":===========111=====" + element['name']);
          if (playerInnings.name == selectedPlayer[1]) {
            flag = 1;
            bowlerName = playerInnings.name;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerOvers = playerInnings.bowling.over;
            bowlerRunConceded = playerInnings.bowling.runConceded;
            bowlerWicket = playerInnings.bowling.wicket;
          }

          team2players.add(playerInnings.toJson());
        });

        if (flag == 0) {
          Dismissal dismissal2 = Dismissal("", "", "", "");
          Batting batting = Batting(0, 0, false, 1, dismissal2);
          Bowling bowling = Bowling(0, 0, 0, 0);
          PlayerInnings playerInnings =
              PlayerInnings(selectedPlayer[1], batting, bowling);

          bowlerName = playerInnings.name;
          bowlerBallInAOver = playerInnings.bowling.ballInAOver;
          bowlerOvers = playerInnings.bowling.over;
          bowlerRunConceded = playerInnings.bowling.runConceded;
          bowlerWicket = playerInnings.bowling.wicket;

          team2players.add(playerInnings.toJson());
        }

        match.team2Players = team2players;
      } else {
        List<dynamic> team1players = [];
        int flag = 0;
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name + ":===========4444=====" + element['name']);
          if (playerInnings.name == selectedPlayer[1]) {
            flag = 1;
            bowlerName = playerInnings.name;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerOvers = playerInnings.bowling.over;
            bowlerRunConceded = playerInnings.bowling.runConceded;
            bowlerWicket = playerInnings.bowling.wicket;
          }

          team1players.add(playerInnings.toJson());
        });

        if (flag == 0) {
          Dismissal dismissal2 = Dismissal("", "", "", "");
          Batting batting = Batting(0, 0, false, 1, dismissal2);
          Bowling bowling = Bowling(0, 0, 0, 0);
          PlayerInnings playerInnings =
              PlayerInnings(selectedPlayer[1], batting, bowling);

          bowlerName = playerInnings.name;
          bowlerBallInAOver = playerInnings.bowling.ballInAOver;
          bowlerOvers = playerInnings.bowling.over;
          bowlerRunConceded = playerInnings.bowling.runConceded;
          bowlerWicket = playerInnings.bowling.wicket;

          team1players.add(playerInnings.toJson());
        }

        match.team1Players = team1players;
      }
    } else {
      if (match.firstInnings.onBatting == match.team1Uid) {
        List<dynamic> team1players = [];
        int flag = 0;
        match.team1Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name + ":===========111=====" + element['name']);
          if (playerInnings.name == selectedPlayer[1]) {
            flag = 1;
            bowlerName = playerInnings.name;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerOvers = playerInnings.bowling.over;
            bowlerRunConceded = playerInnings.bowling.runConceded;
            bowlerWicket = playerInnings.bowling.wicket;
          }

          team1players.add(playerInnings.toJson());
        });

        if (flag == 0) {
          Dismissal dismissal2 = Dismissal("", "", "", "");
          Batting batting = Batting(0, 0, false, 1, dismissal2);
          Bowling bowling = Bowling(0, 0, 0, 0);
          PlayerInnings playerInnings =
              PlayerInnings(selectedPlayer[1], batting, bowling);

          bowlerName = playerInnings.name;
          bowlerBallInAOver = playerInnings.bowling.ballInAOver;
          bowlerOvers = playerInnings.bowling.over;
          bowlerRunConceded = playerInnings.bowling.runConceded;
          bowlerWicket = playerInnings.bowling.wicket;

          team1players.add(playerInnings.toJson());
        }

        match.team1Players = team1players;
      } else {
        List<dynamic> team2players = [];
        int flag = 0;
        match.team2Players.forEach((element) {
          PlayerInnings playerInnings = PlayerInnings.fromJson(element);
          print(playerInnings.name + ":===========4444=====" + element['name']);
          if (playerInnings.name == selectedPlayer[1]) {
            flag = 1;
            bowlerName = playerInnings.name;
            bowlerBallInAOver = playerInnings.bowling.ballInAOver;
            bowlerOvers = playerInnings.bowling.over;
            bowlerRunConceded = playerInnings.bowling.runConceded;
            bowlerWicket = playerInnings.bowling.wicket;
          }

          team2players.add(playerInnings.toJson());
        });

        if (flag == 0) {
          Dismissal dismissal2 = Dismissal("", "", "", "");
          Batting batting = Batting(0, 0, false, 1, dismissal2);
          Bowling bowling = Bowling(0, 0, 0, 0);
          PlayerInnings playerInnings =
              PlayerInnings(selectedPlayer[1], batting, bowling);

          bowlerName = playerInnings.name;
          bowlerBallInAOver = playerInnings.bowling.ballInAOver;
          bowlerOvers = playerInnings.bowling.over;
          bowlerRunConceded = playerInnings.bowling.runConceded;
          bowlerWicket = playerInnings.bowling.wicket;

          team2players.add(playerInnings.toJson());
        }

        match.team2Players = team2players;
      }
    }

    addOverTrackingOperation();
    updateFirestore();
    setState(() {
      isChangeBowlerScreenOpen = false;
    });
  }

  addOverTrackingOperation() {
    if (match.secondInnings.target == 0) {
      OverTracking overTracking = OverTracking(
          match.firstInnings.bowler,
          match.firstInnings.overs,
          match.firstInnings.totalRun,
          match.firstInnings.wicket);

      match.firstInningsOverTracking.add(overTracking.toJson());
    } else {
      OverTracking overTracking = OverTracking(
          match.secondInnings.bowler,
          match.secondInnings.overs,
          match.secondInnings.totalRun,
          match.secondInnings.wicket);

      match.secondInningsOverTracking.add(overTracking.toJson());
    }
  }

  Widget dropDownField(
      BuildContext context, String label, List<String> dropDownList, int i) {
    return Padding(
        padding: EdgeInsets.only(left: 32.0, right: 32.0),
        child: Column(
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
                    value: i == 3 ? selectedDismissalType : selectedPlayer[i],
                    onChanged: (String? value) {
                      setState(() {
                        if (i == 3) {
                          selectedDismissalType = value!;
                        } else {
                          selectedPlayer[i] = value!;
                        }
                      });
                    },
                    focusColor: Colors.blue,
                    autofocus: true,
                    items: dropDownList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ),
          ],
        ));
  }
}
