import * as React from 'react';
import { Grid } from '@mui/material';
import { Box } from '@mui/system';

export default function Scorecard() {
    return (
        <div className="scorecard">
            <Grid container direction="row" justifyContent="center" alignItems="stretch">
                <Grid item xs={4}>
                    <div className='scorecard_part'>
                        <Grid container direction="column" justifyContent="center" alignItems="stretch" spacing={0.5}> 
                            <Grid item xs={6}> 
                                <Grid container direction="row">
                                    {/* <Grid item xs={2}>
                                    </Grid> */}
                                    <Grid item xs={9}>
                                        Tamim Iqbal
                                    </Grid>
                                    <Grid item xs={3}>
                                        20(21)
                                    </Grid>
                                </Grid>
                            </Grid>
                            <Grid item xs={6}> 
                                <Grid container direction="row">
                                    {/* <Grid item xs={2}>
                                    </Grid> */}
                                    <Grid item xs={9}>
                                        Mushfiqur Rahim
                                    </Grid>
                                    <Grid item xs={3}>
                                        20(21)
                                    </Grid>
                                </Grid>
                            </Grid>
                        </Grid>
                    </div>
                </Grid>
                <Grid item xs={4}>
                    <div className='scorecard_part2'>
                        <div>
                            <table width="100%">
                                <tr>
                                    <td colSpan={1}>IND BAN</td><td colSpan={12}>222-10</td>(P1)<td colSpan={1}>0.4</td>
                                </tr>
                                <tr>
                                    <td colSpan={20} align="center">TARGET 203</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </Grid>
                <Grid item xs={4}>
                <div className='scorecard_part'>
                        <Grid container direction="column" justifyContent="center" alignItems="stretch" spacing={0.5}> 
                            <Grid item xs={6}> 
                                <Grid container direction="row">
                                    <Grid xs={8}>
                                        Bumrah
                                    </Grid>
                                    <Grid xs={4}>
                                        6~1(5.4)
                                    </Grid>
                                </Grid>
                            </Grid>
                            <Grid item xs={6}> 
                                <Grid container direction="row">
                                    {/* <Grid item xs={2}>
                                    </Grid> */}
                                    {/* <Grid item xs={9}> */}
                                        2  0  2  W  1  6
                                    {/* </Grid> */}
                                </Grid>
                            </Grid>
                        </Grid>
                    </div>
                </Grid>
            </Grid>
        </div>
      );
}