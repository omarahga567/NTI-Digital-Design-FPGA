# 2-to-1 Multiplexer Design and Verification

## 📌 Overview

This lab implements and verifies a parameterized **2-to-1 Multiplexer (MUX)** using Verilog HDL.

The multiplexer selects one of two input data signals, `in0` or `in1`, based on the value of the selection signal `sel`.

The design uses a parameterized data width, allowing the multiplexer to be easily configured for different input sizes.

A self-checking Verilog testbench is developed to verify the functionality of the multiplexer under different input and selection conditions.

---

## 🎯 Objectives

The main objectives of this lab are:

* Implement a 2-to-1 multiplexer using Verilog HDL.
* Understand the operation of a selection signal.
* Use a parameterized data width.
* Implement combinational logic using continuous assignment.
* Use the conditional operator in Verilog.
* Develop a self-checking testbench.
* Verify both multiplexer selection cases.

---

## 🧩 Multiplexer Interface

| Signal    | Direction |   Width | Description          |
| --------- | --------- | ------: | -------------------- |
| `in0`     | Input     | `WIDTH` | First input data     |
| `in1`     | Input     | `WIDTH` | Second input data    |
| `sel`     | Input     |   1 bit | Selection signal     |
| `mux_out` | Output    | `WIDTH` | Selected output data |

The default value of `WIDTH` is **5 bits**, but it can be modified using the module parameter.

---

## ⚙️ Multiplexer Operation

The multiplexer is implemented using a conditional continuous assignment:

```text
mux_out = sel ? in1 : in0
```

The output behavior is:

| `sel` | `mux_out` |
| ----- | --------- |
| `0`   | `in0`     |
| `1`   | `in1`     |

Therefore:

```text
sel = 0  →  mux_out = in0
sel = 1  →  mux_out = in1
```

The multiplexer is a **combinational circuit**, meaning the output changes according to the current values of the inputs and selection signal.

---

## 🧪 Verification

The testbench `multiplexor_test` is a **self-checking Verilog testbench**.

It instantiates the `multiplexor` module and applies several test cases.

The `expect` task compares the actual `mux_out` value with the expected result.

The testbench uses the case-inequality operator:

```text
!==
```

This allows the testbench to detect mismatches involving Verilog's four-state logic values (`0`, `1`, `X`, and `Z`).

If the actual output does not match the expected output, the testbench reports:

```text
TEST FAILED
```

and terminates the simulation.

If all test cases pass, it reports:

```text
TEST PASSED
```

---

## 🔍 Test Cases

The testbench uses a **5-bit data width**.

### Test Case 1

```text
sel = 0
in0 = 5'h15
in1 = 5'h00
```

Expected:

```text
mux_out = 5'h15
```

Since `sel = 0`, the output should come from `in0`.

---

### Test Case 2

```text
sel = 0
in0 = 5'h0A
in1 = 5'h00
```

Expected:

```text
mux_out = 5'h0A
```

This further verifies selection of `in0`.

---

### Test Case 3

```text
sel = 1
in0 = 5'h00
in1 = 5'h15
```

Expected:

```text
mux_out = 5'h15
```

Since `sel = 1`, the output should come from `in1`.

---

### Test Case 4

```text
sel = 1
in0 = 5'h00
in1 = 5'h0A
```

Expected:

```text
mux_out = 5'h0A
```

This further verifies selection of `in1`.

---

## 📊 Verification Summary

| Test | `sel` |   `in0` |   `in1` | Expected `mux_out` |
| ---- | ----: | ------: | ------: | -----------------: |
| 1    |   `0` | `5'h15` | `5'h00` |            `5'h15` |
| 2    |   `0` | `5'h0A` | `5'h00` |            `5'h0A` |
| 3    |   `1` | `5'h00` | `5'h15` |            `5'h15` |
| 4    |   `1` | `5'h00` | `5'h0A` |            `5'h0A` |

All selection cases are covered:

* `sel = 0` → `in0` selected
* `sel = 1` → `in1` selected

---

## 📂 Files

```text
Multiplexor/
│
├── multiplexor.v
├── multiplexor_test.v
└── README.md
```

### `multiplexor.v`

Contains the RTL implementation of the parameterized 2-to-1 multiplexer.

### `multiplexor_test.v`

Contains the self-checking Verilog testbench used to verify the multiplexer.

### `README.md`

Contains the documentation, operation description, and verification results.

---

## 🛠️ Tools & Technologies

* **HDL:** Verilog
* **Design:** RTL
* **Verification:** Verilog Testbench
* **Simulation:** QuestaSim / ModelSim
* **Training:** NTI Digital Design Using FPGA

---

## 📚 Concepts Practiced

This lab provides practical experience with:

* Multiplexer design
* Combinational logic
* Parameterized Verilog modules
* Continuous assignments
* Conditional (`?:`) operator
* Selection signals
* Self-checking testbenches
* Verilog tasks
* Case inequality (`!==`)
* RTL simulation

---

## ✅ Verification Result

The multiplexer successfully passes all four test cases.

The final simulation output is:

```text
TEST PASSED
```
