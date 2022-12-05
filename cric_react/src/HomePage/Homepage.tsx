import * as React from 'react';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Divider from '@mui/material/Divider';
import InboxIcon from '@mui/icons-material/Inbox';
import DraftsIcon from '@mui/icons-material/Drafts';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

export default function HomePage() {

    const [matchList, setMatchList] = React.useState<any>({});
    const [flag, setFlag] = React.useState(true);
    let navigate = useNavigate();

    // React.useEffect(() => {
    //     // console.log(matchList.matchList[2]);
    // });

    React.useEffect(() => {
        if(flag){
            httpHandling();
        }
    });

    const httpHandling = () => {
        console.log("Kocchuu");
        axios.get('http://localhost:5001/match/getMatchList')
        .then(response => {
            console.log("Kocchuu2:" + response);
            setMatchList(response.data);
            setFlag(false);
        }).catch(error => {
            console.log(error);
        });
    }

    const renderTD = () => {
        let item = [];
        if(flag===false){
            console.log( "ddd"+ matchList.matchList);
        console.log("2222222222+:" + matchList.matchList.length);
        console.log("22222222333:" + matchList.matchList[0].matchName);
        for (let i = 0; i < matchList.matchList.length; i++) {
          item.push(<ListItem disablePadding key={i} onClick={() => {
            navigate("/match/"+matchList.matchList[i].matchId);
          }}><ListItemButton>{matchList.matchList[i].matchName}</ListItemButton></ListItem>);
          
          if(i!=matchList.matchList.length-1)
          item.push(<Divider />);
        }
        }
        return item;
      };

    return (
        <div style={{alignItems: 'center', width: '100%'}}>

            {/* <List>
                {renderTD()}
            </List> */}
            
            <Box sx={{ width: '100%', maxWidth: 360, bgcolor: 'background.paper' }}>
      <nav aria-label="main mailbox folders">
        <List>
        {renderTD()}
        </List>
      </nav>
      <Divider />
      
    </Box>
        </div>
      );
}