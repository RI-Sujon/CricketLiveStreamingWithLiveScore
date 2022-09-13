class Batting {
  int run;
  int ball;
  String dismissalType;
  int battingPosition;

  Batting(this.run, this.ball, this.dismissalType, this.battingPosition);

  factory Batting.fromJson(dynamic json) {
    return Batting(json['run'] as int, json['ball'] as int,
        json['dismissalType'] as String, json['battingPosition'] as int);
  }

  /*@override
  String toString() {
    return '{ ${this.name}, ${this.age} }';
  }*/

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
}

class Player {
  String name;
  Batting batting;
  Bowling bowling;

  Player(this.name, this.batting, this.bowling);

  factory Player.fromJson(dynamic json) {
    return Player(json['name'] as String, Batting.fromJson(json['batting']),
        Bowling.fromJson(json['bowling']));
  }
}

class Team {
  String teamName;
  List<Player> player;

  Team(this.teamName, this.player);

  factory Team.fromJson(dynamic json) {
    if (json['player'] != null) {
      var tagObjsJson = json['player'] as List;
      List<Player> tags =
          tagObjsJson.map((tagJson) => Player.fromJson(tagJson)).toList();
      return Team(json['teamName'] as String, tags);
    } else {
      return Team(json['teamName'] as String, []);
    }
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

  Innings(
      this.onBatting,
      this.totalRun,
      this.wicket,
      this.overs,
      this.ballInAOver,
      this.batsmanOnStrike,
      this.batsmanOnNonStrike,
      this.bowler);

  factory Innings.fromJson(dynamic json) {
    return Innings(
        json['onBatting'] as String,
        json['totalRun'] as int,
        json['wicket'] as int,
        json['overs'] as int,
        json['ballInAOver'] as int,
        json['batsmanOnStrike'] as String,
        json['batsmanOnNonStrike'] as String,
        json['bowler'] as String);
  }
}

class ScoreCard {
  List<Team> team;
  List<Innings> innings;

  ScoreCard(this.team, this.innings);

  factory ScoreCard.fromJson(dynamic json) {
    var tagObjsJson = json['team'] as List;
    var tagObjsJson2 = json['innings'] as List;
    List<Team> tags =
        tagObjsJson.map((tagJson) => Team.fromJson(tagJson)).toList();
    List<Innings> tags2 =
        tagObjsJson2.map((tagJson) => Innings.fromJson(tagJson)).toList();
    return ScoreCard(tags, tags2);
  }
}
