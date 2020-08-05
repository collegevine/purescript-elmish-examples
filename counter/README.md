# A counterexample

A set of progressively more complex examples, demonstrating ways to compose
complex UIs out of simpler ones, using an increment / decrement counter as base.

* `Counter.purs` - base example, demonstrating state + two messages
* `TwoCounters.purs` - composing two instances of `Counter.purs` side by side,
  demonstrating composition techniques
* `CounterArray.purs` - composing an array of counters
* `ProgressReport.purs` - extending the base example with a "slow increment"
  button, which demonstrates reporting progress of a background task
* `Frame.purs` and `Main.purs` - not intended to be part of the examples, just a
  way to bring all the above examples together on one screen

## Building and running

* To initialize: `npm install`
* To build: `npm run build`
* To start a dev server with autoreloading changes: `npm start`
