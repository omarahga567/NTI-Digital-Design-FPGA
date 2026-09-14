# Counter

A simple parameterized counter designed in Verilog.

## Features

- Rising-edge triggered clock.
- Synchronous active-high reset.
- Supports loading a value from `cnt_in`.
- Increments the counter when `enab` is high.
- Holds the current value when `load` and `enab` are low.
- Configurable counter width using the `WIDTH` parameter.
- Default width is 5 bits.

## Operation

At every rising edge of `clk`:

1. If `rst` is high, `cnt_out` is cleared to zero.
2. If `load` is high, `cnt_in` is loaded into the counter.
3. Otherwise, if `enab` is high, the counter increments by one.
4. Otherwise, the counter keeps its current value.

## Priority

`rst` → `load` → `enab` → hold

## Parameter

- `WIDTH` — Defines the counter width. Default: `5`.