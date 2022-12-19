import 'package:cric_flutter/Authentication/common/custom_form_button.dart';
import 'package:cric_flutter/LiveStreamC/pages/conmentrory.dart';
import 'package:cric_flutter/LiveStreamC/pages/director_page.dart';
import 'package:cric_flutter/LiveStreamC/pages/participant_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveStreamHomePage extends StatefulWidget {
  final String type;

  const LiveStreamHomePage(this.type);

  @override
  _LiveStreamHomePageState createState() => _LiveStreamHomePageState();
}

//
class _LiveStreamHomePageState extends State<LiveStreamHomePage> {
  final _channelName = TextEditingController();
  final _userName = TextEditingController();
  String check = '';
  late int uid;

  @override
  void initState() {
    getUserUid();
    super.initState();
  }

  Future<void> getUserUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? storedUid = preferences.getInt("localUid");
    if (storedUid != null) {
      uid = storedUid;
      print("storedUID: $uid");
    } else {
      //should only happen once, unless they delete the app
      int time = DateTime.now().millisecondsSinceEpoch;
      uid = int.parse(time.toString().substring(1, time.toString().length - 3));
      preferences.setInt("localUid", uid);
      print("settingUID: $uid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connect with a Match"),
          backgroundColor: Color(0xff233743),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image.asset("images/streamer.png"),
              SizedBox(
                height: 5,
              ),
              Text(
                "Enter Match ID",
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  controller: _channelName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Match ID',
                  ),
                ),
              ),
              SizedBox(height: 30),
              CustomFormButton(
                innerText: 'Connect',
                onPressed: joinParticipant,
              ),
              SizedBox(height: 30),
            ],
          ),
        )));
  }

  Future<void> joinDirector() async {
    await [Permission.camera, Permission.microphone].request();

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => BroadcastPage(
    //       channelName: _channelName.text,
    //       uid: uid,
    //     ),
    //   ),
    // );
  }

  Future<void> joinParticipant() async {
    await [Permission.camera, Permission.microphone].request();

    if (widget.type == "video") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ParticipantPage(
            channelName: _channelName.text,
            uid: uid,
            userName: _userName.text,
            type: "video",
          ),
        ),
      );
    } else if (widget.type == "audio") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ParticipantPage2(
            channelName: _channelName.text,
            uid: uid,
            userName: _userName.text,
            type: "audio",
          ),
        ),
      );
    }
  }
}
