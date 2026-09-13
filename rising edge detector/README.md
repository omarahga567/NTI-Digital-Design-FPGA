# Rising Edge Detector — Moore & Mealy FSM

## Overview

This project implements a **Rising Edge Detector** using two different finite-state machine architectures:

* **Moore FSM**
* **Mealy FSM**

The detector generates a single-cycle `tick` pulse whenever the input signal `In` changes from `0` to `1`.

The project demonstrates the difference between Moore and Mealy state machines and their effect on output generation.

---

## Project Structure

```text
Rising-Edge-Detector/
│
├── moore/
│   ├── rising_edge_detector.v
│   └── rising_edge_detector_tb.v
│
├── mealy/
│   ├── rising_edge_detector.v
│   └── rising_edge_detector_tb.v
│
└── README.md
```

---

## 1. Moore FSM

### Description

The Moore implementation uses **three states**:

| State  | Description          |
| ------ | -------------------- |
| `ZERO` | Input is low         |
| `EDGE` | Rising edge detected |
| `ONE`  | Input remains high   |

The output `tick` depends only on the current state.

```text
ZERO → EDGE → ONE
  ↑             │
  └─────── 0 ───┘
```

The `EDGE` state produces the `tick` pulse.

### Moore Output

```verilog
assign tick = (current_state == EDGE);
```

Therefore:

* `In = 0` → `tick = 0`
* Rising edge → enter `EDGE`
* `EDGE` → `tick = 1`
* Next clock → `ONE`, `tick = 0`

### Moore Waveform


![alt text](<moore-machine waveform.png>)

---

## 2. Mealy FSM

### Description

The Mealy implementation uses only **two states**:

| State  | Description   |
| ------ | ------------- |
| `ZERO` | Input is low  |
| `ONE`  | Input is high |

The output depends on both the **current state** and the **input**.

```text
       In=1
ZERO ───────→ ONE
 ↑            │
 └──── In=0 ─┘
```

### Mealy Output

The rising-edge condition is:

```verilog
assign tick = (current_state == ZERO) && In;
```

Therefore, when the FSM is in `ZERO` and `In` becomes `1`, `tick` becomes `1`.

After the next clock edge, the state changes to `ONE`, causing `tick` to return to `0`.

### Mealy Waveform

![alt text](<mealy-machine waveform.png>)

---

## Moore vs Mealy

| Feature           | Moore                 | Mealy                 |
| ----------------- | --------------------- | --------------------- |
| Number of states  | 3                     | 2                     |
| Output depends on | State                 | State + Input         |
| `tick` generation | `EDGE` state          | `ZERO` + `In`         |
| Output response   | State-dependent       | Immediate with input  |
| Design complexity | Slightly higher       | Lower                 |
| Output timing     | Clock/state dependent | Can change with input |

---

## Verification

Both implementations include a **self-checking testbench**.

The testbench verifies:

* Reset operation
* Input remains `0`
* Rising-edge detection
* Input remains `1`
* Falling transition
* Detection of another rising edge
* No extra pulses while `In` remains high

The testbench reports `TEST PASSED` or `TEST FAILED` and counts errors.

---

## Simulation

The design can be simulated using **QuestaSim / ModelSim**.

Example:

```text
vlog rising_edge_detector.v rising_edge_detector_tb.v
vsim rising_edge_detector_tb
run -all
```

---

## Expected Behavior

For an input sequence:

```text
In:    0  0  1  1  1  0  0  1  1
Tick:  0  0  1  0  0  0  0  1  0
```

Each `0 → 1` transition generates exactly one `tick` pulse.

---

## Conclusion

This project demonstrates two common FSM design approaches for the same functionality.

The **Moore implementation** uses an additional `EDGE` state to generate the output, while the **Mealy implementation** reduces the number of states by generating the output directly from the current state and input.

The project provides a practical comparison between Moore and Mealy FSM architectures in RTL design.

---

## Tools

* Verilog HDL
* QuestaSim / ModelSim
* FSM Design
* RTL Design
* Self-Checking Testbench
