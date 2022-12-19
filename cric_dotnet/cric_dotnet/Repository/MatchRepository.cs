using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cric_dotnet.Models;
using Google.Cloud.Firestore;

namespace cric_dotnet.Repository
{
    public class MatchRepository
    {
        public Match match = new Match();

        async public Task<Dictionary<string, dynamic>> GetMatchList()
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"cloudfire.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

            FirestoreDb database = FirestoreDb.Create("cricproject-b1fb5");
            Dictionary<string, dynamic> mainMap = new Dictionary<string, dynamic>();
            List<dynamic> list = new List<object>();
            Query query = database.Collection("Match");
            QuerySnapshot snapshots = await query.GetSnapshotAsync();
            foreach (DocumentSnapshot documentSnapshot in snapshots.Documents)
            {
                Console.WriteLine("Document data for {0} document:", documentSnapshot.Id);
                Dictionary<string, object> pairs = documentSnapshot.ToDictionary();
                Dictionary<string, string> map = new Dictionary<string, string>();
                foreach (KeyValuePair<string, dynamic> pair in pairs)
                {
                    Console.WriteLine("{0}: {1}", pair.Key, pair.Value);
                    if (pair.Key == "matchName")
                    {
                        map.Add("matchId", documentSnapshot.Id);
                        map.Add("matchName", pair.Value);
                    }
                    else if (pair.Key == "team1Name") 
                    {
                        map.Add("team1Name", pair.Value);
                    }
                    else if (pair.Key == "team2Name")
                    {
                        map.Add("team2Name", pair.Value);
                    }

                }
                Console.WriteLine("");
                list.Add(map);
            }

            mainMap.Add("matchList", list);

            return mainMap;
        }

        async public Task<Match> GetMatch(string matchId)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"cloudfire.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

            FirestoreDb database = FirestoreDb.Create("cricproject-b1fb5");

            DocumentReference docRef = database.Collection("Match").Document(matchId);
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

