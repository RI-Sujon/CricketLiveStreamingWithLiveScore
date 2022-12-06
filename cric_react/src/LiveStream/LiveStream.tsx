import * as React from 'react';
import { Divider, Grid } from '@mui/material';
import Video from './Video/Video';
import Scorecard from './Scorecard/Scorecard';
import { Stack } from '@mui/system';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import InboxIcon from '@mui/icons-material/Inbox';
import DraftsIcon from '@mui/icons-material/Drafts';
import SwipeableViews from 'react-swipeable-views';
import { useTheme } from '@mui/material/styles';
import AppBar from '@mui/material/AppBar';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';
import { validateHeaderValue } from 'http';
import Typography from '@mui/material/Typography';
import { Button } from '@mui/material';
import Graph from './Graph/Graph';

export default function LiveStream() {
    const [matchData, setMatchData] = React.useState<any>({});
    const [flag, setFlag] = React.useState(true);
    const [value, setValue] = React.useState(0);

    let navigate = useNavigate();

    let { matchId } = useParams();

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

    React.useEffect(() => {
        console.log("+-+-+-+222+-+-+:" + matchData.matchName);
        console.log("+-+-+-+333+-+-+:" + matchData.firstInningsOverTracking);
    }, [matchData]);

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

    return (
        <div>
            {flag===false
            ? <div>
                <div style={{textAlign:'center', padding: 10}}><b><big>{matchData.matchName} - {matchData.team1Name} vs {matchData.team2Name}</big></b></div> 
                
                
            
                <Grid container direction="row" justifyContent="center" alignItems="center">
                    <Grid item xs={2}>
                    </Grid>
                    <Grid item xs={8} style={{backgroundColor: "#ffddff"}}>
                        <Stack>
                            <div style={{backgroundColor: "#000000", height: 570}}>
                                <Video />
                            </div>
                            <div>
                                <Scorecard matchData={matchData}/>
                            </div>
                            <Graph matchData={matchData}/>
                        </Stack>
                    </Grid>
                    <Grid item xs={2}>
                    </Grid>
                </Grid>
            </div>
            : <div></div>
            }
        </div>
      );
}