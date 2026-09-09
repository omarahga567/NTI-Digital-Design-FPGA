# ALU Design and Verification

## 📌 Overview

This lab implements and verifies a parameterized **Arithmetic Logic Unit (ALU)** using **Verilog HDL**.

The ALU supports multiple operations selected through a 3-bit `opcode`. The design also provides an `a_is_zero` status signal that indicates whether the input `in_a` is equal to zero.

A dedicated Verilog testbench is used to verify the functionality of the ALU by applying different input combinations and checking the resulting outputs against the expected values.

---

## 🎯 Objectives

The main objectives of this lab are:

* Implement an ALU using Verilog HDL.
* Use a parameterized data width for the ALU.
* Implement different arithmetic and logical operations.
* Generate a status signal based on an input condition.
* Develop a self-checking Verilog testbench.
* Verify the ALU using multiple test cases.
* Detect and report incorrect outputs automatically.

---

## 🧩 ALU Interface

| Signal      | Direction |   Width | Description                      |
| ----------- | --------- | ------: | -------------------------------- |
| `in_a`      | Input     | `WIDTH` | First ALU input                  |
| `in_b`      | Input     | `WIDTH` | Second ALU input                 |
| `opcode`    | Input     |  3 bits | Selects the ALU operation        |
| `a_is_zero` | Output    |   1 bit | Indicates whether `in_a` is zero |
| `alu_out`   | Output    | `WIDTH` | ALU operation result             |

The default value of `WIDTH` is **8 bits**, but it can be changed through the module parameter.

---

## ⚙️ Supported Operations

The ALU uses a 3-bit opcode to select the required operation.

| Opcode | Operation | Description               |
| ------ | --------- | ------------------------- |
| `000`  | PASS0     | Pass `in_a` to the output |
| `001`  | PASS1     | Pass `in_a` to the output |
| `010`  | ADD       | `in_a + in_b`             |
| `011`  | AND       | `in_a & in_b`             |
| `100`  | XOR       | `in_a ^ in_b`             |
| `101`  | PASSB     | Pass `in_b` to the output |
| `110`  | PASS6     | Pass `in_a` to the output |
| `111`  | PASS7     | Pass `in_a` to the output |

### Zero Detection

The `a_is_zero` output is asserted when:

```text
in_a == 0
```

Therefore:

```text
in_a = 0  →  a_is_zero = 1
in_a ≠ 0  →  a_is_zero = 0
```

---

## 🧪 Verification

The testbench `alu_test` is a **self-checking testbench**.

It instantiates the ALU and applies a series of test cases covering all eight opcode values.

For each test case, the testbench checks:

* `a_is_zero`
* `alu_out`

The `expect` task compares the actual outputs with the expected outputs.

If a mismatch occurs, the testbench displays:

```text
TEST FAILED
```

along with the current simulation time, inputs, opcode, actual outputs, and expected values.

If all tests pass, the testbench displays:

```text
TEST PASSED
```

and terminates the simulation.

---

## 🔍 Test Cases

The testbench uses:

```text
in_a = 8'h42
in_b = 8'h86
```

for the main ALU operations.

Expected results:

| Operation | Expected Output |
| --------- | --------------- |
| PASS0     | `8'h42`         |
| PASS1     | `8'h42`         |
| ADD       | `8'hC8`         |
| AND       | `8'h02`         |
| XOR       | `8'hC4`         |
| PASSB     | `8'h86`         |
| PASS6     | `8'h42`         |
| PASS7     | `8'h42`         |

An additional test verifies the zero-detection functionality:

```text
in_a = 8'h00
```

Expected:

```text
a_is_zero = 1
alu_out   = 8'h00
```

---

## 📂 Files

```text
ALU/
│
├── alu.v
├── alu_test.v
└── README.md
```

### `alu.v`

Contains the RTL implementation of the parameterized ALU.

### `alu_test.v`

Contains the Verilog testbench used to verify the ALU functionality.

### `README.md`

Contains the documentation for the lab, including the design description, supported operations, and verification methodology.

---

## 🛠️ Tools & Technologies

* **HDL:** Verilog
* **Design:** RTL
* **Verification:** Verilog Testbench
* **Simulation:** QuestaSim / ModelSim
* **Training:** NTI Digital Design Using FPGA

---

## 📈 Verification Result

The testbench successfully verifies all supported ALU operations and the `a_is_zero` status signal.

A successful simulation produces:

```text
TEST PASSED
```

---

## 📚 Concepts Practiced

Through this lab, the following concepts were practiced:

* Verilog module design
* Module parameters
* Combinational logic
* `always @(*)`
* `case` statements
* Bitwise operations
* Arithmetic operations
* Status/flag generation
* Verilog tasks
* Self-checking testbenches
* Expected vs. actual output comparison
* `$display`
* `$finish`
* RTL simulation
