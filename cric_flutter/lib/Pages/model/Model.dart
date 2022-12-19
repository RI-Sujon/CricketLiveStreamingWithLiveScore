class Match {
  String matchName = "";
  String overs = "";
  String team1Name = "";
  String team2Name = "";
  String team1Uid = "";
  String team2Uid = "";
  String tossWin = "";
  String optedTo = "";
  String creatorUid = "";
  Innings firstInnings = Innings("", 0, 0, 0, 0, "", "", "", 0, 0);
  Innings secondInnings = Innings("", 0, 0, 0, 0, "", "", "", 0, 0);
  List<dynamic> team1Players = [];
  List<dynamic> team2Players = [];
  List<dynamic> firstInningsOverTracking = [];
  List<dynamic> secondInningsOverTracking = [];

  Match(
      this.matchName,
      this.team1Name,
      this.team2Name,
      this.team1Uid,
      this.team2Uid,
      this.tossWin,
      this.optedTo,
      this.overs,
      this.creatorUid,
      this.firstInnings,
      this.secondInnings,
      this.team1Players,
      this.team2Players,
      this.firstInningsOverTracking,
      this.secondInningsOverTracking);

  Match.fromJson(Map<String, dynamic> json) {
    matchName = json['matchName'];
    overs = json['overs'];
    team1Name = json['team1Name'];
    team2Name = json['team2Name'];
    team1Uid = json["team1Uid"];
    team2Uid = json['team2Uid'];
    tossWin = json['tossWin'];
    optedTo = json['optedTo'];
    creatorUid = json['creatorUid'];
    firstInnings = Innings.fromJson(json['firstInnings']);
    secondInnings = Innings.fromJson(json['secondInnings']);
    team1Players = json['team1Players'];
    team2Players = json['team2Players'];
    firstInningsOverTracking = json['firstInningsOverTracking'];
    secondInningsOverTracking = json['secondInningsOverTracking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchName'] = this.matchName;
    data['overs'] = this.overs;
    data['team1Name'] = this.team1Name;
    data['team2Name'] = this.team2Name;
    data['team1Uid'] = this.team1Uid;
    data['team2Uid'] = this.team2Uid;
    data['tossWin'] = this.tossWin;
    data['optedTo'] = this.optedTo;
    data['creatorUid'] = this.creatorUid;
    data['firstInnings'] = this.firstInnings.toJson();
    data['secondInnings'] = this.secondInnings.toJson();
    data['team1Players'] = this.team1Players;
    data['team2Players'] = this.team2Players;
    data['firstInningsOverTracking'] = this.firstInningsOverTracking;
    data['secondInningsOverTracking'] = this.secondInningsOverTracking;

    return data;
  }
}

class Innings {
  String onBatting;
  int totalRun;
  int wicket;
  int overs;
  int ballInAOver;
  String batsmanOnStrike;
  String batsmanOnNonStrike;
  String bowler;
  int extras;
  int target;

  Innings(
      this.onBatting,
      this.totalRun,
      this.wicket,
      this.overs,
      this.ballInAOver,
      this.batsmanOnStrike,
      this.batsmanOnNonStrike,
      this.bowler,
      this.extras,
      this.target);

