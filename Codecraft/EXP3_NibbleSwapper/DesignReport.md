

# NibbleSwapper Design Report

## Problem Statement

The goal of this project is to design a synchronous digital module that swaps the upper nibble (bits 7–4) and the lower nibble (bits 3–0) of an 8-bit input vector. The swap operation should occur on the rising edge of the clock when enabled, and the output should reset asynchronously when required.

---

## Use Case

Nibble swapping is a useful operation in digital systems that perform byte manipulation, data encoding/decoding, checksum preparation, or certain cryptographic and compression algorithms. By rearranging nibbles efficiently, it can simplify hardware logic for data transformation or alignment.

---

## Design Requirements

* The module accepts an 8-bit input vector.
* It operates synchronously with a clock input (`clk`).
* It supports an asynchronous reset (`reset`) that clears the output to zero.
* A control signal (`swap_en`) determines whether a swap occurs.
* If `swap_en` is low, the module retains the previous output value.
* If `swap_en` is high, the module outputs the swapped value `{in[3:0], in[7:4]}`.

---

## Design Constraints

* The design is synchronous and uses non-blocking assignments to ensure proper sequential logic behavior.
* The reset is asynchronous, active-high.
* Input and output width is fixed at 8 bits.
* The swap logic should be implemented with minimal delay and hardware resources.

---

## Design Methodology & Implementation Details

Two potential methods were considered for implementing the nibble swap:

**Method-1 (Chosen Method):**
Use the Verilog concatenation operator to directly reorder the bits:


out <= {in[3:0], in[7:4]};


This method is simple, synthesizes to direct wiring, and requires zero extra logic gates.

**Method-2:**
Mask and shift each nibble separately, then combine:


lower = in & 8'b0000_1111;
upper = in & 8'b1111_0000;
out   = (lower << 4) | (upper >> 4);

This approach requires additional gates (AND, shift, OR) and is less efficient.

The module implements **Method-1** within a clocked always block, with asynchronous reset and `swap_en` control.

---

## Functional Simulation Methodology & Test Cases

| Test Case | Input | swap\_en | Expected Output | Description                    |
| --------- | ----- | -------- | --------------- | ------------------------------ |
| 1         | 71    | 1        | 17              | Swap operation enabled         |
| 2         | A5    | 0        | 17              | Hold previous output           |
| 3         | B4    | 1        | 4B              | Swap high and low nibbles      |
| 4         | C3    | 1        | 3C              | Swap produces reversed nibbles |
| 5         | F0    | 0        | 3C              | No change when disabled        |
| 6         | F0    | 1        | 0F              | Swap with high nibble full     |
| 7         | 11    | 1        | 11              | Identical nibbles remain same  |
| 8         | 22    | 1        | 22              | Identical nibbles remain same  |
| 9         | 3C    | 1        | C3              | Swap mirrored pattern          |
| 10        | 00    | 1        | 00              | All zeros unchanged            |
| 11        | FF    | 1        | FF              | All ones unchanged             |
| 12        | A5    | 1        | 5A              | Normal nibble swap             |
| 13        | 5A    | 1        | A5              | Reverse of previous case       |
| 14        | 0F    | 1        | F0              | Swap with low nibble full      |
| 15        | C0    | 1        | 0C              | Swap with partial high nibble  |
| 16        | 03    | 1        | 30              | Swap with partial low nibble   |
| 17        | 10    | 1        | 01              | Bit moves from high to low     |
| 18        | 01    | 1        | 10              | Bit moves from low to high     |

---

## Results & Analysis

Simulation waveforms confirm that the module correctly swaps the upper and lower nibbles when `swap_en` is asserted and retains the previous output when `swap_en` is deasserted. The asynchronous reset correctly clears the output to zero. All test cases passed successfully.

---

## Challenges & Conclusions

The main challenge was ensuring that the design behaved predictably when `swap_en` was low — the output must hold its value without introducing unintended glitches. Method-1 with the concatenation operator proved optimal in terms of *speed, hardware efficiency, and code simplicity*.
The final design is *synthesizable, resource-light, and reliable* for integration into larger digital systems.


