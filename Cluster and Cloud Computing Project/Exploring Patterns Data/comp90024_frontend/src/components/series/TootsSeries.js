import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class TootsSeries extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data1: [],
      data2: [],
      data3: [],
    };
  }

  async componentDidMount() {
    try {
      let chartData1 = [];
      let chartData2 = [];
      let chartData3 = [];

      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-dow`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData1 = responseData;
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-hour`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData2 = responseData;
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-weekend`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData3 = responseData;
      });

      this.setState({
        data1: chartData1,
        data2: chartData2,
        data3: chartData3,
      });
    } catch (error) {
      console.log(error);
    }
  }
  render() {
    const options1 = {
      title: {
        text: "Toots in Day of Week",
      },
      exportEnabled: true,
      animationEnabled: true,
      data: [
        {
          type: "bar",
          legendText: "{label}",
          toolTipContent: "{label}: {y}",
          indexLabel: "{label} - #{y}",
          dataPoints: this.state.data1,
        },
      ],
    };

    const options2 = {
      title: {
        text: "Toots in Day",
      },
      exportEnabled: true,
      animationEnabled: true,
      data: [
        {
          type: "spline",
          markerSize: 15,
          toolTipContent: "{x}: {y}",
          dataPoints: this.state.data2,
        },
      ],
    };
    const options3 = {
      title: {
        text: "Toots on Weekend",
      },
      exportEnabled: true,
      animationEnabled: true,
      data: [
        {
          type: "pie",
          showInLegend: true,
          legendText: "{label}",
          toolTipContent: "{label}: {y}",
          indexLabel: "{label} - #percent%",
          dataPoints: this.state.data3,
        },
      ],
    };

    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <h1>Overall Toots Time Analysis</h1>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options1} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options2} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options3} />
        </div>
      </div>
    );
  }
}

export default TootsSeries;
