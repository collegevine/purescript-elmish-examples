import React from "react"
import { Row, Col, Button, Alert, Card } from "react-bootstrap"

export const Counter = props =>
  <Row>
    <Col md={3}>
      <Row><Col>Count</Col></Row>
      <Row><Col><h2>{props.count}</h2></Col></Row>
    </Col>
    <Col md={3}>
      <Button onClick={props.onInc} block>Inc</Button>
      <Button onClick={props.onDec} block>Dec</Button>
    </Col>
  </Row>
