import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/match_home_page.dart';
import 'package:cric_flutter/Pages/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class NewMatchCreation extends StatefulWidget {
  const NewMatchCreation({Key? key}) : super(key: key);

  @override
  State<NewMatchCreation> createState() => _NewMatchCreationState();
}

enum SingingCharacter { team1wintoss, team2wintoss }

enum SingingCharacter2 { bat, bowl }

class _NewMatchCreationState extends State<NewMatchCreation> {
  SingingCharacter? _character = SingingCharacter.team1wintoss;
  SingingCharacter2? _character2 = SingingCharacter2.bat;

  final _matchController = TextEditingController();
  final _oversController = TextEditingController();

  var firebaseUser;
  List<String> teamName = ["", ""];

  List<String> teamNameList = [];
  // final Map<String, String> teamList = new Map<String, String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseUser = FirebaseAuth.instance.currentUser;

    // FirebaseFirestore.instance.collection("Team").get().then((value) => {});

    FirebaseFirestore.instance
        .collection('Team')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // teamList[doc.id] = doc["teamName"];
        teamNameList.add(doc.id + "~!^" + doc["teamName"]);
      });

      teamName[0] = teamNameList[0];
      teamName[1] = teamNameList[1];
      // teamList.forEach((key, value) {
      //   print(key + ":" + value);
      // });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create Match"),
              backgroundColor: Color(0xff233743),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Match",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _matchController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Match Name',
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Teams",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // TextField(
                  //     controller: _team1NameController,
                  //     decoration: InputDecoration(
                  //       border: UnderlineInputBorder(),
                  //       labelText: 'Team1 Name',
                  //     )),
                  dropDownField(context, "Team 1", teamNameList, 0),
                  SizedBox(
                    height: 40,
                  ),
                  dropDownField(context, "Team 2", teamNameList, 1),

                  // TextField(
                  //   controller: _team2NameController,
                  //   decoration: InputDecoration(
                  //     border: UnderlineInputBorder(),
                  //     labelText: 'Team2 Name',
                  //   ),
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Toss won by",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Team1"),
                          leading: Radio(
                            value: SingingCharacter.team1wintoss,
                            groupValue: _character,
                            onChanged: (SingingCharacter? v) {
                              setState(() {
                                _character = v;
                                print(_character);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Team2"),
                          leading: Radio(
                            value: SingingCharacter.team2wintoss,
                            groupValue: _character,
                            onChanged: (SingingCharacter? v) {
                              setState(() {
                                _character = v;
                                print(_character);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Opted to",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Bat"),
                          leading: Radio(
                            value: SingingCharacter2.bat,
                            groupValue: _character2,
                            onChanged: (SingingCharacter2? v) {
                              setState(() {
                                _character2 = v;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Bowl"),
                          leading: Radio(
                            value: SingingCharacter2.bowl,
                            groupValue: _character2,
                            onChanged: (SingingCharacter2? v) {
                              setState(() {
                                _character2 = v;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text("Overs",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _oversController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Number of Overs',
                      )),
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
                value: teamName[i],
                onChanged: (String? value) {
                  setState(() {
                    teamName[i] = value!;
                  });
                },
                focusColor: Colors.blue,
                autofocus: true,
                items:
                    dropDownList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.substring(23, value.length)),
                  );
                }).toList(),
              )),
        ),
      ],
    );
  }

  void saveToFireBase() async {
    // Route route = MaterialPageRoute(builder: (_) => ScorePage());
    // Navigator.pushReplacement(context, route);
    var tossWinBy = "";
    if (_character == SingingCharacter.team1wintoss) {
      tossWinBy = teamName[0].substring(23, teamName[0].length);
    } else {
      tossWinBy = teamName[1].substring(23, teamName[1].length);
    }

    var optedTo = "";
    if (_character2 == SingingCharacter2.bat) {
      optedTo = "BAT";
    } else {
      optedTo = "BOWL";
    }

    var onBatting1 = "";
    var onBatting2 = "";
    if (_character == SingingCharacter.team1wintoss &&
            _character2 == SingingCharacter2.bat ||
        _character == SingingCharacter.team2wintoss &&
            _character2 == SingingCharacter2.bowl) {
      onBatting1 = teamName[0].substring(0, 20);
      onBatting2 = teamName[1].substring(0, 20);
    } else {
      onBatting1 = teamName[1].substring(0, 20);
      onBatting2 = teamName[0].substring(0, 20);
    }

    OverTracking overTracking = OverTracking("", 0, 0, 0);
    List overTrakingList = [];

    overTrakingList.add(overTracking.toJson());

    Match match = Match(
        _matchController.text,
        teamName[0].substring(23, teamName[0].length),
        teamName[1].substring(23, teamName[1].length),
        teamName[0].substring(0, 20),
        teamName[1].substring(0, 20),
        tossWinBy,
        optedTo,
        _oversController.text,
        firebaseUser.uid,
        Innings(onBatting1, 0, 0, 0, 0, "", "", "", 0, 0),
        Innings(onBatting2, 0, 0, 0, 0, "", "", "", 0, 0),
        [],
        [],
        overTrakingList,
        overTrakingList);

    var docId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection("Match")
        .doc(docId)
        .set(match.toJson())
        .then((dynamic value) async {
      await Glutton.eat("Match", match.toJson());
      await Glutton.eat("MatchId", docId);
      print(
          ".....................................................................");
      print(value);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MatchHomePage()));
    });
  }
}
