import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class CrimeChart extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data1: [],
      data2: [],
      data3: [],
      data4: [],
      data5: [],
      data6: [],
      data7: [],
      data8: [],
    };
  }

  async componentDidMount() {
    try {
      let chartData1 = [];
      let chartData2 = [];
      let chartData3 = [];
      let chartData4 = [];
      let chartData5 = [];
      let chartData6 = [];
      let chartData7 = [];
      let chartData8 = [];

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-twitter-month`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData1.push({
            x: new Date(obj["year"], obj["month"] - 1),
            y: obj["value"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-mastodon-month`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        responseData.forEach((obj) => {
          if (
            obj["year"] === 2022 ||
            (obj["year"] === 2023 && obj["month"] !== 12)
          ) {
            chartData2.push({
              x: new Date(obj["year"], obj["month"] - 1),
              y: obj["value"],
            });
          }
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-twitter-day`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData3.push({
            x: obj["day"],
            y: obj["value"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-mastodon-day`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData4.push({
            x: obj["day"],
            y: obj["value"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-twitter-hour`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData5.push({
            x: obj["hour"],
            y: obj["value"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-mastodon-hour`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData6.push({
            x: obj["hour"],
            y: obj["value"],
          });
        });
      });
      const labels = {
        Sunday: 0,
        Monday: 1,
        Tuesday: 2,
        Wednesday: 3,
        Thursday: 4,
        Friday: 5,
        Saturday: 6,
      };

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-twitter-dow`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData7.push({
            x: labels[obj["dow"]],
            y: obj["value"],
            label: obj["dow"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-mastodon-dow`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          chartData8.push({
            x: labels[obj["dow"]],
            y: obj["value"],
            label: obj["dow"],
          });
        });
      });

      this.setState({
        data1: chartData1,
        data2: chartData2,
        data3: chartData3.sort((a, b) => b.x - a.x),
        data4: chartData4.sort((a, b) => b.x - a.x),
        data5: chartData5,
        data6: chartData6,
        data7: chartData7.sort((a, b) => b.x - a.x),
        data8: chartData8.sort((a, b) => b.x - a.x),
      });
    } catch (error) {
      console.log(error);
    }
  }
  render() {
    const options1 = {
      animationEnabled: true,
      title: {
        text: "Total Crime Mentioned in Each Month",
      },
      axisX: {
        valueFormatString: "MMM YYYY",
      },

      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      axisY2: {
        title: "Toots",
        titleFontColor: "#B13B3D",
        lineColor: "#B13B3D",
        labelFontColor: "#B13B3D",
        tickColor: "#B13B3D",
        includeZero: false,
      },
      data: [
        {
          yValueFormatString: "#,###",
          xValueFormatString: "MMMM YYYY",
          type: "spline",
          dataPoints: this.state.data1,
        },
        {
          yValueFormatString: "#,###",
          axisYType: "secondary",
          xValueFormatString: "MMMM YYYY",
          type: "spline",
          dataPoints: this.state.data2,
        },
      ],
    };

    const options2 = {
      animationEnabled: true,
      title: {
        text: "Total Crime Mentioned in Each Day",
      },
      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      axisY2: {
        title: "Toots",
        titleFontColor: "#B13B3D",
        lineColor: "#B13B3D",
        labelFontColor: "#B13B3D",
        tickColor: "#B13B3D",
        includeZero: false,
      },
      data: [
        {
          yValueFormatString: "#,###",
          type: "spline",
          dataPoints: this.state.data3,
        },
        {
          yValueFormatString: "#,###",
          axisYType: "secondary",
          type: "spline",
          dataPoints: this.state.data4,
        },
      ],
    };

    const options3 = {
      animationEnabled: true,
      title: {
        text: "Total Crime Mentioned in Each Hour",
      },
      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      axisY2: {
        title: "Toots",
        titleFontColor: "#B13B3D",
        lineColor: "#B13B3D",
        labelFontColor: "#B13B3D",
        tickColor: "#B13B3D",
        includeZero: false,
      },
      data: [
        {
          yValueFormatString: "#,###",
          type: "spline",
          dataPoints: this.state.data5,
        },
        {
          yValueFormatString: "#,###",
          axisYType: "secondary",
          type: "spline",
          dataPoints: this.state.data6,
        },
      ],
    };

    const options4 = {
      animationEnabled: true,
      title: {
        text: "Total Crime Mentioned in Day of Week",
      },
      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      axisY2: {
        title: "Toots",
        titleFontColor: "#B13B3D",
        lineColor: "#B13B3D",
        labelFontColor: "#B13B3D",
        tickColor: "#B13B3D",
        includeZero: false,
      },
      data: [
        {
          yValueFormatString: "#,###",
          type: "spline",
          dataPoints: this.state.data7,
        },
        {
          yValueFormatString: "#,###",
          axisYType: "secondary",
          type: "spline",
          dataPoints: this.state.data8,
        },
      ],
    };
    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <h1>Crime Analysis</h1>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options3} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options4} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options2} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options1} />
        </div>
      </div>
    );
  }
}

export default CrimeChart;
