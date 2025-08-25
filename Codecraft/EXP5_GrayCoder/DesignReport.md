## GrayCoder Module Design Report

## Problem Statement

The goal of this project is to design a synchronous digital module that converts a 4-bit binary input into its equivalent Gray code representation. The design must update on the rising edge of the clock and reset asynchronously when required.

## Use Case

Binary → Gray code conversion is widely used in:

Digital communication systems to prevent large bit changes (error reduction).

Rotary encoders and counters (to avoid glitches).

Low-power digital design, where Gray codes reduce switching activity.

## Design Requirements

The module accepts a 4-bit binary input.

Operates synchronously with a clock input (clk).

Supports an asynchronous reset (reset) that clears the output.

Produces a 4-bit Gray code output.

Output updates on the rising edge of the clock.

## Design Constraints

Synchronous design, with non-blocking assignments for sequential logic.

Active-high asynchronous reset.

Input width is fixed to 4 bits.

## Design Methodology & Implementation Details

The Gray code is generated using the formula:

gray[N-1] = binary[N-1] (MSB same)

gray[i] = binary[i] XOR binary[i+1] for all remaining bits.

The conversion is coded inside a sequential block triggered by posedge clk or posedge reset.

Because of the synchronous design, the Gray output changes one clock cycle after the binary input changes (this is visible in the simulation waveform).

## Functional Simulation Methodology & Test Cases

| Test Case | Binary Input | Expected Gray Output |
| --------- | ------------ | -------------------- |
| 1         | 0000         | 0000                 |
| 2         | 0001         | 0001                 |
| 3         | 0010         | 0011                 |
| 4         | 0011         | 0010                 |
| 5         | 0100         | 0110                 |
| 6         | 0101         | 0111                 |
| 7         | 0110         | 0101                 |
| 8         | 0111         | 0100                 |
| 9         | 1000         | 1100                 |
| 10        | 1001         | 1101                 |
| 11        | 1010         | 1111                 |
| 12        | 1011         | 1110                 |
| 13        | 1100         | 1010                 |
| 14        | 1101         | 1011                 |
| 15        | 1110         | 1001                 |
| 16        | 1111         | 1000                 |
| 17        | 1111         | 1000                 |
| 18        | 0000         | 0000                 |
| 19        | 1111         | 1000                 |
| 20        | 0101         | 0111                 |


## Results & Analysis

The simulation waveform confirms that the output gray_out matches the expected Gray code for every binary input.

As designed, the Gray output updates one clock cycle after the binary input changes (pipeline behavior).

The expected signal in the waveform is used as a reference for functional correctness.



## Challenges & Conclusions

The main challenge was understanding the latency caused by the synchronous update: Gray code conversion is inherently combinational, but implementing it inside a clocked always block introduces one-cycle delay.

If immediate output is required, the logic should be implemented using always @(*) (combinational).

The current synchronous design is robust, synthesizable, and suitable for pipelined systems where controlled timing is preferred.