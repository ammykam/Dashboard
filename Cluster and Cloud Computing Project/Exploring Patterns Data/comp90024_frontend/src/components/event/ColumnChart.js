import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class ColumnChart extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data1: [],
      data2: [],
      data3: [],
      data4: [],
      data5: [],
    };
  }

  async componentDidMount() {
    try {
      let chartData1 = [];
      let chartData2 = [];
      let chartData3 = [];
      let chartData4 = [];
      let chartData5 = [];

      await fetch(`${process.env.REACT_APP_BACKEND}/australian-open`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData1.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/grand-prix`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData2.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/lgbtq`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData3.push({ label: key, y: value });
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/melbourne-cup`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData4.push({ label: key, y: value });
          });
        });
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/vivid-sydney`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key, value]) => {
            chartData5.push({ label: key, y: value });
          });
        });
      });

      this.setState({
        data1: chartData1,
        data2: chartData2,
        data3: chartData3,
        data4: chartData4,
        data5: chartData5,
      });
    } catch (error) {
      console.log(error);
    }
  }
  render() {
    const options1 = {
      title: {
        text: "Sentiment on Australian Open Event",
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
      title: {
        text: "Sentiment on Grand Prix",
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
          dataPoints: this.state.data2,
        },
      ],
    };
    const options3 = {
      title: {
        text: "Sentiment on Sydney Mardi Gras LGBTQ Event",
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
    const options4 = {
      title: {
        text: "Sentiment on Melbourne Cup",
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
          dataPoints: this.state.data4,
        },
      ],
    };

    const options5 = {
      title: {
        text: "Sentiment on Vivid Sydney",
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
          dataPoints: this.state.data5,
        },
      ],
    };

    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options1} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options2} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options3} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options4} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options5} />
        </div>
      </div>
    );
  }
}

export default ColumnChart;
