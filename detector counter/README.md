# Digital Edge Detector, Counter & 7-Segment Display

## 📌 Project Overview

This project implements a synchronous **digital edge detection and counting system** using Verilog HDL.

The system detects **rising and falling edges** of a digital input signal, counts each type of edge, calculates the total number of detected transitions, and displays the results on **7-segment displays**.

The design is implemented using a modular RTL architecture consisting of:

* Clock Divider
* FSM-based Edge Detector
* Rising/Falling Edge Counter
* 7-Segment Decoder
* Top-Level Integration Module

The project was designed and verified using **Verilog HDL** and **QuestaSim**, with the final design intended for **FPGA implementation**.

---

## 🎯 Objectives

The main objectives of this project are:

1. Detect rising edges of a digital input signal.
2. Detect falling edges of a digital input signal.
3. Generate a single-clock pulse for each detected edge.
4. Prevent repeated edge detection when the input remains HIGH or LOW.
5. Count rising and falling edges independently.
6. Maintain a total edge counter.
7. Display the detected edge counts using 7-segment displays.
8. Verify the design using self-checking Verilog testbenches.
9. Implement and test the design on an FPGA.

---

## 🏗️ System Architecture

```text
                    ┌─────────────────┐
                    │   Input Clock   │
                    │      clk        │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Clock Divider │
                    │     CLK_DIV     │
                    └────────┬────────┘
                             │
                         clk_out
                             │
                             ▼
                    ┌─────────────────┐
                    │  Edge Detector  │
                    │      FSM        │
                    └────────┬────────┘
                             │
                 ┌───────────┼───────────┐
                 │           │           │
                 ▼           ▼           ▼
            Rising Tick  Falling Tick  Edge Tick
                 │           │
                 └─────┬─────┘
                       │
                       ▼
                ┌───────────────┐
                │ Edge Counter  │
                └───────┬───────┘
                        │
             ┌──────────┼──────────┐
             │          │          │
             ▼          ▼          ▼
        Rise Count  Fall Count  Total Count
             │          │          │
             └──────────┼──────────┘
                        │
                        ▼
                ┌───────────────┐
                │ 7-Segment     │
                │   Decoder     │
                └───────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
        Rise          Fall          Total
       Display       Display       Display
```

---

# 📂 Project Structure

```text
Digital-Edge-Detector/
│
├── RTL/
│   ├── top.v
│   ├── CLK_DIV.v
│   ├── edge_detector.v
│   ├── edge_counter.v
│   └── decoder_7seg.v
│
├── TESTBENCH/
│   ├── top_tb.v
│   ├── edge_counter_tb.v
│   └── decoder_7seg_tb.v
│
├── SIM/
│   ├── waveform/
│   └── screenshots/
│
├── FPGA/
│   ├── constraints/
│   └── screenshots/
│
└── README.md
```

> The exact folder structure can be modified depending on the FPGA tool/project organization.

---

# 🔧 Design Modules

## 1. Clock Divider

### Module

```verilog
CLK_DIV
```

### Purpose

The clock divider generates a slower clock from the FPGA/system clock.

This makes the system easier to observe on physical hardware and provides a suitable clock for the edge detection and counting logic.

### Interface

```text
clk       → Input system clock
reset     → Reset
clk_out   → Divided clock
```

---

# 2. Edge Detector

### Module

```verilog
edge_detector
```

The edge detector is implemented as a **Finite State Machine (FSM)**.

### FSM States

```text
IDLE
RISE_TICK
HIGH
FALL_TICK
```


### Edge Detection Behavior

For an input that remains HIGH for a long period:

```text
in:
       ____████████████████████____

rising_tick:
       _____█_____________________

falling_tick:
       _____________________█_____

edge_tick:
       _____█_______________█_____
```

A rising edge generates **one pulse only**, even if the input remains HIGH for many clock cycles.

Similarly, a falling edge generates one pulse only.

