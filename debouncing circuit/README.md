# Switch Debouncing Circuit

A parameterized, synchronous FSM-based debouncer for mechanical switch/button inputs, written in Verilog.

## Overview

Mechanical switches produce electrical "bounce" — rapid, spurious transitions — for a short period after being toggled. This module filters that noise using a **Moore finite state machine** combined with a **tick counter**, producing a clean, stable output that only changes after the input has held steady for a configurable number of clock cycles.

## Files

| File | Description |
|---|---|
| `debouncing_circuit.v` | The debouncer RTL (synthesizable) |
| `debouncing_circuit_tb.v` | Self-checking testbench with randomized bounce injection |

## Module: `debouncing_circuit`

### Parameters

| Parameter | Default | Description |
|---|---|---|
| `TICK_CYCLE` | 5 | Number of clock cycles the input must remain stable before a transition is accepted |

### Ports

| Port | Direction | Width | Description |
|---|---|---|---|
| `original_sw` | input | 1 | Raw, potentially bouncy switch input |
| `clk` | input | 1 | System clock |
| `debouncing_db` | output | 1 | Clean, debounced output |

## How It Works

### Tick generator

A free-running counter (`count`) counts up to `TICK_CYCLE - 1` and wraps around, pulsing `m_tick` for one clock cycle each time it wraps. `COUNT_WIDTH` is sized automatically with `$clog2(TICK_CYCLE)`. This tick acts as the FSM's "stability timer" — the FSM only advances toward accepting a new value once a full `TICK_CYCLE` window has elapsed.

### FSM states

The FSM has 8 states encoded as a 3-bit register:

```
ZERO -> WAIT1_1 -> WAIT1_2 -> WAIT1_3 -> ONE -> WAIT0_1 -> WAIT0_2 -> WAIT0_3 -> ZERO ...
```

- **`ZERO`** — Output is low. On `original_sw = 1`, the FSM starts moving toward `ONE` through the `WAIT1_x` chain.
- **`WAIT1_1` → `WAIT1_3`** — Three consecutive `m_tick` pulses (i.e., `3 × TICK_CYCLE` clock cycles) with the switch held high are required to confirm the transition. If `original_sw` drops back to 0 at any point in this chain, the FSM immediately resets to `ZERO` (bounce rejected).
- **`ONE`** — Output is high. Symmetric behavior on the way back down through `WAIT0_1` → `WAIT0_3`.
- **`WAIT0_1` → `WAIT0_3`** — Same debounce confirmation logic in reverse; reverts immediately to `ONE` if the switch bounces back high.
- **`default`** — Any illegal/unreached state falls back to `ZERO` (safety net).

Effectively, the total debounce delay is **`3 × TICK_CYCLE` clock cycles** of continuous, stable input before the output responds.

### Output logic

```verilog
debouncing_db = (current_state == ONE) ||
                (current_state == WAIT0_1) ||
                (current_state == WAIT0_2) ||
                (current_state == WAIT0_3);
```

The output is high in `ONE` and throughout the `WAIT0_x` states, since the debounced value is still logically "1" while waiting to confirm the fall — it only drops once the FSM fully commits to `ZERO`.

## Testbench: `debouncing_circuit_tb`

- Instantiates the DUT with `TICK_CYCLE = 5`.
- Generates a clock with a 20 ns period (`#10` half-period toggle).
- **Test 1 (0 → 1):** After an initial settle time, drives `sw` with 20 random bounce transitions (`$random % 2`, 1 ns apart), then holds `sw = 1` and waits `400 ns` before checking that `debouncing_db == 1`.
- **Test 2 (1 → 0):** Repeats the same randomized-bounce procedure, then holds `sw = 0` and checks that `debouncing_db == 0`.
- Reports `TEST PASSED` / `ERROR ... TEST FAILED` via `$display` for each direction.

## Running the Simulation

Using QuestaSim/ModelSim:

```bash
vlog debouncing_circuit.v debouncing_circuit_tb.v
vsim -c debouncing_circuit_tb -do "run -all; quit"
```

Using Icarus Verilog:

```bash
iverilog -o sim.out debouncing_circuit.v debouncing_circuit_tb.v
vvp sim.out
```

Expected console output:

```
TEST PASSED - (0 to 1)
TEST PASSED - (1 to 0)
```

## Notes / Possible Improvements

- `original_sw` is sampled directly by the FSM with no synchronizer flip-flops — if this signal comes from an asynchronous, off-chip source, consider adding a 2-flop synchronizer ahead of this module to avoid metastability.
- `m_tick` is registered (one-cycle delayed relative to `count` reaching its terminal value), which is accounted for correctly by the FSM but worth noting if you modify the timing.
- `TICK_CYCLE` should be set based on your actual clock frequency and expected mechanical bounce duration (typically 1–20 ms of real bounce time).