  factory Innings.fromJson(dynamic json) {
    return Innings(
      json['onBatting'] as String,
      json['totalRun'] as int,
      json['wicket'] as int,
      json['overs'] as int,
      json['ballInAOver'] as int,
      json['batsmanOnStrike'] as String,
      json['batsmanOnNonStrike'] as String,
      json['bowler'] as String,
      json['extras'] as int,
      json['target'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onBatting'] = this.onBatting;
    data['totalRun'] = this.totalRun;
    data['wicket'] = this.wicket;
    data['overs'] = this.overs;
    data['ballInAOver'] = this.ballInAOver;
    data['batsmanOnStrike'] = this.batsmanOnStrike;
    data['batsmanOnNonStrike'] = this.batsmanOnNonStrike;
    data['bowler'] = this.bowler;
    data['extras'] = this.extras;
    data['target'] = this.target;

    return data;
  }
}

class Batting {
  int run;
  int ball;
  bool isOut;
  int battingPosition;
  Dismissal dismissal;

  Batting(
      this.run, this.ball, this.isOut, this.battingPosition, this.dismissal);

  factory Batting.fromJson(dynamic json) {
    return Batting(
        json['run'] as int,
        json['ball'] as int,
        json['isOut'] as bool,
        json['battingPosition'] as int,
        json['dismissal'] == Null
            ? Dismissal("", "", "", "")
            : Dismissal.fromJson(json['dismissal']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['run'] = this.run;
    data['ball'] = this.ball;
    data['isOut'] = this.isOut;
    data['battingPosition'] = this.battingPosition;
    data['dismissal'] = this.dismissal.toJson();

    return data;
  }
}

class Bowling {
  int runConceded;
  int over;
  int ballInAOver;
  int wicket;

  Bowling(this.runConceded, this.over, this.ballInAOver, this.wicket);

  factory Bowling.fromJson(dynamic json) {
    return Bowling(json['runConceded'] as int, json['over'] as int,
        json['ballInAOver'] as int, json['wicket'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['runConceded'] = this.runConceded;
    data['over'] = this.over;
    data['ballInAOver'] = this.ballInAOver;
    data['wicket'] = this.wicket;

    return data;
  }
}

class PlayerInnings {
  String name;
  Batting batting;
  Bowling bowling;

  PlayerInnings(this.name, this.batting, this.bowling);

  factory PlayerInnings.fromJson(dynamic json) {
    return PlayerInnings(json['name'] as String,
        Batting.fromJson(json['batting']), Bowling.fromJson(json['bowling']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['batting'] = this.batting.toJson();
    data['bowling'] = this.bowling.toJson();

    return data;
  }
}

class Dismissal {
  String dismissalType;
  String batsmanName;
  String bowlerName;
  String supportBy;

  Dismissal(
      this.dismissalType, this.batsmanName, this.bowlerName, this.supportBy);

  factory Dismissal.fromJson(dynamic json) {
    return Dismissal(
        json['dismissalType'] as String,
        json['batsmanName'] as String,
        json['bowlerName'] as String,
        json['supportBy'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dismissalType'] = this.dismissalType;
    data['batsmanName'] = this.batsmanName;
    data['bowlerName'] = this.bowlerName;
    data['supportBy'] = this.supportBy;

    return data;
  }
}

class Team {
  String teamName = "team";
  List<dynamic> players;

  Team(this.teamName, this.players);

  factory Team.fromJson(dynamic json) {
    if (json['players'] != null) {
      var tagObjsJson = json['players'] as List;
      List<Player> tags =
          tagObjsJson.map((tagJson) => Player.fromJson(tagJson)).toList();
      return Team(json['teamName'] as String, tags);
    } else {
      return Team(json['teamName'] as String, []);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamName'] = this.teamName;
    data['players'] = this.players;

    return data;
  }
}

class Player {
  String name = "Player";
  String battingStyle = "";
  String bowlingStyle = "";
  String category = "";

  Player(this.name, this.category, this.battingStyle, this.bowlingStyle);

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    battingStyle = json['battingStyle'];
    bowlingStyle = json['bowlingStyle'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['battingStyle'] = this.battingStyle;
    data['bowlingStyle'] = this.bowlingStyle;
    data['category'] = this.category;

    return data;
  }
}

class OverTracking {
  String bowlerName = "";
  int overNo = 0;
  int totalRun = 0;
  int wicket = 0;

  OverTracking(this.bowlerName, this.overNo, this.totalRun, this.wicket);

  OverTracking.fromJson(Map<String, dynamic> json) {
    bowlerName = json['bowlerName'];
    overNo = json['overNo'];
    totalRun = json['totalRun'];
    wicket = json['wicket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowlerName'] = this.bowlerName;
    data['overNo'] = this.overNo;
    data['totalRun'] = this.totalRun;
    data['wicket'] = this.wicket;

    return data;
  }
}
