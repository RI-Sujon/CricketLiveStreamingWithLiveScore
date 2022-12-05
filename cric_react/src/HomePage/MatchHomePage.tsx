import * as React from 'react';
import Box from '@mui/material/Box';
import SwipeableViews from 'react-swipeable-views';
import { useTheme } from '@mui/material/styles';
import AppBar from '@mui/material/AppBar';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';
import Typography from '@mui/material/Typography';
import { Button } from '@mui/material';

interface TabPanelProps {
    children?: React.ReactNode;
    dir?: string;
    index: number;
    value: number;
}

function TabPanel(props: TabPanelProps) {
    const { children, value, index, ...other } = props;
  
    return (
      <div
        role="tabpanel"
        hidden={value !== index}
        id={`full-width-tabpanel-${index}`}
        aria-labelledby={`full-width-tab-${index}`}
        {...other}
      >
        {value === index && (
          <Box sx={{ p: 3 }}>
            <Typography>{children}</Typography>
          </Box>
        )}
      </div>
    );
  }

export default function MatchHomePage() {
    const [matchData, setMatchData] = React.useState<any>({});
    const [flag, setFlag] = React.useState(true);
    const [value, setValue] = React.useState(0);

    let navigate = useNavigate();

    let { matchId } = useParams();
    const theme = useTheme();

    // const [innings, setInnings] = React.useState("first");

    React.useEffect(() => {
        const timer = setTimeout(() => {
            httpHandling();
          console.log('This will run after 1 second!')
        }, 5000);
        return () => clearTimeout(timer);
    }, [matchData]);

    React.useEffect(() => {
        if(flag){
            httpHandling();
        }
    });

    const httpHandling = () => {
        console.log("Kocchuu");
        axios.get('http://localhost:5001/match/getMatchByMatchId?matchId='+matchId)
        .then(response => {
            setMatchData(response.data);
            setFlag(false);
        }).catch(error => {
            console.log(error);
        });
    }

    const removeSerialNumber = (name: any) => {
        if(name.length > 0){
            if(name[1]=='.'){
                name = name.substring(3, name.length);
            }
            else{
                name = name.substring(4, name.length);
            }
        }
        return name ;
    }

    const handleChange = (event: React.SyntheticEvent, newValue: number) => {
        setValue(newValue);
    };
    
    const handleChangeIndex = (index: number) => {
    setValue(index);
    };

    function a11yProps(index: number) {
        return {
          id: `full-width-tab-${index}`,
          'aria-controls': `full-width-tabpanel-${index}`,
        };
    }

    const renderTDForBatting = (innings: any) => {
        let item = [];
        if(flag===false){
            var length;
            if(matchData.team1Uid===matchData.firstInnings.onBatting){
                if(innings==="first"){
                    length = matchData.team1Players.length;
                }else{
                    length = matchData.team2Players.length;
                }
            }
            else{
                if(innings==="first"){
                    length = matchData.team2Players.length;
                }else{
                    length = matchData.team1Players.length;
                }
            }

            for (let i = 0; i < length; i++) {
                var batsman ;
                var bowler ;
                var supportBy ;
                var strikeRate;
                // if(matchData.team1Uid===matchData.firstInnings.onBatting){
                if(innings==="first" && matchData.team1Uid===matchData.firstInnings.onBatting || innings==="second" && matchData.team1Uid!==matchData.firstInnings.onBatting){
                    batsman = removeSerialNumber(matchData.team1Players[i].name);
                    bowler = removeSerialNumber(matchData.team1Players[i].batting.dismissal.bowlerName);
                    supportBy = removeSerialNumber(matchData.team1Players[i].batting.dismissal.supportBy);

                    var wicketTaker = "";
                    var helper = "";
                    if(matchData.team1Players[i].batting.isOut){
                        wicketTaker = "b " + bowler;
                        if(matchData.team1Players[i].batting.dismissal.dismissalType==="Caught"){
                            helper = "c " + supportBy;
                        }
                        else if(matchData.team1Players[i].batting.dismissal.dismissalType==="Run Out"){
                            helper = "(run out) " + supportBy;
                            wicketTaker = "";
                        }
                    }

                    strikeRate = matchData.team1Players[i].batting.run/matchData.team1Players[i].batting.ball;
                    item.push(<tr><td>{batsman}</td><td>{helper}</td><td>{wicketTaker}</td><td>{matchData.team1Players[i].batting.run}</td><td>{matchData.team1Players[i].batting.ball}</td><td>{Number(strikeRate).toFixed(2)}</td></tr>);
                    // length = matchData.team1Players.length;
                }else{
                    batsman = removeSerialNumber(matchData.team2Players[i].name);
                    bowler = removeSerialNumber(matchData.team2Players[i].batting.dismissal.bowlerName);
                    supportBy = removeSerialNumber(matchData.team2Players[i].batting.dismissal.supportBy);

                    var wicketTaker = "";
                    var helper = "";
                    if(matchData.team2Players[i].batting.isOut){
                        wicketTaker = "b " + bowler;
                        if(matchData.team2Players[i].batting.dismissal.dismissalType==="Caught"){
                            helper = "c " + supportBy;
                        }
                        else if(matchData.team2Players[i].batting.dismissal.dismissalType==="Run Out"){
                            helper = "(run out) " + supportBy;
                            wicketTaker = "";
                        }
                    }
                    strikeRate = matchData.team2Players[i].batting.run/matchData.team2Players[i].batting.ball;
                    item.push(<tr><td>{batsman}</td><td>{helper}</td><td>{wicketTaker}</td><td>{matchData.team2Players[i].batting.run}</td><td>{matchData.team2Players[i].batting.ball}</td><td>{Number(strikeRate).toFixed(2)}</td></tr>);
                    // length = matchData.team2Players.length;
                }
            }
        }
        return item;
      };

      const renderTDForBowling = (innings: any) => {
        let item = [];
        var length ;
        if(matchData.team1Uid===matchData.firstInnings.onBatting){
            if(innings==="first"){
                length = matchData.team2Players.length;
            }else{
                length = matchData.team1Players.length;
            }
        }
        else{
            if(innings==="first"){
                length = matchData.team1Players.length;
            }else{
                length = matchData.team2Players.length;
            }
        }
        if(flag===false){
            for (let i = 0; i < length; i++) {
                var bowler, over, run, wicket, economy ;
                if(innings==="first" && matchData.team1Uid===matchData.firstInnings.onBatting || innings==="second" && matchData.team1Uid!==matchData.firstInnings.onBatting){
                    bowler = removeSerialNumber(matchData.team2Players[i].name);
                    over = matchData.team2Players[i].bowling.over + "." + matchData.team2Players[i].bowling.ballInAOver;
                    run = matchData.team2Players[i].bowling.runConceded;
                    wicket = matchData.team2Players[i].bowling.wicket;

                    var overInDecimal = (matchData.team2Players[i].bowling.over) + (matchData.team2Players[i].bowling.ballInAOver)*10/6;

                    if(overInDecimal!==0)
                        economy = run/overInDecimal;
                    else
                        economy = 0 ;
    
                    item.push(<tr><td>{bowler}</td><td>{over}</td><td>{run}</td><td>{wicket}</td><td>{economy}</td></tr>);
                }
                else{
                    bowler = removeSerialNumber(matchData.team1Players[i].name);
                    over = matchData.team1Players[i].bowling.over + "." + matchData.team1Players[i].bowling.ballInAOver;
                    run = matchData.team1Players[i].bowling.runConceded;
                    wicket = matchData.team1Players[i].bowling.wicket;

                    var overInDecimal = (matchData.team1Players[i].bowling.over) + (matchData.team1Players[i].bowling.ballInAOver)*10/6;

                    if(overInDecimal!==0)
                        economy = run*1.0/overInDecimal;
                    else
                        economy = 0 ;

                    item.push(<tr><td>{bowler}</td><td>{over}</td><td>{run}</td><td>{wicket}</td><td>{Number(economy).toFixed(2)}</td></tr>);
                }
            }
        }
        return item;
      };

    return <div style={{alignSelf:"center"}}>
        {flag===false
            ? <div>
                
        <Box sx={{ bgcolor: 'background.paper', width: 1000, paddingLeft: 10, paddingRight: 10 }}>
        <table width={'100%'}>
            <tr>
                <th> <h1 style={{textAlign:'center'}}> {matchData.matchName} - {matchData.team1Name} vs {matchData.team2Name} </h1></th>
            </tr>
            <tr>
                <td>
                    {matchData.tossWin} won the toss and opted to {matchData.optedTo} first.
                </td>
            </tr>
            <br />
            <tr>
                <td> 
                <big> <b>
                {(matchData.team1Uid===matchData.firstInnings.onBatting)
                    ? matchData.team1Name + " " 
                    : matchData.team2Name + " "} 
                    {matchData.firstInnings.totalRun}/{matchData.firstInnings.wicket} ({matchData.firstInnings.overs}.{matchData.firstInnings.ballInAOver})
                    </b> </big>
                </td>
            </tr>
            
            <tr>
                <td>
                {(matchData.team1Uid!==matchData.firstInnings.onBatting)
                    ? matchData.team1Name + " " 
                    : matchData.team2Name + " "} 
                    {matchData.secondInnings.totalRun}/{matchData.secondInnings.wicket} ({matchData.secondInnings.overs}.{matchData.secondInnings.ballInAOver})
                </td>
            </tr>
            
        </table>
        <br />
        <Button variant="contained"
            onClick={()=>{
                navigate("/liveStream/"+matchId);
            }}
        >Watch Live</Button>
        <br /><br />
      <AppBar position="static">
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="secondary"
          textColor="inherit"
          variant="fullWidth"
          aria-label="full width tabs example"
        >
          <Tab label="First Innings" {...a11yProps(0)} />
          <Tab label="Second Innings" {...a11yProps(1)} />
        </Tabs>
      </AppBar>
      <SwipeableViews
        axis={theme.direction === 'rtl' ? 'x-reverse' : 'x'}
        index={value}
        onChangeIndex={handleChangeIndex}
      >
        
        <TabPanel value={value} index={0} dir={theme.direction}>
        <h3>Batting Innings</h3>
        <table width={'100%'}>
            <tr style={{textAlign:"left"}}>
                <th> Batsman </th>
                <th></th>
                <th></th>
                <th> Run </th>
                <th> Ball </th>
                <th> Strike Rate </th>
            </tr>
            {renderTDForBatting("first")}
        </table>
        <br />
        Extras: {matchData.firstInnings.extras} <br/>
        Total Run: {matchData.firstInnings.totalRun}, Overs: {matchData.firstInnings.overs}.{matchData.firstInnings.ballInAOver}, Wicket: {matchData.firstInnings.wicket}
        <br />
        <br />
        <br />
        <h3>Bowling Innings</h3>
        <table width={'100%'}>
            <tr style={{textAlign:"left"}}>
                <th> Bowler </th>
                <th>Overs</th>
                <th>Run</th>
                <th> Wicket </th>
                <th> Economy </th>
            </tr>
            {renderTDForBowling("first")}
        </table>
        </TabPanel>
        <TabPanel value={value} index={1} dir={theme.direction}>
        { matchData.firstInnings.target !== 0
            ? <div>
                <h3>Batting Innings</h3>
                <table width={'100%'}>
                    <tr>
                        <th> Batsman </th>
                        <th></th>
                        <th></th>
                        <th> Run </th>
                        <th> Ball </th>
                        <th> Strike Rate </th>
                    </tr>
                    {renderTDForBatting("second")}
                </table>
                <br />
                Extras: {matchData.firstInnings.extras} <br/>
                Total Run: {matchData.firstInnings.totalRun}, Overs: {matchData.firstInnings.overs}.{matchData.firstInnings.ballInAOver}, Wicket: {matchData.firstInnings.wicket}
                <br />
                <br />
                <br />

                <h3>Bowling Innings</h3>
                <table width={'100%'}>
                    <tr style={{textAlign:"right"}}>
                        <th> Bowler </th>
                        <th>Overs</th>
                        <th>Run</th>
                        <th> Wicket </th>
                        <th> Economy </th>
                    </tr>
                    {renderTDForBowling("second")}
                </table>
            </div>
            : <div></div>
        }
        </TabPanel>
      </SwipeableViews>
    </Box>
            </div>
            : <div></div>
        }
    </div>

}