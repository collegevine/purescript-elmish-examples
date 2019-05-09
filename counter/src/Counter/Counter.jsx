import React from "react"

export const Counter = props =>
  <div>
    Count: {props.count}<br/>
    <button type="button" onClick={props.onInc}>Inc</button>
    <button type="button" onClick={props.onDec}>Dec</button>
  </div>
