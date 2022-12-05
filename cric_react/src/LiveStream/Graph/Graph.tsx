import ReactApexChart from "react-apexcharts"
import Chart from 'react-apexcharts'

export default function Graph() {
    
    const series = [{
            name: "Desktops",
            data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
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
        //   dataLabels: {
        //     enabled: false
        //   },
        //   stroke: {
        //     curve: 'straight'
        //   },
        //   title: {
        //     text: 'Product Trends by Month',
        //     align: 'left'
        //   },
          grid: {
            row: {
              colors: ['#f3f3f3', 'transparent'], // takes an array which will be repeated on columns
              opacity: 0.5
            },
          },
          xaxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
          }
        };

        // const option = {
        //     chart: {
        //       id: 'apexchart-example'
        //     },
        //     xaxis: {
        //       categories: [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999]
        //     }
        //   };

        return <div>
              <ReactApexChart series={series} options={option} type="line" height={350} />
        </div>
}