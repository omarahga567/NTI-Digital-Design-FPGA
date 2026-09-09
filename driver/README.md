# Tri-State Driver Design and Verification

## 📌 Overview

This lab implements and verifies a parameterized **Tri-State Driver** using Verilog HDL.

The driver controls whether an input data value is connected to the output or whether the output is placed in a **high-impedance (`Z`) state**.

When the enable signal `data_en` is asserted, the input data is passed directly to `data_out`. When `data_en` is deasserted, the output is disconnected by driving all output bits to `Z`.

A self-checking Verilog testbench is used to verify both enabled and disabled operating conditions.

---

## 🎯 Objectives

The main objectives of this lab are:

* Implement a tri-state driver using Verilog HDL.
* Understand high-impedance (`Z`) states.
* Use a parameterized data width.
* Control an output using an enable signal.
* Implement conditional continuous assignment.
* Develop a self-checking testbench.
* Verify the driver's behavior under different enable conditions.

---

## 🧩 Driver Interface

| Signal     | Direction |   Width | Description                    |
| ---------- | --------- | ------: | ------------------------------ |
| `data_en`  | Input     |   1 bit | Enables or disables the driver |
| `data_in`  | Input     | `WIDTH` | Input data                     |
| `data_out` | Output    | `WIDTH` | Tri-state output               |

The default value of `WIDTH` is **8 bits**, but it can be changed through the module parameter.

---

## ⚙️ Driver Operation

The driver uses a conditional continuous assignment:

```text
data_out = data_en ? data_in : Z
```

The behavior is:

| `data_en` | `data_out` |
| --------- | ---------- |
| `0`       | `ZZZZZZZZ` |
| `1`       | `data_in`  |

When `data_en = 1`:

```text
data_out = data_in
```

When `data_en = 0`:

```text
data_out = 8'bZZZZZZZZ
```

The `Z` state represents **high impedance**, meaning the driver is effectively disconnected from the output line.

---

## 🧪 Verification

The testbench `driver_test` is a **self-checking testbench**.

It instantiates the `driver` module and applies different combinations of `data_en` and `data_in`.

The `expect` task compares the actual `data_out` with the expected output.

The comparison uses the case-inequality operator:

```text
!==
```

This is important because the testbench needs to correctly detect four-state Verilog values such as:

* `0`
* `1`
* `X`
* `Z`

---

## 🔍 Test Cases

### Test Case 1 — Driver Disabled

```text
data_en = 0
data_in = 8'hXX
```

Expected:

```text
data_out = 8'hZZ
```

This verifies that the driver places the output in the high-impedance state when disabled.

---

### Test Case 2 — Driver Enabled

```text
data_en = 1
data_in = 8'h55
```

Expected:

```text
data_out = 8'h55
```

This verifies that the input data is passed to the output when the driver is enabled.

---

### Test Case 3 — Different Input Data

```text
data_en = 1
data_in = 8'hAA
```

Expected:

```text
data_out = 8'hAA
```

This verifies that the driver correctly transfers different data patterns.

---

## 📊 Verification Summary

| Test     | `data_en` | `data_in` | Expected `data_out` |
| -------- | --------: | --------: | ------------------: |
| Disabled |       `0` |   `8'hXX` |             `8'hZZ` |
| Enabled  |       `1` |   `8'h55` |             `8'h55` |
| Enabled  |       `1` |   `8'hAA` |             `8'hAA` |

If all test cases pass, the testbench displays:

```text
TEST PASSED
```

If an incorrect output is detected, the testbench displays:

```text
TEST FAILED
```

along with the simulation time and relevant signal values.

---

## 📂 Files

```text
Driver/
│
├── driver.v
├── driver_test.v
└── README.md
```

### `driver.v`

Contains the RTL implementation of the parameterized tri-state driver.

### `driver_test.v`

Contains the self-checking Verilog testbench used to verify the driver.

### `README.md`

Contains the documentation and verification results for this lab.

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

* Tri-state logic
* High-impedance (`Z`) states
* Conditional operators
* Continuous assignments
* Parameterized Verilog modules
* Four-state logic (`0`, `1`, `X`, `Z`)
* Self-checking testbenches
* Verilog tasks
* Case inequality (`!==`)
* RTL simulation
