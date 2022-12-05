import 'package:agora_rtm/agora_rtm.dart';
// import 'package:cric_flutter/LiveStreamC/message.dart';
// import 'package:cric_flutter/LiveStreamC/models/user.dart';
import 'package:cric_flutter/LiveStreamC/utils/app_id.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/services.dart';

class ParticipantPage2 extends StatefulWidget {
  final String channelName;
  final int uid;
  final String userName;
  final String type;

  const ParticipantPage2(
      {Key? key,
      required this.channelName,
      required this.uid,
      required this.userName,
      required this.type})
      : super(key: key);

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<ParticipantPage2> {
  final List<int> _users = [];
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  bool muted = false;
  bool videoDisabled = false;

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initializeAgora();
  }

  @override
  void dispose() {
    _channel?.leave();
    _client?.logout();
    _client?.destroy();
    _users.clear();
    _engine.destroy();
    _engine.leaveChannel();

    super.dispose();
  }

  Future<void> initializeAgora() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _client = await AgoraRtmClient.createInstance(appId);

    await _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    await _engine.enableAudio();
    // await _engine.

    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          _users.add(uid);
        });
      },
    ));

    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      //print("Private Message from " + peerId + ": " + (message.text));
    };

    _client?.onConnectionStateChanged = (int state, int reason) {
      //print('Connection state changed: ' + state.toString() +', reason: ' + reason.toString());
      if (state == 5) {
        _channel?.leave();
        _client?.logout();
        _client?.destroy();
        //print('Logout.');
      }
    };

    await _client?.login(null, widget.uid.toString());

    _channel = await _client?.createChannel(widget.channelName);
    await _channel?.join();

    await _engine.joinChannel(null, widget.channelName, null, 01308554743);

    _channel?.onMemberJoined = (AgoraRtmMember member) {
      //print("Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel?.onMemberLeft = (AgoraRtmMember member) {
      //print("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel?.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      //print("Public Message from " + member.userId + ": " + (message.text));
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _broadcastView(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.stop_circle_rounded,
              color: Colors.red,
              size: 55.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(4.0),
          ),
        ],
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    if (_users.isEmpty) {
      return const Center(
        child: Text("No Users"),
      );
    }
    return Expanded(
      child: RtcLocalView.SurfaceView(),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }
}
