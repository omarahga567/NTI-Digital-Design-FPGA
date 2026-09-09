# Gray Code to Seven-Segment Display Decoder

## 📌 Overview

This lab implements and verifies a parameterized **Gray-to-Seven-Segment Decoder** using Verilog HDL.

The design converts a **Gray-coded** input value into standard binary, then decodes that binary value into the segment pattern needed to drive a 7-segment display.

The conversion is split into two combinational stages — a Gray-to-binary converter and a binary-to-seven-segment decoder — wired together by a top-level module. A self-checking Verilog testbench exercises all 16 Gray-coded input combinations and checks the resulting segment pattern against the expected value.

---

## 🎯 Objectives

The main objectives of this lab are:

* Implement a Gray-to-binary converter using Verilog HDL.
* Implement a binary/hex-to-seven-segment decoder using a `case` statement.
* Use a parameterized data width for the Gray-to-binary stage.
* Combine multiple modules into a single top-level design.
* Implement combinational logic using `assign` and `always @(*)`.
* Develop a self-checking testbench.
* Verify the decoder's behavior across the full range of 4-bit Gray-coded inputs.

---

## 🧩 Module Interfaces

### `gray2binary`

| Signal       | Direction |   Width | Description                  |
| ------------ | --------- | ------: | ----------------------------- |
| `gray_in`    | Input     | `WIDTH` | Gray-coded input value        |
| `binary_out` | Output    | `WIDTH` | Converted binary output value |

The default value of `WIDTH` is **4 bits**, but it can be changed through the module parameter.

### `binary2sevenseg`

| Signal      | Direction | Width  | Description                       |
| ----------- | --------- | -----: | ---------------------------------- |
| `binary_in` | Input     | 4 bits | Binary/hex value (0x0–0xF)         |
| `seg_out`   | Output    | 7 bits | Seven-segment output (`gfedcba`)   |

### `gray2sevenseg` (top level)

| Signal    | Direction |   Width | Description                          |
| --------- | --------- | ------: | ------------------------------------- |
| `gray_in` | Input     | `WIDTH` | Gray-coded input value                |
| `seg_out` | Output    | 7 bits  | Seven-segment output for the digit    |

`gray2sevenseg` instantiates `gray2binary` and `binary2sevenseg` internally and forwards the low 4 bits of the recovered binary value into the decoder.

---

## ⚙️ Driver Operation

### Gray-to-Binary Conversion

The MSB of the binary output equals the MSB of the Gray input, and each remaining bit is the XOR of the previous binary bit with the current Gray bit:

```text
binary_out[WIDTH-1] = gray_in[WIDTH-1]
binary_out[i]        = binary_out[i+1] ^ gray_in[i]   for i = WIDTH-2 downto 0
```

This is implemented with a `generate` loop, so it scales automatically with `WIDTH`.

### Binary-to-Seven-Segment Decoding

The decoder uses a conditional `case` statement inside an `always @(*)` block:

```text
seg_out = decode(binary_in)
```

The segment output is **active-low**: a `0` bit turns the corresponding segment **on**. Bit order is `seg_out = {g, f, e, d, c, b, a}`. Any value outside `0x0`–`0xF` (unreachable with a 4-bit input, but included for safety) drives all segments off:

```text
seg_out = 7'b1111111
```

---

## 🧪 Verification

The testbench `gray2sevenseg_test` is a **self-checking testbench**.

It instantiates the `gray2sevenseg` module as `dut` and applies all 16 possible 4-bit Gray-coded input values in Gray-code order.

The `expect` task compares the actual `seg_out` with the expected segment pattern.

The comparison uses the case-inequality operator:

```text
!==
```

This ensures the testbench correctly detects any unexpected four-state Verilog values such as `X` or `Z` in the output, not just simple `0`/`1` mismatches.

---

## 🔍 Test Cases

### Test Case 1 — Digit 0

```text
gray_in = 4'b0000
```

Expected:

```text
seg_out = 7'b1000000
```

This verifies that a Gray input of `0000` correctly converts to binary `0000` and decodes to the segment pattern for `0`.

---

### Test Case 2 — Mid-Range Digit

```text
gray_in = 4'b0110
```

Expected:

```text
seg_out = 7'b0011001
```

This verifies that a non-trivial Gray code (`0110` → binary `0100` → hex `4`) is correctly converted and decoded.

---

### Test Case 3 — Highest Value

```text
gray_in = 4'b1000
```

Expected:

```text
seg_out = 7'b0001110
```

This verifies that the final Gray-code value (`1000` → binary `1111` → hex `F`) is correctly converted and decoded, confirming the full 16-value sweep completes correctly.

---

## 📊 Verification Summary

| Test | Gray (`gray_in`) | Binary | Expected `seg_out` | Digit |
| :--: | :----------------: | :----: | :-------------------: | :---: |
| 1  | 0000 | 0000 | 1000000 | 0 |
| 2  | 0001 | 0001 | 1111001 | 1 |
| 3  | 0011 | 0010 | 0100100 | 2 |
| 4  | 0010 | 0011 | 0110000 | 3 |
| 5  | 0110 | 0100 | 0011001 | 4 |
| 6  | 0111 | 0101 | 0010010 | 5 |
| 7  | 0101 | 0110 | 0000010 | 6 |
| 8  | 0100 | 0111 | 1111000 | 7 |
| 9  | 1100 | 1000 | 0000000 | 8 |
| 10 | 1101 | 1001 | 0010000 | 9 |
| 11 | 1111 | 1010 | 0001000 | A |
| 12 | 1110 | 1011 | 0000011 | b |
| 13 | 1010 | 1100 | 1000110 | C |
| 14 | 1011 | 1101 | 0100001 | d |
| 15 | 1001 | 1110 | 0000110 | E |
| 16 | 1000 | 1111 | 0001110 | F |

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
Gray2SevenSeg/
│
├── gray2binary.v
├── binary2sevenseg.v
├── gray2sevenseg.v
├── gray2sevenseg_test.v
└── README.md
```

### `gray2binary.v`

Contains the RTL implementation of the parameterized Gray-to-binary converter.

### `binary2sevenseg.v`

Contains the RTL implementation of the binary/hex-to-seven-segment decoder.

### `gray2sevenseg.v`

Contains the top-level module that wires the two stages together.

### `gray2sevenseg_test.v`

Contains the self-checking Verilog testbench used to verify the decoder.

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

* Gray-to-binary conversion
* Combinational logic design
* Parameterized Verilog modules (`generate` loops)
* `case` statement-based decoders
* Multi-module hierarchical design and instantiation
* Seven-segment display encoding (active-low)
* Self-checking testbenches
* Verilog tasks
* Case inequality (`!==`)
* RTL simulation
