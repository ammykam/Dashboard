import ListGroup from "react-bootstrap/ListGroup";
import React from "react";

function MainPage() {
  return (
    <div style={{ padding: "20px" }}>
      <h3>Group Member</h3>
      <ListGroup>
        <ListGroup.Item>1244661 Natakorn Kam</ListGroup.Item>
        <ListGroup.Item>1291944 Janya Kavit Pandya</ListGroup.Item>
        <ListGroup.Item>1080704 Zhiyuan Chen</ListGroup.Item>
        <ListGroup.Item>1129712 Atefeh Zamani</ListGroup.Item>
        <ListGroup.Item>1470232 Nandakishor Sarath</ListGroup.Item>
      </ListGroup>
    </div>
  );
}

export default MainPage;
