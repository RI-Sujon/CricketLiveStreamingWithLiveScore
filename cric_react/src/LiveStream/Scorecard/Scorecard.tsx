import * as React from 'react';
import { Grid } from '@mui/material';
import { Box } from '@mui/system';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';

export default function Scorecard(props: any) {

    let { matchId } = useParams();

    const removeSerialNumber = (name: any) => {
        if(name.length > 0){
            if(name[1]==='.'){
                name = name.substring(3, name.length);
            }
            else{
                name = name.substring(4, name.length);
            }
        }
        return name ;
    }

    const setBatsmanRunAndBall = (batsmanName: any) => {
        if(props.matchData.team1Uid===props.matchData.firstInnings.onBatting){
            for(let i=0; i<props.matchData.team1Players.length; i++){
                if(props.matchData.team1Players[i].name===batsmanName){
                    return <div><b>{props.matchData.team1Players[i].batting.run}</b>({props.matchData.team1Players[i].batting.ball})</div>
                }
            }
        }
        else{
            for(let i=0; i<props.matchData.team2Players.length; i++){
                if(props.matchData.team2Players[i].name===batsmanName){
                    return <div><b>{props.matchData.team2Players[i].batting.run}</b><small>{" "}({props.matchData.team2Players[i].batting.ball})</small></div>
                }
            }
        }
    }

    const setBowlerRunAndBall = (bowlerName: any) => {
        if(props.matchData.team1Uid===props.matchData.firstInnings.onBatting){
            for(let i=0; i<props.matchData.team2Players.length; i++){
                if(props.matchData.team2Players[i].name===bowlerName){
                    return <div><b>{props.matchData.team2Players[i].batting.run}</b>({props.matchData.team2Players[i].batting.ball})</div>
                }
            }
        }
        else{
            for(let i=0; i<props.matchData.team1Players.length; i++){
                if(props.matchData.team1Players[i].name===bowlerName){
                    return <div><b>{props.matchData.team1Players[i].bowling.wicket}-{props.matchData.team1Players[i].bowling.runConceded}</b><small>{" "}({props.matchData.team1Players[i].bowling.over + "." + props.matchData.team1Players[i].bowling.ballInAOver})</small></div>
                }
            }
        }
    }

    const firstThreeCapitalLetter = (teamName: any) => {
        if(teamName.length >=3){
            teamName = teamName.toUpperCase();
            return teamName.substring(0,3);
        }
    }

    return (
        <div className="scorecard">
            <Grid container direction="row" justifyContent="center" alignItems="stretch">
                <Grid item xs={4}>
                    <div className='scorecard_part'>
                        <table width={'100%'}> 
                            <tr> 
                                <td>
                                    {removeSerialNumber(props.matchData.firstInnings.batsmanOnStrike)}*
                                </td>
                                <td>
                                    {setBatsmanRunAndBall(props.matchData.firstInnings.batsmanOnStrike)}
                                </td>
                            </tr>
                            <tr> 
                                <td>
                                    {removeSerialNumber(props.matchData.firstInnings.batsmanOnNonStrike)}
                                </td>
                                <td>
                                    {setBatsmanRunAndBall(props.matchData.firstInnings.batsmanOnNonStrike)}
                                </td>
                            </tr>
                        </table>
                    </div>
                </Grid>
                <Grid item xs={4}>
                    <div className='scorecard_part2'>
                        <div>
                            <table width="100%" style={{textAlign:"center"}}>
                                <tr>
                                    <td>
                                        { props.matchData.team1Uid===props.matchData.firstInnings.onBatting 
                                            ? firstThreeCapitalLetter(props.matchData.team2Name)
                                            : firstThreeCapitalLetter(props.matchData.team1Name)
                                        } vs <b><big>{ props.matchData.team1Uid===props.matchData.firstInnings.onBatting 
                                            ? firstThreeCapitalLetter(props.matchData.team1Name)
                                            : firstThreeCapitalLetter(props.matchData.team2Name)
                                        }</big></b></td><td><big><b>{props.matchData.firstInnings.totalRun}-{props.matchData.firstInnings.wicket}</b></big><small> (P1)</small></td><td>Over: {props.matchData.firstInnings.overs}.{props.matchData.firstInnings.ballInAOver}</td>
                                </tr>
                                <tr>
                                    <td colSpan={3} align="center"><small>Toss Win: {props.matchData.tossWin}</small></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </Grid>
                <Grid item xs={4}>
                    <div className='scorecard_part'>
                        <table width={'100%'}> 
                            <tr> 
                                <td>
                                    {removeSerialNumber(props.matchData.firstInnings.bowler)}
                                </td>
                                <td>
                                    {setBowlerRunAndBall(props.matchData.firstInnings.bowler)}
                                </td>
                            </tr>
                            <tr> 
                                <td>
                                    This Over: {""}
                                </td>
                            </tr>
                        </table>
                    </div>
                </Grid>
            </Grid>
        </div>
      );
}


