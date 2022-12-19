import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/home_page.dart';
import 'package:cric_flutter/Pages/model/Model.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class TeamCreation extends StatefulWidget {
  const TeamCreation({Key? key}) : super(key: key);

  @override
  State<TeamCreation> createState() => _TeamCreationState();
}

class _TeamCreationState extends State<TeamCreation> {
  final _teamNameController = TextEditingController();
  List<TextEditingController> _controller =
      List.generate(16, (i) => TextEditingController());

  List<List<String>> responseArray = List.generate(
      16, (i) => List.generate(3, (j) => "i + j * 3", growable: false),
      growable: false);

  List<String> _categoryList = <String>[
    "Batsman",
    "Bowler",
    "Alrounder",
    "Wicket-Keeper Batsman",
    "Wicket-Keeper"
  ];

  List<String> _battingStyleList = <String>["Right Handed", "Left Handed"];

  List<String> _bowlingStyleList = <String>[
    "Right-arm fast",
    "Right-arm fast-medium",
    "Right-arm medium",
    "Right-arm slow-medium",
    "Right-arm slow",
    "Left-arm fast",
    "Left-arm fast-medium",
    "Left-arm medium",
    "Left-arm slow-medium",
    "Left-arm slow",
    "Right-arm spin Off break",
    "Right-arm spin Leg break",
    "Slow left-arm orthodox",
    "Slow left-arm wrist spin",
    "None"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 16; i++) {
      responseArray[i][0] = _categoryList[0];
      responseArray[i][1] = _battingStyleList[0];
      responseArray[i][2] = _bowlingStyleList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create Team"),
              backgroundColor: Color(0xff233743),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Team",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _teamNameController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Team Name',
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  buildForAPlayer(context, 0),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 1),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 2),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 3),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 4),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 5),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 6),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 7),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 8),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 9),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 10),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 11),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 12),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 13),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 14),
                  SizedBox(
                    height: 20,
                  ),
                  buildForAPlayer(context, 15),
                  SizedBox(
                    height: 20,
                  ),
                  CustomOptionButton(
                    innerText: 'Next',
                    onPressed: () {
                      saveToFirebase();
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ))));
  }

  Widget buildForAPlayer(BuildContext context, int i) {
    int playerNo = i + 1;

    return Container(
        //width: size.width * 0.6,
        decoration: BoxDecoration(
          // color: const Color(0xff233743),
          color: Color.fromARGB(255, 158, 206, 236),
          borderRadius: BorderRadius.circular(10),
        ),
        padding:
            EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Player $playerNo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 7,
                  child: TextField(
                      controller: _controller[i],
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Player Name',
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    child: dropDown(context, i),
                    padding: EdgeInsets.only(top: 26.0, left: 12.0),
                  ),
                )
                // dropDownField(context, "Category", _categoryList, 0)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: dropDownField(
                        context, "Batting Style", _battingStyleList, i, 1)),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: dropDownField(
                        context, "Bowling Style", _bowlingStyleList, i, 2)),
              ],
            ),
          ],
        ));
  }

  Widget dropDown(BuildContext context, int i) {
    return DropdownButton<String>(
      isDense: false,
      isExpanded: true,
      value: responseArray[i][0],
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          responseArray[i][0] = value!;
        });
      },
      items: _categoryList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget dropDownField(BuildContext context, String label,
      List<String> dropDownList, int i, int j) {
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
                value: responseArray[i][j],
                onChanged: (String? value) {
                  setState(() {
                    responseArray[i][j] = value!;
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

  void saveToFirebase() async {
    List<dynamic> players = [];
    for (int i = 0; i < 16; i++) {
      Player player = Player(_controller[i].text, responseArray[i][0],
          responseArray[i][1], responseArray[i][2]);
      players.add(player.toJson());
    }

    Team team = Team(_teamNameController.text, players);

    await FirebaseFirestore.instance
        .collection("Team")
        .doc()
        .set(team.toJson())
        .then((value) async {
      await Glutton.eat("Team", team.toJson());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}
