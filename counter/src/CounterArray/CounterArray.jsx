import React from "react"
import { Row, Col } from "react-bootstrap"

export const Counter = ({ counters }) =>
  counters.map((c, idx) =>
    <>
      <Row key={idx}>
        <Col md={1}>{idx+1}</Col>
        <Col md={10}>{c}</Col>
      </Row>
      <Row><Col>&nbsp;</Col></Row>
    </>
  )
