# Parameterized Register

A simple synchronous register designed in Verilog. The register stores input data on the rising edge of the clock when the `load` signal is high.

## Features

- Parameterized data width.
- Default data width is 8 bits.
- Synchronous, active-high reset.
- Positive-edge triggered clock.
- Load enable for storing input data.
- Holds its previous value when `load` is low.

## Module Interface

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | Clock signal |
| `rst` | Input | Synchronous active-high reset |
| `load` | Input | Enables loading of `data_in` |
| `data_in` | Input | Input data |
| `data_out` | Output | Current stored data |

## Operation

At every rising edge of `clk`:

1. If `rst` is high, the register is cleared to `0`.
2. Otherwise, if `load` is high, `data_in` is stored in the register.
3. If `load` is low, the register keeps its previous value.

### Example

```text
rst = 1  → data_out = 0
load = 1 → data_out = data_in
load = 0 → data_out keeps its previous value