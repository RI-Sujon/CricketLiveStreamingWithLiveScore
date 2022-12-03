// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtm/agora_rtm.dart';
// import 'package:agora_uikit/controllers/rtc_event_handlers.dart';
// import 'package:flutter/material.dart';

// class Participate extends StatefulWidget {
//   final String channelName;
//   final String userName;
//   const Participate({Key? key}) : super(key: key);

//   @override
//   State<Participate> createState() => _ParticipateState();
// }

// class _ParticipateState extends State<Participate> {
//   late RtcEngine _engine;
//   AgoraRtmClient? _client;
//   AgoraRtmChannel? _channel;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initializeAgora();
//   }

//   Future<void> initializeAgora() async{
//     _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
//     _client = await AgoraRtmClient.createInstance(appId);

//     await _engine.enableVideo();
//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine.setClientRole(ClientRole.Broadcaster);

//     _engine.setEventHandler(
//       rtcEngineEventHandler(
//         joinChannelSuccess: (channel, uid, elapsed){
//           setState(() {
            
//           });
//           _user.add(uid);
//         }
//       )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Participant"),
//       ),
//     )
//   }
// }
