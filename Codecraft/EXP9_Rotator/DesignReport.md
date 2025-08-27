
# RotatorUnit Module Design Report

## PROBLEM STATEMENT

The goal of this project was to design a **parameterizable rotate register module** that supports **circular shifting of data** in either direction on each clock cycle, with support for synchronous load and asynchronous reset.

The module should:

* Rotate the register contents left or right depending on `dir`.
* Allow new data to be loaded synchronously (`load`) when enabled.
* Hold state when disabled (`enable=0`).
* Reset to zero when `rst_n=0` (asynchronous active-low reset).

---

## USE CASE

Rotator units are commonly used in:

* LED light chaser effects.
* Bit rotation in cryptographic functions and hashing.
* Shift-and-rotate operations in custom CPU/ALU designs.
* Data scramblers, encoders, or circular buffer controllers.

---

## DESIGN REQUIREMENTS

* Input clock (`clk`) drives synchronous behavior.
* Asynchronous active-low reset (`rst_n`) clears the register to all zeros.
* `enable` input gates rotation/load operations.
* `load` allows immediate parallel load of input data.
* `dir=0 → rotate left`; `dir=1 → rotate right`.
* Parameterizable width (`WIDTH`) for scalability.

---

## DESIGN CONSTRAINTS

* Synchronous state update on clock edge.
* Load operation has **highest priority but only when enable=1**.
* When `enable=0`, state holds (load ignored).
* Reset dominates all other controls.
* Design is synthesizable, written in pure SystemVerilog.

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS

* **State Register:** Stores current data value (`state`).
* **Reset:** `rst_n=0` clears `state` to `'0`.
* **Load vs Rotate:**

  * If `enable=1` and `load=1`: `state <= data_in`.
  * Else if `enable=1` and `load=0`: rotate by 1 step depending on `dir`.
* **Rotation:**

  * Left: `{state[WIDTH-2:0], state[WIDTH-1]}`.
  * Right: `{state[0], state[WIDTH-1:1]}`.
* **Output:** `data_out = state`.

---

## FUNCTIONAL SIMULATION & TEST CASES

Simulation was run with **10 directed test cases** from the testbench.
Below is the summary:

| Case | Scenario                            | Expected Behavior                         | Observation     |
| ---- | ----------------------------------- | ----------------------------------------- | --------------- |
| 1    | Reset                               | Output = 0                                |  Passed        |
| 2    | Simple rotate left                  | Bits rotate left 1 position each cycle    |  Passed        |
| 3    | Simple rotate right                 | Bits rotate right 1 position each cycle   |  Passed        |
| 4    | Pause (enable=0)                    | Output holds state                        |  Passed        |
| 5    | Wrap-around rotation                | MSB → LSB (left), LSB → MSB (right) works |  Passed        |
| 6    | Load mid-run (enable=1)             | Data loaded immediately, rotation resumes |  Passed        |
| 7    | Load attempt with enable=0          | Load should be ignored, output holds      |  Failed        |
| 8    | Rapid load + rotate toggling        | Correct priority sequencing               |  Not debugged |
| 9    | Randomized sequence (stress test)   | Correct mixed operation behavior          |  Not debugged |
| 10   | Long-run stability (many rotations) | Smooth cyclic behavior                    |  Not debugged |

---

## RESULTS & ANALYSIS

* **Cases 1–5 passed** immediately (basic rotation, pause, wrap-around).
* **Case 6 passed** after multiple refinements ensuring load priority when enable=1.
* **Case 7 failed** — when `enable=0`, `load=1` was incorrectly processed (design ignored load partially but not fully per spec).
* **Cases 8–10** not yet debugged due to complexity in simultaneous enable/load sequencing.

---

## CHALLENGES & CONCLUSIONS

* Key challenge was **getting priority order correct** between `load` and `enable`.
* Ensuring **load ignored when enable=0** was tricky and caused failure in Case 7.
* Another challenge: **cleanly handling mid-run load (Case 6)**, which initially failed until load was given highest priority under enable.
* The module is synthesizable and works correctly for **most functional cases (1–6)**.
* However, **Case 7 and beyond need further debugging** to ensure strict compliance with spec.

---

 **Conclusion:** The design is mostly functional, passing **6 out of 10 cases**.
 **Remaining work:** Resolve Case 7 bug (load ignored when enable=0), and fully verify Cases 8–10.

