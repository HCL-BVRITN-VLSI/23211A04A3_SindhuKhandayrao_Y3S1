

# BitBalancer Module Design Report

## Problem Statement

The goal of this project is to design a synchronous digital module that counts the number of bits set to ‘1’ in an 8-bit input vector. The count must be updated on every clock cycle and reset asynchronously when required.

## Use Case

This bit counting functionality is critical in digital systems requiring parity checking, population count operations, error detection, or bit-level feature extraction. The synchronous design allows integration into clocked systems where data changes on clock edges.

## Design Requirements

* The module accepts an 8-bit input vector.
* The module operates synchronously with a clock input (`clk`).
* It supports an asynchronous reset (`reset`) that clears the count to zero.
* The output is a 4-bit value representing the count of ‘1’ bits in the input vector.
* The count updates on the rising edge of the clock.

## Design Constraints

* The design is synchronous and must use non-blocking assignments for correct behavior.
* The reset signal is asynchronous and active-high.
* The input width is fixed to 8 bits.

## Design Methodology & Implementation Details

The module uses an integer loop variable to iterate through all 8 bits of the input vector on every rising clock edge. It sums the number of bits set to ‘1’ and stores the result in a 4-bit register output `count`.

When the asynchronous reset signal is asserted, the count is cleared immediately to zero. The use of non-blocking assignments ensures proper simulation and synthesis of sequential logic.

## Functional Simulation Methodology & Test Cases

| Test Case | Input (binary) | Expected Output | Description                               |
| --------- | -------------- | --------------- | ------------------------------------------|
| 1         | 00000000       | 0               | No bits set. Tests zero count             |
| 2         | 11111111       | 8               | All bits set. Tests max count             |
| 3         | 00000001       | 1               | Only least significant bit set            |
| 4         | 10000000       | 1               | Only most significant bit set             |
| 5         | 10101010       | 4               | Alternating bits set starting with MSB    |
| 6         | 01010101       | 4               | Alternating bits starting with bit 6      |
| 7         | 00111100       | 4               | Contiguous cluster of four bits in middle |
| 8         | 00011000       | 2               | Sparse middle bits set                    |
| 9         | 00001111       | 4               | Lower nibble set                          |
| 10        | 11110000       | 4               | Upper nibble set                          |
| 11        | 11000011       | 4               | Symmetric bits set at both ends           |
| 12        | 10010110       | 4               | Mixed bit pattern                         |
| 13        | 01111110       | 6               | Dense middle bits set                     |
| 14        | 00000010       | 1               | Single middle bit set                     |
| 15        | 01000001       | 2               | Bits set on both edges                    |
| 16        | 00100100       | 2               | Two center bits set with gaps             |
| 17        | 01100110       | 4               | Balanced pattern of bits set              |


## Results & Analysis

Simulation waveforms confirm that the count output accurately represents the number of ‘1’ bits present in the input vector at each clock cycle. The reset signal properly clears the count asynchronously. All test vectors passed successfully.

## Challenges & Conclusions

The primary challenge was ensuring correct use of non-blocking assignments and asynchronous reset in a synchronous design. The implemented design is robust, synthesizable, and can be integrated easily into larger synchronous digital systems. The bitbalancer module provides efficient and reliable bit counting functionality in synchronous environments.


