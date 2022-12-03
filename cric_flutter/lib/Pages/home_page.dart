import 'package:cric_flutter/Authentication/login_page.dart';
import 'package:cric_flutter/Authentication/model/Creator.dart';
import 'package:cric_flutter/Pages/common/custom_option_button.dart';
import 'package:cric_flutter/Pages/connect_with_match.dart';
import 'package:cric_flutter/Pages/match_home_page.dart';
import 'package:cric_flutter/Pages/new_match_creation.dart';
import 'package:cric_flutter/Pages/match_list.dart';
import 'package:cric_flutter/Pages/team/team_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Creator creator = new Creator("", "");
  var creator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCreator();
  }

  void getCreator() async {
    creator = Creator.fromJson(await Glutton.vomit("Creator"));
    print(creator.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Cric App"),
        backgroundColor: Color(0xff233743),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Flexible(
              child: Container(
                color: Colors.white70,
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/friendship.png",
                                                // image: userBasicInfo.profileUri,
                                                image:
                                                    "assets/images/friendship.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(child: Container()),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, bottom: 5.0),
                                        child: Text(
                                          "Welcome,",
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: creator != null
                                              ? Text("${creator.name}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))
                                              : Text("")),
                                      Expanded(child: Container()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            creator != null ? "${creator.email}" : "",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                      ),
                    ),
                    ...getAllDrawerItems(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomOptionButton(
              innerText: 'Create a New Match',
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (_) => NewMatchCreation());
                Navigator.push(context, route);
              },
            ),
            SizedBox(
              height: 30,
            ),
            CustomOptionButton(
              innerText: 'Existing Matches',
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => MatchList());
                Navigator.push(context, route);
              },
            ),
            SizedBox(
              height: 30,
            ),
            CustomOptionButton(
              innerText: 'Teams',
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => TeamList());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
    ));
  }

  List<Widget> getAllDrawerItems() {
    return [
      getDrawerItem(context, Icons.exit_to_app, "Logout", logOut: true),
    ];
  }

  Widget getDrawerItem(BuildContext context, IconData iconData, String text,
      {String sub = " ",
      bool up = false,
      bool logOut = false,
      callBack,
      cardColor = Colors.white70}) {
    return GestureDetector(
      onTap: () {
        if (callBack != null)
          callBack();
        else if (logOut == true) {
          _logOutOperation();
        } else {}
      },
      child: Card(
        color: cardColor,
        child: ListTile(
          leading: Icon(
            iconData,
            color: Colors.black,
          ),
          title: Text(
            text,
          ),
          subtitle: Text(
            sub,
          ),
        ),
      ),
    );
  }

  Future<void> _logOutOperation() async {
    FirebaseAuth.instance.signOut();

    await Glutton.flush();

    Navigator.of(context).popUntil((route) => route == null);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
