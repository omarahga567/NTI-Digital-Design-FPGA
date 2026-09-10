# Light Chaser

A simple LED light-chaser (knight-rider style) implemented in Verilog.

The design generates a rotating “1” bit across a configurable-width bus, suitable for driving a row of LEDs.  
A clock divider slows the board clock down to a human-visible rate, and a shift register performs the rotation.

---

## File Structure
├── ligth_chaser_top.v   # Top-level module (light_chaser)
├── shift_register.v     # Rotating shift register
├── clk_driver.v         # Clock divider (module name: clk_divider)
└── tb_light_chaser.v    # Testbench

---

## Modules

### 1. `light_chaser` (Top Level)

Connects the clock divider and the shift register.

| Port       | Direction | Description                        |
|------------|-----------|------------------------------------|
| `clk`      | input     | System clock (e.g. 50 MHz)         |
| `reset_n`  | input     | Active-low asynchronous reset      |
| `hold_n`   | input     | Active-low hold (freeze pattern)   |
| `shift_out`| output    | LED pattern `[WIDTH-1:0]`          |

**Parameters**

| Parameter        | Default     | Description                          |
|------------------|-------------|--------------------------------------|
| `INPUT_FREQ_HZ`  | 50_000_000  | Frequency of the input clock         |
| `OUTPUT_FREQ_HZ` | 8           | Desired chase rate (LED update rate) |
| `WIDTH`          | 10          | Number of LEDs / bits                |

---

### 2. `clk_divider`

Generates a slower clock from the system clock.

- Divides by `INPUT_FREQ_HZ / (2 × OUTPUT_FREQ_HZ)`
- Output is a 50 % duty-cycle square wave
- Asynchronous reset

---

### 3. `shift_register`

Implements a rotate-right register:

- On reset → loads `1000...0` (MSB = 1)
- When `hold_n = 0` → freezes the current value
- When `hold_n = 1` → rotates right every rising edge of its clock  
  (`{shift_out[0], shift_out[WIDTH-1:1]}`)

---

## How It Works

1. The clock divider produces a slow clock (default 8 Hz).
2. The shift register is clocked by this slow clock.
3. A single “1” walks from left to right (MSB → LSB) and wraps around.
4. Asserting `hold_n = 0` freezes the pattern.
5. Asserting `reset_n = 0` returns the pattern to `1000...0`.

---

## Testbench

The provided testbench (`tb_light_chaser.v`) covers the following cases:

| # | Test Case                  | Expected Behaviour                     |
|---|----------------------------|----------------------------------------|
| 1 | Asynchronous reset         | Pattern becomes `1000...0`             |
| 2 | Free-running rotation      | Full rotation of the single “1”        |
| 3 | Hold (`hold_n = 0`)        | Pattern freezes                        |
| 4 | Resume after hold          | Rotation continues from frozen value   |
| 5 | Reset while running        | Returns to `1000...0` immediately      |

A VCD file (`tb_light_chaser.vcd`) is generated for waveform viewing.

---

## Simulation

### Using Icarus Verilog

```bash
iverilog -o sim \
    ligth_chaser_top.v \
    shift_register.v \
    clk_driver.v \
    tb_light_chaser.v

vvp sim

gtkwave tb_light_chaser.vcd

===== Light Chaser TB =====
[100] After reset : 1000000000
--- Free running ---
[500] shift_out = 0100000000
[900] shift_out = 0010000000
...
--- Hold test ---
[xxx] Hold ON  : 0000010000
[xxx] Held     : 0000010000   ← frozen
--- Resume ---
[xxx] Running  : 0000001000
...
--- Reset while running ---
[xxx] Reset mid : 1000000000
===== DONE =====