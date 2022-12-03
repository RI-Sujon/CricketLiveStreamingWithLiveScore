using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace cric_dotnet.Models
{
    public class Match
    {
        [FirestoreProperty]
        public string matchName { get; set; }
        [FirestoreProperty]
        public string overs { get; set; }
        [FirestoreProperty]
        public string team1Name { get; set; }
        [FirestoreProperty]
        public string team2Name { get; set; }
        [FirestoreProperty]
        public string team1Uid { get; set; }
        [FirestoreProperty]
        public string team2Uid { get; set; }
        [FirestoreProperty]
        public string tossWin { get; set; }
        [FirestoreProperty]
        public string optedTo { get; set; }
        [FirestoreProperty]
        public string creatorUid { get; set; }
        [FirestoreProperty]
        public Innings firstInnings { get; set; }
        [FirestoreProperty]
        public Innings secondInnings { get; set; }
       
        public List<PlayerInnings> team1Players { get; set; }
        public List<PlayerInnings> team2Players { get; set; }
    }

    public class Innings 
    {
        [FirestoreProperty]
        public string onBatting { get; set; }
        [FirestoreProperty]
        public int totalRun { get; set; }
        [FirestoreProperty]
        public int wicket { get; set; }
        [FirestoreProperty]
        public int overs { get; set; }
        [FirestoreProperty]
        public int ballInAOver { get; set; }
        [FirestoreProperty]
        public string batsmanOnStrike { get; set; }
        [FirestoreProperty]
        public string batsmanOnNonStrike { get; set; }
        [FirestoreProperty]
        public string bowler { get; set; }
        [FirestoreProperty]
        public int extras { get; set; }
        [FirestoreProperty]
        public int target { get; set; }
    }

    public class PlayerInnings 
    {
        [FirestoreProperty]
        public string name { get; set; }
        [FirestoreProperty]
        public Batting batting { get; set; }
        [FirestoreProperty]
        public Bowling bowling { get; set; }
    }

    public class Batting 
    {
        [FirestoreProperty]
        public int run { get; set; }
        [FirestoreProperty]
        public int ball { get; set; }
        [FirestoreProperty]
        public bool isOut { get; set; }
        [FirestoreProperty]
        public int battingPosition { get; set; }
        [FirestoreProperty]
        public Dismissal dismissal { get; set; }
    }


    public class Bowling
    {
        [FirestoreProperty]
        public int runConceded { get; set; }
        [FirestoreProperty]
        public int over { get; set; }
        [FirestoreProperty]
        public int ballInAOver { get; set; }
        [FirestoreProperty]
        public int wicket { get; set; }
    }

    public class Dismissal 
    {
        [FirestoreProperty]
        public string dismissalType { get; set; }
        [FirestoreProperty]
        public string batsmanName { get; set; }
        [FirestoreProperty]
        public string bowlerName { get; set; }
        [FirestoreProperty]
        public string supportBy { get; set; }
    }
}
