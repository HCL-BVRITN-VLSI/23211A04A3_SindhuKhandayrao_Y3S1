

# **DESIGN REPORT: EdgeHighlighter Module**

## **PROBLEM STATEMENT**

The goal of this project is to design a simple digital module that detects rising (0→1) and falling (1→0) edges of a signal and generates 1-clock-cycle pulses for each edge. This module helps cleanly identify transitions on a digital input without glitches or missed edges.

This experiment is a **straightforward, naive implementation**, primarily to understand edge detection in synchronous circuits.

---

## **USE CASE**

* Detecting button presses or releases in digital circuits.
* Generating triggers for other modules when a signal changes state.
* Useful in synchronous systems for precise event timing.

---

## **DESIGN REQUIREMENTS**

* Detect rising and falling edges of a digital input.
* Generate a **1-clock-cycle pulse** on each edge.
* Optional **2-flip-flop synchronizer** for asynchronous inputs.
* Support **async active-low reset** to clear internal state.
* Mutually exclusive pulses: rising and falling pulses cannot be high at the same time.

---

## **DESIGN CONSTRAINTS**

* Minimalist, naive implementation (no fancy circuits or counters).
* Works with both synchronous and asynchronous inputs.
* Output pulse width strictly 1 clock cycle.
* Should not glitch even on fast alternating signals.

---

## **DESIGN METHODOLOGY & IMPLEMENTATION DETAILS**

* The input signal is optionally passed through **two flip-flops (`s1` and `s2`)** when `USE_SYNC=1`.

  * **Purpose of `s1` and `s2`**: They act as a **synchronizer**, preventing metastability when the input is asynchronous. Essentially, `s1` captures the input, and `s2` captures `s1` on the next clock. The edge detection uses `s2`.
* The **current input (`cur`)** is compared with the **previous value (`prev`)** to detect edges:

  * Rising edge: `cur = 1` and `prev = 0` → `rise_pulse = 1`.
  * Falling edge: `cur = 0` and `prev = 1` → `fall_pulse = 1`.
* **Asynchronous reset (`rst_n`)** clears both the previous value and output pulses.

> The design is intentionally simple to observe basic edge detection behavior.

---

## **FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES**



| **Case** | **Input Behavior**                  | **Expected Output**                                   | **Purpose / Check**                                           |
| -------- | ----------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------- |
| 1        | Single 1-cycle high pulse (`0→1→0`) | `rise_pulse` = 1 cycle, `fall_pulse` = 1 cycle        | Verify detection of very short pulses                         |
| 2        | Wide high (5 cycles)                | 1 `rise_pulse` at start, 1 `fall_pulse` at end        | Check no repeated pulses during long high period              |
| 3        | Two pulses separated by 1 low cycle | Each pulse produces 1 `rise_pulse` and 1 `fall_pulse` | Verify detection of multiple pulses in sequence               |
| 4        | Long low (12 cycles)                | `rise_pulse` = 0, `fall_pulse` = 0                    | Ensure no false pulses when signal is steady                  |
| 5        | Alternate every cycle (`010101…`)   | `rise_pulse` and `fall_pulse` alternate each cycle    | Test rapid alternating signals and edge detection correctness |
| 6        | Mid-stream reset                    | Reset clears history; next edge detected fresh        | Validate async reset and correct edge detection after reset   |


---

## **RESULTS & ANALYSIS**

* **All test cases passed successfully**.
* Output pulses were **always 1 clock cycle wide**.
* No dual pulses occurred in the same cycle.
* Optional 2-flip-flop synchronizer (`s1` and `s2`) worked as expected, safely synchronizing asynchronous input before edge detection.
* The design is simple, readable, and behaves predictably.

---

## **CHALLENGES & CONCLUSIONS**

* **Challenges:** Minimal; as this is a naive experiment, no complex logic was required. Understanding the role of `s1` and `s2` as a synchronizer was key.
* **Conclusion:** The `edgehighlighter` module is a **straightforward, robust way** to detect rising and falling edges in synchronous digital systems. The use of `s1` and `s2` ensures safe operation even for asynchronous signals, demonstrating a fundamental technique in digital design.


