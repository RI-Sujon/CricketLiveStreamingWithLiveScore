import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetMatchId extends StatelessWidget {
  final String matchId;
  const GetMatchId({Key? key, required this.matchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //     child: Center(
    //   child: Text(matchId),
    // ));

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(matchId),
        ),
      ),
    );
  }
}
