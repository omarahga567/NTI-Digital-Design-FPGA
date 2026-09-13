# Verilog Controller Design and Verification

## Overview

This project implements and verifies a combinational control unit for a simple CPU architecture using Verilog HDL.

The controller generates the required control signals based on the current instruction opcode, processor phase, and zero flag. The design supports instruction fetch, decode, and execution phases for eight different instructions.

A self-checking Verilog testbench is included to automatically verify the controller behavior across all supported instructions and processor phases.

---

## Project Objectives

* Design a combinational CPU control unit using Verilog HDL.
* Generate control signals according to the current processor phase.
* Support multiple instruction opcodes.
* Implement conditional control for the Skip-if-Zero instruction.
* Verify all controller outputs using a self-checking testbench.
* Gain practical experience with RTL design and functional verification.

---

## Supported Instructions

The controller supports the following 3-bit opcodes:

| Opcode | Instruction | Description                                          |
| :----: | ----------- | ---------------------------------------------------- |
|  `000` | HLT         | Halt the processor                                   |
|  `001` | SKZ         | Skip the next instruction if the accumulator is zero |
|  `010` | ADD         | Add memory data to the accumulator                   |
|  `011` | AND         | Perform logical AND with memory data                 |
|  `100` | XOR         | Perform logical XOR with memory data                 |
|  `101` | LDA         | Load data from memory into the accumulator           |
|  `110` | STO         | Store accumulator data into memory                   |
|  `111` | JMP         | Jump to the specified memory address                 |

---

## Controller Inputs

| Signal   |  Width | Description                               |
| -------- | :----: | ----------------------------------------- |
| `phase`  | 3 bits | Current processor execution phase         |
| `opcode` | 3 bits | Current instruction opcode                |
| `zero`   |  1 bit | Indicates whether the accumulator is zero |

The processor uses eight phases represented by `3'b000` through `3'b111`.

---

## Controller Outputs

| Signal    | Description                                             |
| --------- | ------------------------------------------------------- |
| `sel`     | Selects the required data path during instruction fetch |
| `rd`      | Enables memory read                                     |
| `ld_ir`   | Loads the instruction register                          |
| `inc_pc`  | Increments the program counter                          |
| `halt`    | Stops processor execution                               |
| `ld_pc`   | Loads a new value into the program counter              |
| `data_en` | Enables data transfer from the accumulator/data path    |
| `ld_ac`   | Loads data into the accumulator                         |
| `wr`      | Enables memory write                                    |

---

## Processor Phases

The controller operates through eight phases.

| Phase | Binary | Main Operation                          |
| :---: | :----: | --------------------------------------- |
|   0   |  `000` | Instruction address selection           |
|   1   |  `001` | Memory read                             |
|   2   |  `010` | Instruction register load               |
|   3   |  `011` | Instruction decode                      |
|   4   |  `100` | Instruction-specific control            |
|   5   |  `101` | Memory access for selected instructions |
|   6   |  `110` | Execute / address operation             |
|   7   |  `111` | Final execution operation               |

The first four phases are common to all instructions, while phases 4–7 depend on the opcode.

---

## Control Operation

### Instruction Fetch

During phases 0–3, the controller performs the instruction fetch sequence:

```text
Phase 0
   |
   v
Select Address
   |
   v
Phase 1
   |
   v
Memory Read
   |
   v
Phase 2
   |
   v
Load Instruction Register
   |
   v
Phase 3
   |
   v
Decode Instruction
```

### Instruction Execution

After the fetch/decode sequence, the controller generates instruction-specific control signals during phases 4–7.

For example:

* `HLT` activates `halt`.
* `SKZ` increments the program counter when `zero = 1`.
* `ADD`, `AND`, `XOR`, and `LDA` perform memory read operations and load the accumulator.
* `STO` enables the data path and memory write.
* `JMP` loads the program counter.

---

## Design Approach

The controller is implemented as a **combinational logic block**.

```verilog
always @(*) begin
    case (phase)
        ...
    endcase
end
```

