import React from "react"
import { Row, Col } from "react-bootstrap"

export const Counter = ({ one, two }) =>
  <Row>
    <Col md={6}>{one}</Col>
    <Col md={6}>{two}</Col>
  </Row>
