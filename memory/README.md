# Memory

A parameterized synchronous memory module with bidirectional data access.

## Features

- Configurable address and data width.
- Synchronous write on the rising edge of `clk`.
- Read operation controlled by `rd`.
- Write operation controlled by `wr`.
- Bidirectional `data` bus using tri-state logic.
- Default address width: 5 bits (32 locations).
- Default data width: 8 bits.

## Operation

- `wr = 1` → stores `data` at `addr`.
- `rd = 1` → outputs the stored data at `addr`.
- `wr = 0` and `rd = 0` → releases the `data` bus.

## Parameters

- `AWIDTH` — Address width.
- `DWIDTH` — Data width.