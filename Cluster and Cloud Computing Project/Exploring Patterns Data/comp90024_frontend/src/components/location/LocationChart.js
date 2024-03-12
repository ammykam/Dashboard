import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class LocationChart extends Component {
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

      await fetch(`${process.env.REACT_APP_BACKEND}/location-overall`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData1.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/location-positive`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData2.push({ label: key, y: value });
          });
        });
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/location-neutral`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData3.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/location-negative`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData4.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/location-sentiment`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData5.push({ label: key, y: value["negative"] });
            chartData6.push({ label: key, y: value["neutral"] });
            chartData7.push({ label: key, y: value["positive"] });
            // chartData4.push({ label: key, y: value });
          });
        });
      });

      this.setState({
        data1: chartData1,
        data2: chartData2.sort((a, b) => b.y - a.y).slice(0, 20),
        data3: chartData3.sort((a, b) => b.y - a.y).slice(0, 20),
        data4: chartData4.sort((a, b) => b.y - a.y).slice(0, 20),
        data5: chartData5.sort((a, b) => b.y - a.y).slice(0, 20),
        data6: chartData6.sort((a, b) => b.y - a.y).slice(0, 20),
        data7: chartData7.sort((a, b) => b.y - a.y).slice(0, 20),
      });
    } catch (error) {
      console.log(error);
    }
  }
  render() {
    const options1 = {
      title: {
        text: "Sentiment on Location Overall",
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
          dataPoints: this.state.data1,
        },
      ],
    };

    const options2 = {
      exportEnabled: true,
      animationEnabled: true,
      title: {
        text: "Sentiment on Top 10 most tweets suburbs",
      },
      legend: {
        verticalAlign: "center",
        horizontalAlign: "right",
        reversed: true,
        cursor: "pointer",
        fontSize: 16,
        itemclick: this.toggleDataSeries,
      },
      toolTip: {
        shared: true,
      },
      data: [
        {
          type: "stackedColumn100",
          name: "Positive",
          showInLegend: true,
          color: "#D4AF37",
          dataPoints: this.state.data2,
        },
        {
          type: "stackedColumn100",
          name: "Neutral",
          showInLegend: true,
          color: "#C0C0C0",
          dataPoints: this.state.data3,
        },
        {
          type: "stackedColumn100",
          name: "Negative",
          showInLegend: true,
          color: "#CD7F32",
          dataPoints: this.state.data4,
        },
      ],
    };

    const options3 = {
      exportEnabled: true,
      animationEnabled: true,
      title: {
        text: "Sentiment on Top 10 most tweets LGAs",
      },
      legend: {
        verticalAlign: "center",
        horizontalAlign: "right",
        reversed: true,
        cursor: "pointer",
        fontSize: 16,
        itemclick: this.toggleDataSeries,
      },
      toolTip: {
        shared: true,
      },
      data: [
        {
          type: "stackedColumn100",
          name: "Positive",
          showInLegend: true,
          color: "#D4AF37",
          dataPoints: this.state.data7,
        },
        {
          type: "stackedColumn100",
          name: "Neutral",
          showInLegend: true,
          color: "#C0C0C0",
          dataPoints: this.state.data6,
        },
        {
          type: "stackedColumn100",
          name: "Negative",
          showInLegend: true,
          color: "#CD7F32",
          dataPoints: this.state.data5,
        },
      ],
    };

    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <h1>Overall Location Analysis</h1>
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

export default LocationChart;