---

# 3. Edge Counter

### Module

```verilog
edge_counter
```

The counter receives the edge detector pulses and maintains three counters:

```text
rise_count
fall_count
total_count
```

### Operation

When:

```verilog
rising_tick = 1
```

the module increments:

```text
rise_count
total_count
```

When:

```verilog
falling_tick = 1
```

the module increments:

```text
fall_count
total_count
```

### Example

For:

```text
Rising
Falling
Rising
Falling
Rising
Falling
```

the counters become:

```text
Rise Count  = 3
Fall Count  = 3
Total Count = 6
```

The counters are 4-bit counters and therefore support values:

```text
0 → 15
```

After `15`, they wrap around to `0`.

---

# 4. 7-Segment Decoder

### Module

```verilog
decoder_7seg
```

The decoder converts the 4-bit counter values into 7-segment display patterns.

Three displays are used for the count values:

```text
R → Rising Edge indicator
R_C → Rising Edge count

F → Falling Edge indicator
F_C → Falling Edge count

T → Total Edge indicator
T_C → Total Edge count
```

### Normal Operation

The displays show:

```text
R  [Rise Count]
F  [Fall Count]
T  [Total Count]
```

For example:

```text
R  3
F  2
T  5
```

means:

```text
3 rising edges
2 falling edges
5 total edges
```

---

# 🔄 Reset Behavior

When:

```verilog
reset = 1
```

the counters are cleared:

```text
rise_count  = 0
fall_count  = 0
total_count = 0
```

The 7-segment decoder also displays the reset indication defined in the design.

---

# 🧪 Verification

The project contains separate testbenches for individual modules and a self-checking testbench for the complete system.

## Testbench 1 — Edge Counter

The counter testbench verifies:

* Reset behavior
* Rising edge counting
* Falling edge counting
* Total edge counting
* Correct interaction between the counters

Expected example:

```text
Rise Count  = 2
Fall Count  = 2
Total Count = 4

TEST PASSED
```

---

## Testbench 2 — 7-Segment Decoder

The decoder testbench verifies:

* Reset display
* Decimal values `0–9`
* Hexadecimal values `A–F`
* Rising count display
* Falling count display
* Total count display

All 16 possible 4-bit input values are tested.

---

## Testbench 3 — Top-Level Self-Checking Testbench

The top-level testbench verifies the complete design:

```text
CLK_DIV
   ↓
Edge Detector
   ↓
Edge Counter
   ↓
7-Segment Decoder
```

The testbench automatically compares the expected counter values with the DUT values.

### Tests Include

* Reset
* Single rising edge
* Single falling edge
* Multiple rising/falling edges
* Long HIGH input
* Long LOW input
* Prevention of repeated edge detection

The testbench reports:

```text
PASS
```

or:

```text
ERROR
```

automatically.

---

# 📊 QuestaSim Simulation

The design was simulated using **QuestaSim**.

## Compilation

The required RTL files are compiled first:

```text
CLK_DIV.v
edge_detector.v
edge_counter.v
decoder_7seg.v
top.v
```

Then the required testbench is compiled.

Example:

```text
vlog CLK_DIV.v
vlog edge_detector.v
vlog edge_counter.v
vlog decoder_7seg.v
vlog top.v
vlog top_tb.v
```

Simulation can then be started using:

```text
vsim work.top_tb
```

and:

```text
run -all
```

---


# 🖥️ FPGA Implementation

The design is intended to be implemented on an FPGA board.

The FPGA implementation connects:

```text
FPGA Clock
    │
    ▼
CLK_DIV
    │
    ▼
Edge Detection
    │
    ▼
Counters
    │
    ▼
7-Segment Displays
```

The input signal can be connected to an FPGA switch, button, or external digital signal depending on the target board.

---

# 📌 FPGA Pin Assignments

The following table can be completed according to the target FPGA board:

