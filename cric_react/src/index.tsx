import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import reportWebVitals from './reportWebVitals';
import Video from './LiveStream/Video/Video';
import LiveStream from './LiveStream/LiveStream';
import HomePage from './HomePage/Homepage';
import MatchHomePage from './HomePage/MatchHomePage';
import { BrowserRouter as Router, Link, Route, Routes } from 'react-router-dom';
import Scorecard from './LiveStream/Scorecard/Scorecard';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <Router>
      {/* <div>
    
      <Link to="/">HomePage</Link>
      <Link to="/match">Scorecard</Link>
      </div> */}
        <Routes>
          <Route path='/' element={<HomePage/>}/>
          <Route path='/match/:matchId' element={<MatchHomePage/>}/>
          <Route path='/liveStream/:matchId' element={<LiveStream/>}/>
        </Routes>
      </Router>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
