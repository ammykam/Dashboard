import { Col, Row } from "react-bootstrap";
import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class CompareSeries extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data1: [],
      data2: [],
      data3: [],
      data4: [],
      data5: [],
      data6: [],
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

      await fetch(`${process.env.REACT_APP_BACKEND}/time-tweet-dow`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData1 = responseData;
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/time-tweet-hour`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData2 = responseData;
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/time-tweet-weekend`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData3 = responseData;
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-dow`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData4 = responseData;
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-hour`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData5 = responseData;
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/time-mastodon-weekend`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        chartData6 = responseData;
      });

      this.setState({
        data1: chartData1,
        data2: chartData2,
        data3: chartData3,
        data4: chartData4,
        data5: chartData5,
        data6: chartData6,
      });
    } catch (error) {
      console.log(error);
    }
  }
  render() {
    const options1 = {
      title: {
        text: "Tweets in Day of Week",
      },
      exportEnabled: true,
      animationEnabled: true,
      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      data: [
        {
          type: "pie",
          legendText: "{label}",
          toolTipContent: "{label}: {y}",
          indexLabel: "{label} : #percent%",
          dataPoints: this.state.data1.map((point) => ({
            ...point,
            color:
              point.label === "Monday"
                ? "#f5f29a"
                : point.label === "Tuesday"
                ? "#f7a1a1"
                : point.label === "Wednesday"
                ? "#8fcc91"
                : point.label === "Thursday"
                ? "#f09622"
                : point.label === "Friday"
                ? "#ADD8E6"
                : point.label === "Saturday"
                ? "#D8BFD8"
                : point.label === "Sunday"
                ? "#f52237"
                : null,
          })),
        },
      ],
    };

    const options2 = {
      title: {
        text: "Tweets compared with Toots in Day",
      },
      exportEnabled: true,
      animationEnabled: true,
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
          type: "spline",
          markerSize: 15,
          toolTipContent: "{x}: {y}",
          dataPoints: this.state.data2,
        },
        {
          type: "spline",
          axisYType: "secondary",
          markerSize: 15,
          toolTipContent: "{x}: {y}",
          dataPoints: this.state.data5,
        },
      ],
    };
    const options3 = {
      title: {
        text: "Tweets on Weekend",
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
    const options5 = {
      title: {
        text: "Toots on Weekend",
      },
      exportEnabled: true,
      animationEnabled: true,

      data: [
        {
          type: "pie",
          showInLegend: true,
          axisYType: "secondary",
          legendText: "{label}",
          toolTipContent: "{label}: {y}",
          indexLabel: "{label} - #percent%",
          dataPoints: this.state.data6,
        },
      ],
    };
    const options4 = {
      title: {
        text: "Toots in Day of Week",
      },
      exportEnabled: true,
      animationEnabled: true,
      axisY: {
        title: "Tweets",
        titleFontColor: "#6D78AD",
        lineColor: "#6D78AD",
        labelFontColor: "#6D78AD",
        tickColor: "#6D78AD",
        includeZero: false,
      },
      data: [
        {
          type: "pie",
          axisYType: "secondary",
          legendText: "{label}",
          toolTipContent: "{label}: {y}",
          indexLabel: "{label} : #percent%",
          dataPoints: this.state.data4.map((point) => ({
            ...point,
            color:
              point.label === "Monday"
                ? "#f5f29a"
                : point.label === "Tuesday"
                ? "#f7a1a1"
                : point.label === "Wednesday"
                ? "#8fcc91"
                : point.label === "Thursday"
                ? "#f09622"
                : point.label === "Friday"
                ? "#ADD8E6"
                : point.label === "Saturday"
                ? "#D8BFD8"
                : point.label === "Sunday"
                ? "#f52237"
                : null,
          })),
        },
      ],
    };

    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <h1>Overall Tweets Time Analysis</h1>
        <div style={{ marginBottom: "20px" }}>
          <Row>
            <Col>
              <CanvasJSChart options={options1} />
            </Col>
            <Col>
              <CanvasJSChart options={options4} />
            </Col>
          </Row>
        </div>
        <div style={{ marginBottom: "20px" }}>
          <CanvasJSChart options={options2} />
        </div>
        <div style={{ marginBottom: "20px" }}>
          <Row>
            <Col>
              <CanvasJSChart options={options3} />
            </Col>
            <Col>
              <CanvasJSChart options={options5} />
            </Col>
          </Row>
        </div>
      </div>
    );
  }
}

export default CompareSeries;
