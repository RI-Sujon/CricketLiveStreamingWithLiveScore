import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Pages/team/team_creation.dart';
import 'package:cric_flutter/Pages/team/team_editing.dart';
import 'package:flutter/material.dart';

class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Team List"),
        backgroundColor: Color(0xff233743),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff233743),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TeamCreation()));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Team").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 136, 171, 192),
                    ),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(doc['teamName'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      dense: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeamEditing()));
                      },
                    ));
              },
            );
          }
        },
      ),
    ));
  }
}
