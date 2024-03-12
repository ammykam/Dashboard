import { Col, Container, Row } from "react-bootstrap";
import React, { Component } from "react";

import CanvasJSReact from "../../assets/canvasjs.react";
import Select from "react-select";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

class EachLocation extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedOption: "",
      totalSSAName: [],
      totalLGAName: [],
      totalCrime: [],
      totalDomesticViolence: [],
      totalPark: [],
      totalPopulation: [],
      totalSalary: [],
      totalTransportation: [],
      totalSentiment: {},
    };
  }

  async componentDidMount() {
    try {
      let totalSSAName = [];
      let totalLGAName = [];
      let totalCrime = [];
      let totalDomesticViolence = [];
      let totalPark = [];
      let totalPopulation = [];
      let totalSalary = [];
      let totalTransportation = [];
      let totalSentiment = {};

      await fetch(`${process.env.REACT_APP_BACKEND}/crime-no-location`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalSSAName.push({
            LGA: obj["name"],
            SSA: obj["ssa_name"],
          });
          totalLGAName.push({
            value: obj["name"],
            label: obj["name"],
          });
          totalCrime.push({
            LGA: obj["name"],
            crime: obj["total_crime"],
            year: obj["year"],
          });
        });
      });

      await fetch(
        `${process.env.REACT_APP_BACKEND}/domestic-violence-no-location`,
        {
          mode: "cors",
        }
      ).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalDomesticViolence.push({
            LGA: obj["name"],
            violence_percentage: obj["violence_percentage"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/park-no-location`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalPark.push({
            LGA: obj["name"],
            total_park: obj["total_park"],
          });
        });
      });
      await fetch(`${process.env.REACT_APP_BACKEND}/population-no-location`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalPopulation.push({
            LGA: obj["name"],
            all_person: obj["all_person"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/salary-no-location`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalSalary.push({
            LGA: obj["name"],
            income: obj["income"],
          });
        });
      });

      await fetch(
        `${process.env.REACT_APP_BACKEND}/transportation-no-location`,
        {
          mode: "cors",
        }
      ).then(async (response) => {
        const responseData = await response.json();

        responseData.forEach((obj) => {
          totalTransportation.push({
            LGA: obj["name"],
            transportation_number: obj["transportation_number"],
          });
        });
      });

      await fetch(`${process.env.REACT_APP_BACKEND}/location-sentiment`, {
        mode: "cors",
      }).then(async (response) => {
        const responseData = await response.json();
        responseData.forEach((obj) => {
          Object.entries(obj).forEach(([key1, value]) => {
            totalSentiment[key1] = [];
            Object.entries(value).forEach(([key2, value]) => {
              if (key2 !== "total") {
                totalSentiment[key1].push({ label: key2, y: value });
              }
            });
          });
        });
      });

      this.setState({
        totalSSAName: totalSSAName,
        totalLGAName: totalLGAName,
        totalCrime: totalCrime,
        totalDomesticViolence: totalDomesticViolence,
        totalPark: totalPark,
        totalPopulation: totalPopulation,
        totalSalary: totalSalary,
        totalTransportation: totalTransportation,
        totalSentiment: totalSentiment,
      });
    } catch (error) {
      console.log(error);
    }
  }

  handleChange = (selectedOption) => {
    this.setState({ selectedOption: selectedOption["value"] });
  };

  renderChart = () => {
    const selectedSentiment =
      this.state.totalSentiment[this.state.selectedOption] || {};
    const options = {
      title: {
        text: `Sentiment on ${this.state.selectedOption}`,
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
          dataPoints:
            Object.keys(selectedSentiment).length === 0
              ? []
              : selectedSentiment,
        },
      ],
    };

    return <CanvasJSChart options={options} />;
  };

  render() {
    const styleColumn1 = {
      border: "2px solid black",
      padding: 10,
    };

    const styleColumn2 = {
      borderRight: "2px solid black",
      borderLeft: "2px solid black",
      borderTop: "none",
      borderBottom: "2px solid black",
      padding: 10,
    };

    return (
      <div style={{ display: "flex", flexDirection: "column" }}>
        <h1>Each Location Analysis</h1>
        <Select
          options={this.state.totalLGAName}
          onChange={this.handleChange}
          isSearchable={true}
        />
        <div style={{ paddingTop: "20px" }}> </div>

        <Container>
          <Row>
            <Col className="text-center" style={styleColumn1}>
              Crime
            </Col>
            <Col className="text-center" style={styleColumn1}>
              DV %
            </Col>
            <Col className="text-center" style={styleColumn1}>
              Park
            </Col>
            <Col className="text-center" style={styleColumn1}>
              Population
            </Col>
            <Col className="text-center" style={styleColumn1}>
              Salary
            </Col>
            <Col className="text-center" style={styleColumn1}>
              Transportation
            </Col>
          </Row>
          <Row>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalCrime.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalCrime.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["crime"]
                : "0"}
            </Col>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalDomesticViolence.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalDomesticViolence.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["violence_percentage"]
                : "0"}
            </Col>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalPark.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalPark.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["total_park"]
                : "0"}
            </Col>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalPopulation.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalPopulation.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["all_person"]
                : "0"}
            </Col>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalSalary.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalSalary.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["income"]
                : "0"}
            </Col>
            <Col className="text-center" style={styleColumn2}>
              {this.state.totalTransportation.find(
                (item) => item["LGA"] === this.state.selectedOption
              )
                ? this.state.totalTransportation.find(
                    (item) => item["LGA"] === this.state.selectedOption
                  )["transportation_number"]
                : "0"}
            </Col>
          </Row>
        </Container>
        <div style={{ marginTop: "20px" }}>{this.renderChart()}</div>
      </div>
    );
  }
}

export default EachLocation;
