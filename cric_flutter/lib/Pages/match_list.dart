import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/match_home_page.dart';
import 'package:cric_flutter/Pages/model/Model.dart';
import 'package:cric_flutter/Pages/new_match_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';

class MatchList extends StatefulWidget {
  const MatchList({Key? key}) : super(key: key);

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  late var firebaseUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firebaseUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Match List"),
        backgroundColor: Color(0xff233743),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff233743),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewMatchCreation()));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Match").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return doc['creatorUid'] != firebaseUser.uid
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 136, 171, 192),
                        ),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(12),
                        child: ListTile(
                          title: Text(doc['matchName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          dense: true,
                          onTap: () async {
                            // Match match = Match(
                            //     doc['matchName'],
                            //     doc['team1Name'],
                            //     doc['team2Name'],
                            //     doc['team1Uid'],
                            //     doc['team2Uid'],
                            //     doc['tossWin'],
                            //     doc['optedTo'],
                            //     doc['overs'],
                            //     doc['creatorUid'],
                            //     doc['firstInnings'],
                            //     doc['secondInnings'],
                            //     doc['team1Players'],
                            //     doc['team2Players']);
                            // onTapToListTile(match, doc.id);
                            await Glutton.eat("Match", doc.data());
                            await Glutton.eat("MatchId", doc.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchHomePage()));
                          },
                        ));
              },
            );
          }
        },
      ),
    ));
  }

  void onTapToListTile(Match match, String docId) async {
    await Glutton.eat("Match", match.toJson());
    await Glutton.eat("MatchId", docId);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MatchHomePage()));
  }
}
