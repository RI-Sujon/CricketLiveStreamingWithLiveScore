import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConnectWithMatch extends StatefulWidget {
  const ConnectWithMatch({Key? key}) : super(key: key);

  @override
  State<ConnectWithMatch> createState() => _ConnectWithMatchState();
}

class _ConnectWithMatchState extends State<ConnectWithMatch> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(),
    ));
  }
}