// return (
//     <div className="scorecard">
//         <Grid container direction="row" justifyContent="center" alignItems="stretch">
//             <Grid item xs={4}>
//                 <div className='scorecard_part'>
//                     <Grid container direction="column" justifyContent="center" alignItems="stretch" spacing={0.5}> 
//                         <Grid item xs={6}> 
//                             <Grid container direction="row">
//                                 {/* <Grid item xs={2}>
//                                 </Grid> */}
//                                 <Grid item xs={9}>
//                                     {removeSerialNumber(props.matchData.firstInnings.batsmanOnStrike)}
//                                 </Grid>
//                                 <Grid item xs={3}>
//                                     {setBatsmanRunAndBall(props.matchData.firstInnings.batsmanOnStrike)}
//                                 </Grid>
//                             </Grid>
//                         </Grid>
//                         <Grid item xs={6}> 
//                             <Grid container direction="row">
//                                 {/* <Grid item xs={2}>
//                                 </Grid> */}
//                                 <Grid item xs={9}>
//                                     {removeSerialNumber(props.matchData.firstInnings.batsmanOnNonStrike)}
//                                 </Grid>
//                                 <Grid item xs={3}>
//                                     {setBatsmanRunAndBall(props.matchData.firstInnings.batsmanOnNonStrike)}
//                                 </Grid>
//                             </Grid>
//                         </Grid>
//                     </Grid>
//                 </div>
//             </Grid>
//             <Grid item xs={4}>
//                 <div className='scorecard_part2'>
//                     <div>
//                         <table width="100%">
//                             <tr>
//                                 <td colSpan={1}>IND BAN</td><td colSpan={12}>222-10</td>(P1)<td colSpan={1}>0.4</td>
//                             </tr>
//                             <tr>
//                                 <td colSpan={20} align="center">TARGET 203</td>
//                             </tr>
//                         </table>
//                     </div>
//                 </div>
//             </Grid>
//             <Grid item xs={4}>
//             <div className='scorecard_part'>
//                     <Grid container direction="column" justifyContent="center" alignItems="stretch" spacing={0.5}> 
//                         <Grid item xs={6}> 
//                             <Grid container direction="row">
//                                 <Grid xs={8}>
//                                     Bumrah + {matchId}
//                                 </Grid>
//                                 <Grid xs={4}>
//                                     6~1(5.4)
//                                 </Grid>
//                             </Grid>
//                         </Grid>
//                         <Grid item xs={6}> 
//                             <Grid container direction="row">
//                                 {/* <Grid item xs={2}>
//                                 </Grid> */}
//                                 {/* <Grid item xs={9}> */}
//                                     2  0  2  W  1  6
//                                 {/* </Grid> */}
//                             </Grid>
//                         </Grid>
//                     </Grid>
//                 </div>
//             </Grid>
//         </Grid>
//     </div>
//   );