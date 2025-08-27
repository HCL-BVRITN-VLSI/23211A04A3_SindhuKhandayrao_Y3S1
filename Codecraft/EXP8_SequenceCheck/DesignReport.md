

# SeqCheck Module Design Report

## PROBLEM STATEMENT

The goal of this project is to design a synchronous digital module that **detects rising edges in an input signal within a sliding window of cycles** and generates a **1-cycle pulse (`hit`) whenever the count of rising edges meets or exceeds a specified threshold**.

The module should:

* Detect rising edges on a synchronized input signal.
* Maintain a sliding window of the last `WINDOW` cycles.
* Generate a 1-cycle pulse when the number of rising edges in the window ≥ `THRESHOLD`.
* Pause detection naturally when the input is constant.
* Support an asynchronous active-low reset.

---

## USE CASE

SeqCheck modules are widely used in:

* Event detection in digital signal processing (e.g., spike detection, activity monitoring).
* Debouncing and filtering input signals in embedded systems.
* Triggering counters, alarms, or interrupts when a threshold of events is reached.
* FPGA or ASIC verification scenarios to validate signal patterns over time.

---

## DESIGN REQUIREMENTS

* Input clock (`clk`) drives synchronous operation.
* Asynchronous active-low reset (`rst_n`) clears internal registers and history.
* Input signal (`in_sig`) is synchronized internally using a 2-flip-flop synchronizer.
* Maintains a **sliding window of the last `WINDOW` cycles** using a simple ring buffer.
* `hit` output is a **1-cycle pulse** when the number of detected rises in the window ≥ `THRESHOLD`.
* Parameterizable **window size (`WINDOW`)** and **threshold (`THRESHOLD`)**.

---

## DESIGN CONSTRAINTS

* Sequential design using non-blocking assignments.
* Ring buffer stores only the last `WINDOW` rising edge detections.
* Running sum of the buffer computed every cycle for O(1) update.
* `hit` pulse generated **exactly once** per threshold crossing.
* Avoided complex functions like `$clog2` to simplify hardware implementation.

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS

* **2FF Synchronizer:** Input `in_sig` passes through two flip-flops to remove metastability.
* **Rising Edge Detection:** `rise_detected = sync_ff2 & ~sync_prev`.
* **Ring Buffer & Running Sum:**

  * Circular buffer stores last `WINDOW` rising edges.
  * Each cycle: subtract oldest value from sum, add current rise.
  * Index wraps around after `WINDOW` positions.
* **Hit Pulse Generation:**

  * `hit` = 1-cycle pulse when sum ≥ `THRESHOLD` and previous cycle did not meet threshold.
* **Reset Behavior:**

  * Asynchronous `rst_n=0` clears ring buffer, sum, index, and hit flag.

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES

| Case | Scenario                             | Expected Behavior                                                       | Observation |
| ---- | ------------------------------------ | ----------------------------------------------------------------------- | ----------- |
| 1    | Exactly K rises within WINDOW cycles | One `hit` pulse generated                                               | Correct     |
| 2    | K rises spaced > WINDOW cycles       | No `hit` generated                                                      | Correct     |
| 3    | Dense edges                          | Multiple `hit` pulses over time as window slides                        | Correct     |
| 4    | Reset clears history                 | Old rises discarded, no pulse generated until new rises                 | Correct     |
| 5    | Long HIGH then two additional rises  | Only first rise counted, threshold pulse generated when total rises ≥ K | Correct     |
| 6    | Alternating input every cycle        | Periodic `hit` pulses triggered when threshold crossed                  | Correct     |
| 7    | No edges at all                      | No `hit` pulses                                                         | Correct     |

Simulation waveforms were inspected to ensure **1-cycle pulse width** and correct threshold behavior.

---

## RESULTS & ANALYSIS

* Simulation waveforms confirm correct detection of rising edges.
* 1-cycle pulse `hit` is generated exactly when the threshold is crossed.
* Sliding window correctly maintains a history of the last `WINDOW` cycles.
* Reset reliably clears the buffer and sum.
* All edge cases, including dense input sequences, alternating signals, and long HIGH periods, were handled correctly.

---

## CHALLENGES & CONCLUSIONS

* Main challenge: **generate a clean 1-cycle pulse without using complex functions** like `$clog2`.
* Ring buffer with running sum provides O(1) update per cycle and is scalable for small windows.
* The module is **parameterized, synthesizable, and robust** for FPGA or ASIC implementations.
* Verified through testbench: **All 7 test cases passed with 0 errors**.

