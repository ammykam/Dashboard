import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.min";

import Col from "react-bootstrap/Col";
import Container from "react-bootstrap/Container";
import Content from "./Content";
import Navbar from "react-bootstrap/Navbar";
import React from "react";
import Row from "react-bootstrap/Row";
import Sidebar from "./SideBar";

function HomePage() {
  return (
    <div>
      <Navbar bg="dark" variant="dark" fixed="top">
        <Navbar.Brand href="/">Group 29 Project</Navbar.Brand>
        <span className="hidden-xs text-muted">
          COMP90024 Cluster and Cloud Computing
        </span>
      </Navbar>
      <Row>
        <Sidebar />

        <Col
          xl={{ span: 8, offset: 2 }}
          lg={{ span: 8, offset: 2 }}
          xs={{ span: 8, offset: 2 }}
        >
          <Container>
            <Content />
          </Container>
        </Col>
      </Row>
    </div>
  );
}

export default HomePage;