The controller does not contain a clock or reset because it only decodes the current `phase`, `opcode`, and `zero` inputs.

The processor's phase/state generation would normally be handled by separate sequential logic.

### Design Principle

```text
                 +----------------+
opcode --------->|                |
phase ---------->|   Controller   |----> Control Signals
zero ------------>|                |
                 +----------------+
```

---

## Verification

A self-checking Verilog testbench is included to verify the complete controller functionality.

The testbench checks:

* All 8 supported opcodes
* All 8 processor phases
* Conditional `SKZ` behavior
* Correct generation of every control signal
* Correct behavior of instruction fetch and execution phases

### Verification Coverage

The testbench evaluates:

```text
8 opcodes × 8 phases = 64 test cases
```

Additional testing is performed for the `SKZ` instruction with both:

```text
zero = 0
zero = 1
```

The testbench automatically compares the actual controller outputs against the expected values.

---

## Self-Checking Testbench

The testbench reports failures in the following format:

```text
TEST FAILED

time  opcode  phase  zero  sel  rd  ld_ir  inc_pc  halt  ld_pc  data_e  ld_ac  wr
```

If all expected outputs match the actual outputs, the simulation reports:

```text
TEST PASSED
```

The final verification result for the current implementation is:

```text
TEST PASSED
```

---

## Simulation

The project can be simulated using QuestaSim, ModelSim, or another Verilog-compatible simulator.

### Compile

```tcl
vlib work
vlog controller.v
vlog controller_test.v
```

### Start Simulation

```tcl
vsim work.controller_test
```

### Run Simulation

```tcl
run -all
```

Expected result:

```text
TEST PASSED
```

---

## Project Structure

```text
controller/
│
├── controller.v
├── controller_test.v
└── README.md
```

### `controller.v`

Contains the RTL implementation of the combinational CPU controller.

### `controller_test.v`

Contains the self-checking testbench used to verify the controller.

### `README.md`

Project documentation, design description, instruction set, verification methodology, and simulation instructions.

---

## RTL Design

The controller uses a 3-bit phase input because the processor contains eight phases:

```verilog
input [2:0] phase;
```

The opcode is also 3 bits because eight different instructions are supported:

```verilog
input [2:0] opcode;
```

The controller output signals are implemented as `reg` variables because they are assigned inside an `always @(*)` procedural block.

---

## Verification Methodology

The verification environment follows a basic directed, self-checking approach.

### Test Flow

```text
Initialize Inputs
       |
       v
Select Opcode
       |
       v
Apply Phase 0
       |
       v
Check Outputs
       |
       v
Apply Phase 1
       |
       v
Check Outputs
       |
      ...
       |
       v
Apply Phase 7
       |
       v
Check Outputs
       |
       v
Move to Next Opcode
       |
       v
Repeat
       |
       v
Final Verification Result
```

The testbench terminates automatically using `$finish`.

---

## Expected Verification Result

A successful simulation should finish with:

```text
TEST PASSED
```

and without any failed test cases.

---

## Tools Used

* Verilog HDL
* QuestaSim / ModelSim
* RTL Simulation
* Self-Checking Testbench
* Git / GitHub

---

## Skills Demonstrated

This project demonstrates practical experience with:

* Combinational RTL design
* Verilog HDL
* Opcode decoding
* Control signal generation
* Processor control units
* Instruction fetch and execution sequencing
* Conditional control logic
* Directed verification
* Self-checking testbenches
* Functional simulation
* Debugging RTL width mismatches
* QuestaSim simulation workflow

---

## Possible Future Improvements

The project can be extended with:

* A complete CPU datapath
* Program counter implementation
* Instruction register
* Accumulator
* ALU
* Memory module
* Phase counter / FSM
* Full CPU integration
* SystemVerilog testbench
* Functional coverage
* Assertions
* UVM-based verification

---

## Author

**Omar Ahmed**

Electronics and Communication Engineering

Focus: Digital IC Design and Verification
