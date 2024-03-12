import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.min";

import React, { Component } from "react";

import ListGroup from "react-bootstrap/ListGroup";
import Nav from "react-bootstrap/Nav";
import { NavLink } from "react-router-dom";

class Sidebar extends Component {
  render() {
    return (
      <>
        <Nav to="/" className="flex-sm-column" id="sidebar">
          <ListGroup className="nav nav-sidebar flex-sm-column">
            <ListGroup.Item>
              <a
                href="#LocationAnalysis"
                data-bs-toggle="collapse"
                aria-expanded="false"
                className="dropdown-toggle"
              >
                <span>Location Analysis</span>
              </a>
            </ListGroup.Item>
            <ListGroup>
              <ListGroup className="sub-menu collapse" id="LocationAnalysis">
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/location">Map Location Cluster</NavLink>
                </ListGroup.Item>
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/locationChart">Overall Location Chart</NavLink>
                </ListGroup.Item>
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/eachLocation">Each Location Chart</NavLink>
                </ListGroup.Item>
              </ListGroup>
            </ListGroup>
            <ListGroup.Item>
              <a
                href="#EventAnalysis"
                data-bs-toggle="collapse"
                aria-expanded="false"
                className="dropdown-toggle"
              >
                <span>Event Analysis</span>
              </a>
            </ListGroup.Item>
            <ListGroup>
              <ListGroup className="sub-menu collapse" id="EventAnalysis">
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/event">Chart</NavLink>
                </ListGroup.Item>
              </ListGroup>
            </ListGroup>
            <ListGroup.Item>
              <a
                href="#CrimeAnalysis"
                data-bs-toggle="collapse"
                aria-expanded="false"
                className="dropdown-toggle"
              >
                <span>Crime Analysis</span>
              </a>
            </ListGroup.Item>
            <ListGroup>
              <ListGroup className="sub-menu collapse" id="CrimeAnalysis">
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/crimeChart">Crime Chart</NavLink>
                </ListGroup.Item>
              </ListGroup>
            </ListGroup>
            <ListGroup.Item>
              <a
                href="#TimeAnalysis"
                data-bs-toggle="collapse"
                aria-expanded="false"
                className="dropdown-toggle"
              >
                <span>Time Analysis</span>
              </a>
            </ListGroup.Item>
            <ListGroup>
              <ListGroup className="sub-menu collapse" id="TimeAnalysis">
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/tootsSeries">Toots Time Analysis</NavLink>
                </ListGroup.Item>
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/tweetsSeries">Twitter Time Analysis</NavLink>
                </ListGroup.Item>
                <ListGroup.Item>
                  {" "}
                  <NavLink to="/compareSeries">Compare Time Analysis</NavLink>
                </ListGroup.Item>
              </ListGroup>
            </ListGroup>
          </ListGroup>
        </Nav>
      </>
    );
  }
}

export default Sidebar;
