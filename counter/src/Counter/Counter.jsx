import React from "react"

export const Counter = props =>
  <div>
    <h1>Counter (JSX)</h1>
    Count: {props.count}<br/>
    <button type="button" onClick={props.onInc}>Inc</button>
    <button type="button" onClick={props.onDec}>Dec</button>
  </div>
