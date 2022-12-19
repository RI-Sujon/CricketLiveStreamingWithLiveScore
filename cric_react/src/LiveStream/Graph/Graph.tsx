import * as React from 'react';
import ReactApexChart from "react-apexcharts"
import Chart from 'react-apexcharts'

export default function Graph(props: any) {
    
  const [overTracking, setOverTracking] = React.useState({
    over: [] as any,
    over2: [] as any,
    totalRun: [] as any,
    runRate: [] as any,
    wicket: [] as any, 
    wicket2: [] as any, 
    runInOver: [] as any,
  });

  React.useEffect(()=>{
    var over = [] as any;
    var over2 = [] as any;
    var totalRun = [] as any;
    var wicket = [] as any;
    var wicket2 = [] as any;
    var runRate = [] as any;
    var runInOver = [] as any;

    console.log("7777777777:" + props.matchData.firstInningsOverTracking.length);
    
    over[0]=0;
    totalRun[0]=0;
    wicket[0]=0;
    runRate[0]=0;

    // for(var i=0; i< props.matchData.overs; i++){
    //   over[i+1]=i+1;
    // }

    for(var i=0; i<props.matchData.firstInningsOverTracking.length; i++){
      over[i+1] = i+1 ;
      totalRun[i+1] = props.matchData.firstInningsOverTracking[i].totalRun;
      wicket[i+1] = props.matchData.firstInningsOverTracking[i].wicket;

      if(props.matchData.firstInningsOverTracking[i].overNo!==0)
        runRate[i+1] = Number(props.matchData.firstInningsOverTracking[i].totalRun/props.matchData.firstInningsOverTracking[i].overNo).toFixed(2);
      else
        runRate[i+1] = Number(0).toFixed(2);
    }

    for(var i=0; i<props.matchData.firstInningsOverTracking.length; i++){
      over2[i] = props.matchData.firstInningsOverTracking[i].overNo;
      wicket2[i] = props.matchData.firstInningsOverTracking[i].wicket;

      if(i>0)
        runInOver[i] = props.matchData.firstInningsOverTracking[i].totalRun-props.matchData.firstInningsOverTracking[i-1].totalRun; 
      else
        runInOver[i] = props.matchData.firstInningsOverTracking[i].totalRun;
      
    }
    setOverTracking({...overTracking, over: over, over2: over2, totalRun: totalRun, wicket: wicket, wicket2: wicket2, runInOver: runInOver, runRate: runRate});
  },[props.matchData]);


    const series = [{
      name: "Desktops",
      data: overTracking.totalRun
    }];
    const series2 = [{
      name: "Desktops",
      data: overTracking.runInOver
    }];
    const series3 = [{
      name: "Desktops",
      data: overTracking.runRate
    }];
    const option = {
      chart: {
        id: 'apexchart-example',
        height: 350,
        // type: 'line',
        zoom: {
          enabled: false
        }
      },
      grid: {
        row: {
          colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
          opacity: 0.5
        },
      },
      xaxis: {
        categories: overTracking.over,
      }
    };

    const option2 = {
      chart: {
        id: 'apexchart-example',
        height: 350,
        // type: 'line',
        zoom: {
          enabled: false
        }
      },
      grid: {
        row: {
          colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
          opacity: 0.5
        },
      },
      xaxis: {
        categories: overTracking.over2,
      }
    };

    const yaxis = {
      labels: {
        formatter: function(val: any) {
          return val.toFixed(2);
        }
      }
    };

    return <div style={{padding: 100}}>
          
          <div style={{backgroundColor: 'white', padding: 10}}>
            Run Comparison Graph
          <ReactApexChart series={series} options={option} type="line" height={350} />
          </div>
          <br />
          <div style={{backgroundColor: 'white', padding: 10}}>
          Run Per Over Graph
          <ReactApexChart series={series2} options={option2} type="bar" height={350} />
          </div>
          <br />
          <div style={{backgroundColor: 'white', padding: 10}}>
          Run Rate Comparison Graph
          <ReactApexChart series={series3} options={option} type="line" yaxis={yaxis} height={350} />
          </div>
    </div>
}