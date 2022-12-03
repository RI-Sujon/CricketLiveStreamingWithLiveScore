import * as React from 'react';
import { Divider, Grid } from '@mui/material';
import Video from './Video/Video';
import Scorecard from './Scorecard/Scorecard';
import { Stack } from '@mui/system';

export default function LiveStream() {
    return (
        <div>
            <Grid container direction="row" justifyContent="center" alignItems="center">
                <Grid item xs={2}>
                </Grid>
                <Grid item xs={8} style={{backgroundColor: "#ffddff"}}>
                    <Stack style={{height: "700px"}}>
                        <div style={{backgroundColor: "#ddffdd", height: "600px"}}>
                            <Video />
                        </div>
                        <div>
                            {/* <Scorecard /> */}
                        </div>
                    </Stack>
                </Grid>
                <Grid item xs={2}>
                </Grid>
            </Grid>
        </div>
      );
}