            return convertToMatch(snapshot);
        }

        public Match convertToMatch(DocumentSnapshot snapshot) 
        {
            Dictionary<string, object> city = snapshot.ToDictionary();
            foreach (KeyValuePair<string, dynamic> pair in city)
            {
                if (pair.Key == "matchName")
                    match.matchName = pair.Value;

                else if (pair.Key == "overs")
                    match.overs = pair.Value;

                else if (pair.Key == "team1Name")
                    match.team1Name = pair.Value;

                else if (pair.Key == "team2Name")
                    match.team2Name = pair.Value;

                else if (pair.Key == "team1Uid")
                    match.team1Uid = pair.Value;

                else if (pair.Key == "team2Uid")
                    match.team2Uid = pair.Value;

                else if (pair.Key == "tossWin")
                    match.tossWin = pair.Value;

                else if (pair.Key == "optedTo")
                    match.optedTo = pair.Value;

                else if (pair.Key == "creatorUid")
                    match.creatorUid = pair.Value;

                else if (pair.Key == "team2Name")
                    match.team2Name = pair.Value;

                else if (pair.Key == "firstInnings")
                    match.firstInnings = convertToInnings(pair.Value);

                else if (pair.Key == "secondInnings")
                    match.secondInnings = convertToInnings(pair.Value);

                else if (pair.Key == "team1Players")
                {
                    List<PlayerInnings> players = new List<PlayerInnings>();
                    foreach (var p in pair.Value)
                    {
                        players.Add(convertToPlayerInnings(p));
                    }

                    match.team1Players = players;
                }

                else if (pair.Key == "team2Players") 
                {
                    List<PlayerInnings> players = new List<PlayerInnings>();
                    foreach (var p in pair.Value)
                    {
                        players.Add(convertToPlayerInnings(p));
                    }

                    match.team2Players = players;
                }

                else if (pair.Key == "firstInningsOverTracking")
                {
                    List<OverTracking> overTrackings = new List<OverTracking>();
                    foreach (var p in pair.Value)
                    {
                        overTrackings.Add(convertToOverTracking(p));
                    }

                    match.firstInningsOverTracking = overTrackings;
                }

                else if (pair.Key == "secondInningsOverTracking")
                {
                    List<OverTracking> overTrackings = new List<OverTracking>();
                    foreach (var p in pair.Value)
                    {
                        overTrackings.Add(convertToOverTracking(p));
                    }

                    match.secondInningsOverTracking = overTrackings;
                }

            }

            return match;
        }

        public Innings convertToInnings(dynamic pairValue) 
        {
            Innings innings = new Innings();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "onBatting")
                    innings.onBatting = pair.Value;

                else if (pair.Key == "totalRun")
                    innings.totalRun = (int)pair.Value;

                else if (pair.Key == "wicket")
                    innings.wicket = (int)pair.Value;

                else if (pair.Key == "overs")
                    innings.overs = (int)pair.Value;

                else if (pair.Key == "ballInAOver")
                    innings.ballInAOver = (int)pair.Value;

                else if (pair.Key == "batsmanOnStrike")
                    innings.batsmanOnStrike = pair.Value;

                else if (pair.Key == "batsmanOnNonStrike")
                    innings.batsmanOnNonStrike = pair.Value;

                else if (pair.Key == "bowler")
                    innings.bowler = pair.Value;

                else if (pair.Key == "extras")
                    innings.extras = (int)pair.Value;

                else if (pair.Key == "target")
                    innings.target = (int)pair.Value;

            }

            return innings;
        }

        public OverTracking convertToOverTracking(dynamic pairValue)
        {
            OverTracking overTracking = new OverTracking();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "bowlerName")
                    overTracking.bowlerName = pair.Value;

                else if (pair.Key == "overNo")
                    overTracking.overNo = (int)pair.Value;

                else if (pair.Key == "totalRun")
                    overTracking.totalRun = (int)pair.Value;

                else if (pair.Key == "wicket")
                    overTracking.wicket = (int)pair.Value;
            }

            return overTracking;
        }


        public PlayerInnings convertToPlayerInnings(dynamic pairValue) 
        {
            PlayerInnings playerInnings = new PlayerInnings();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "name")
                    playerInnings.name = pair.Value;

                else if (pair.Key == "batting")
                {
                    playerInnings.batting = convertToBatting(pair.Value);
                }

                else if (pair.Key == "bowling")
                {
                    playerInnings.bowling = convertToBowling(pair.Value);
                }
            }

            return playerInnings;
        }

        public Batting convertToBatting(dynamic pairValue)
        {
            Batting batting = new Batting();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "run")
                    batting.run = (int)pair.Value;

                else if (pair.Key == "ball")
                    batting.ball = (int)pair.Value;

                else if (pair.Key == "isOut")
                    batting.isOut = pair.Value;

                else if (pair.Key == "battingPosition")
                    batting.battingPosition = (int)pair.Value;

                else if (pair.Key == "dismissal")
                {
                    batting.dismissal = convertToDismissal(pair.Value);
                }
            }

            return batting;
        }

        public Bowling convertToBowling(dynamic pairValue)
        {
            Bowling bowling = new Bowling();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "runConceded")
                    bowling.runConceded = (int)pair.Value;

                else if (pair.Key == "over")
                    bowling.over = (int)pair.Value;

                else if (pair.Key == "ballInAOver")
                    bowling.ballInAOver = (int)pair.Value;

                else if (pair.Key == "wicket")
                    bowling.wicket = (int)pair.Value;
            }

            return bowling;
        }

        public Dismissal convertToDismissal(dynamic pairValue)
        {
            Dismissal dismissal = new Dismissal();

            foreach (KeyValuePair<string, dynamic> pair in pairValue)
            {
                if (pair.Key == "dismissalType")
                    dismissal.dismissalType = pair.Value;

                else if (pair.Key == "batsmanName")
                    dismissal.batsmanName = pair.Value;

                else if (pair.Key == "bowlerName")
                    dismissal.bowlerName = pair.Value;

                else if (pair.Key == "supportBy")
                    dismissal.supportBy = pair.Value;
            }

            return dismissal;
        }

        async public Task<Match> GetById(string matchId)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"cloudfire.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

            FirestoreDb database = FirestoreDb.Create("cricproject-b1fb5");

            DocumentReference docRef = database.Collection("Match").Document(matchId);
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();
            if (snapshot.Exists)
            {
                Match match = new Match();
                Console.WriteLine("Document data for {0} document:", snapshot.Id);
                Dictionary<string, object> city = snapshot.ToDictionary();
                foreach (KeyValuePair<string, dynamic> pair in city)
                {
                    Console.WriteLine("{0}: {1}", pair.Key, pair.Value);
                    if (pair.Key == "creatorUid")
                    {
                        match.creatorUid = pair.Value;
                    }
                    else if (pair.Key == "team1Players")
                    {
                        //List k = pair.Value.ToDictionary();
                        foreach (var p in pair.Value)
                        {
                            Console.WriteLine("============> {0}", p);
                            foreach (KeyValuePair<string, dynamic> k in p)
                            {
                                Console.WriteLine("------->{0}: {1}", k.Key, k.Value);
                            }

                        }

                    }

                }

                Match match2 = snapshot.ConvertTo<Match>();
                return match;
            }

            return snapshot.ConvertTo<Match>(); ;
        }

    }

}