| Signal     | FPGA Pin | Description          |
| ---------- | -------- | -------------------- |
| `clk`      | TBD      | FPGA system clock    |
| `reset`    | TBD      | Reset input          |
| `in`       | TBD      | Digital input signal |
| `R[6:0]`   | TBD      | Rising indicator     |
| `R_C[6:0]` | TBD      | Rising count         |
| `F[6:0]`   | TBD      | Falling indicator    |
| `F_C[6:0]` | TBD      | Falling count        |
| `T[6:0]`   | TBD      | Total indicator      |
| `T_C[6:0]` | TBD      | Total count          |

---

# 🔬 FPGA Hardware Results

## FPGA Simulation / Implementation

 <img width="937" height="843" alt="Screenshot 2026-09-10 223955" src="https://github.com/user-attachments/assets/5b21e083-e4d0-455d-a4ac-d0b9021f9aef" />
 <img width="1122" height="880" alt="Screenshot 2026-09-10 224110" src="https://github.com/user-attachments/assets/0915c785-e230-4c09-a865-fed9996671d3" />
 <img width="937" height="843" alt="Screenshot 2026-09-10 223955" src="https://github.com/user-attachments/assets/e52399f8-02d0-4bf0-bffb-8da0a7fa18f4" />



```






```

### Expected Hardware Behavior

When the input changes:

```text
LOW → HIGH
```

the rising counter increases by one.

When the input changes:

```text
HIGH → LOW
```

the falling counter increases by one.

The total counter increases for both transitions.

Example:

```text
Input transitions:

LOW → HIGH
HIGH → LOW
LOW → HIGH
HIGH → LOW

Displays:

R  2
F  2
T  4
```

---

# ⚙️ Tools & Technologies

| Tool / Technology | Usage                      |
| ----------------- | -------------------------- |
| Verilog HDL       | RTL Design                 |
| FSM               | Edge Detection             |
| QuestaSim         | Functional Simulation      |
| FPGA Toolchain    | Synthesis & Implementation |
| FPGA Board        | Hardware Testing           |
| 7-Segment Display | Output Visualization       |

---

# 🧠 Key Concepts Demonstrated

This project demonstrates practical knowledge of:

* RTL design
* Verilog HDL
* Synchronous digital design
* Finite State Machines
* Rising-edge detection
* Falling-edge detection
* Pulse generation
* Clock division
* Counters
* 7-segment decoding
* Modular hardware design
* Testbench development
* Self-checking verification
* Simulation and waveform analysis
* FPGA implementation

---

# 📋 Verification Summary

| Test                   | Status |
| ---------------------- | ------ |
| Reset                  | ⬜      |
| Rising Edge Detection  | ⬜      |
| Falling Edge Detection | ⬜      |
| Long HIGH Input        | ⬜      |
| Long LOW Input         | ⬜      |
| Rising Counter         | ⬜      |
| Falling Counter        | ⬜      |
| Total Counter          | ⬜      |
| 7-Segment Decoder      | ⬜      |
| Top-Level Integration  | ⬜      |
| FPGA Implementation    | ⬜      |
| FPGA Hardware Test     | ⬜      |

Replace `⬜` with `✅` after completing each test.

---

# 🚀 Future Improvements

Possible improvements include:

* Parameterized counter width
* Parameterized clock divider
* Debouncing for mechanical push buttons
* Support for larger counters
* Multiplexed 7-segment display architecture
* Additional edge statistics
* Configurable input filtering
* SystemVerilog assertions
* UVM-based verification environment
* FPGA timing analysis
* CDC analysis for asynchronous external inputs

---

# 👨‍💻 Author

**Omar Ahmed**

Electronics & Communication Engineering

Interests:

* Digital IC Design
* RTL Design
* Design Verification
* SystemVerilog
* UVM
* FPGA Design

---

# 📄 License

This project is intended for educational and portfolio purposes.

```
```
