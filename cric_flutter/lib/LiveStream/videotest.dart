// import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoTest extends StatefulWidget {
  // const MyHomePage({Key? key}) : super(key: key);

  // final String title;

  @override
  State<VideoTest> createState() => _VideoTestState();
}

class _VideoTestState extends State<VideoTest> {
  static const appId = "4f7a17a871a047d5a68fd38ce503f11c";

  // AgoraClient agoraClient = AgoraClient(
  //     agoraConnectionData:
  //         AgoraConnectionData(appId: appId, channelName: "test"),
  //     enabledPermission: [Permission.camera, Permission.microphone]);

  @override
  void initState() {
    super.initState();
    // agoraClient.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video"),
        ),
        body: Stack(
          children: [
            // AgoraVideoViewer(client: agoraClient),
            // AgoraVideoButtons(client: agoraClient)
          ],
        ));
  }
}
