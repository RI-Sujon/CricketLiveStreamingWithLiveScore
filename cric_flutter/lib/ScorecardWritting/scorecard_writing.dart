import 'package:cric_flutter/ScorecardWritting/json_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  ScoreCard card = ScoreCard([], []);
  String textBar = "";
  List jsonDataInList = [];

  int totalRun = 0;
  int wicket = 0;
  int overs = 0, ballInAOver = 0;
  int extraRun = 0;

  String battingTeamName = " ", bowlingTeamName = " ", innings = "1st Innings";

  String batsmanOneName = " ",
      batsmanTwoName = " ",
      isOnStrikeBatsmanOne = "@",
      isOnStrikeBatsmanTwo = "";

  int batsmanOneRun = 0,
      batsmanTwoRun = 0,
      batsmanOneBallConceded = 0,
      batsmanTwoBallConceded = 0;

  bool batsmanOneOnStrike = true, batsmanTwoOnStrike = false;

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

  loadJsonData() async {
    String jsonText = await rootBundle.loadString('assets/scorecard.json');
    card = ScoreCard.fromJson(jsonDecode(jsonText));
    print(card.team[1].player[0].batting.dismissalType +
        "/n" +
        card.innings[0].onBatting);
    print(card.team[0].teamName);
    battingTeamName = card.team[0].teamName;
  }

  @override
  void initState() {
    loadJsonData();
    //setState(() {

    //bowlingTeamName = card.team[0].teamName.toString() ;
    // batsmanOneName = card.team[0].player[0].name.toString() ;
    //batsmanTwoName = card.team[0].player[0].name.toString() ;
    //bowlerName = card.team[1].player[10].name ;
    //});
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
      changeBatsmanStrike();
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

    return Scaffold(
        body: Container(
      color: Colors.black,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(children: <Widget>[
        Flexible(
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
                        color: Colors.green,
                        child: Text(battingTeamName),
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
                              color: Colors.green,
                              child: Text(batsmanOneName),
                            ),
                            flex: 5,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(isOnStrikeBatsmanOne)),
                            flex: 2,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(batsmanOneRun.toString())),
                            flex: 2,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(batsmanOneBallConceded.toString())),
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
                              color: Colors.green,
                              child: Text(batsmanTwoName),
                            ),
                            flex: 5,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(isOnStrikeBatsmanTwo)),
                            flex: 2,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(batsmanTwoRun.toString())),
                            flex: 2,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(batsmanTwoBallConceded.toString())),
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
                        color: Colors.green,
                        child: Text("Extra Info"),
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
                          color: Colors.green,
                          child: Text(innings)),
                      flex: 2,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(1),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        color: Colors.orange,
                        child: Text(
                            totalRun.toString() + " - " + wicket.toString()),
                      ),
                      flex: 5,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(1),
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text("OVERS: " +
                            overs.toString() +
                            "." +
                            ballInAOver.toString()),
                      ),
                      flex: 2,
                    ),
                    Flexible(
                      child: Container(
                          margin: EdgeInsets.all(1),
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.green,
                          child: Text("EXTRA:" + extraRun.toString())),
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
                        color: Colors.green,
                        child: Text(bowlingTeamName),
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
                              color: Colors.green,
                              child: Text(bowlerName),
                            ),
                            flex: 5,
                          ),
                          Flexible(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 1, 0.5, 1),
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: Text(bowlerWicket.toString() +
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
                                color: Colors.green,
                                child: Text(bowlerOvers.toString() +
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
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[0]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[1]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[2]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[3]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[4]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[5]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[6]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[7]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[8]),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: Text(ball[9]),
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
                        color: Colors.green,
                        child: Text("LAST 10 BALLS"),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                flex: 4,
              ),
            ],
          ),
          flex: 2,
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Container(
                height: double.infinity,
                width: 5,
                alignment: Alignment.center,
                color: Colors.lightBlueAccent,
                child: Text(textBar)),
          ),
          flex: 1,
        ),
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
                          });
                        },
                      )),
                ),
                flex: 5,
              ),
            ],
          ),
          flex: 2,
        ),
        Flexible(
          child: Row(
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
                        child: Text("UNDO"),
                        onPressed: () {
                          setState(() {
                            textBarController("undo", 0);
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
                        child: Text("NO\nBALL"),
                        onPressed: () {
                          setState(() {
                            textBarController("noBall", -1);
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
                          });
                        },
                      )),
                ),
                flex: 6,
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
                          });
                        },
                      )),
                ),
                flex: 4,
              ),
            ],
          ),
          flex: 2,
        ),
      ]),
    ));
  }
}
