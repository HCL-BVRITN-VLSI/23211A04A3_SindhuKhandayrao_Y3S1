
# LightChaser Module Design Report

## PROBLEM STATEMENT

The goal of this project is to design a synchronous digital module that generates a rotating LED pattern, often referred to as a "light chaser" effect. The design cycles through a set of LEDs in a circular left-shift pattern, advancing at a programmable rate controlled by a clock counter.

The module should:

* Begin with the first LED lit after reset.
* Rotate left through all LEDs sequentially.
* Pause rotation when `enable=0`.
* Resume rotation from the same point when `enable=1`.
* Support an asynchronous active-low reset.

---

## USE CASE

Light chasers are widely used in:

* LED running lights, decorative lighting, and automotive indicators.
* Debug displays to show activity in FPGA or ASIC designs.
* Sequential scanning or rotating indicators in embedded systems.

---

## DESIGN REQUIREMENTS

* Input clock (`clk`) drives synchronous operation.
* Asynchronous active-low reset (`rst_n`) initializes LED pattern.
* `enable` input controls stepping (1 = run, 0 = hold).
* Parameterizable width of LED array (`WIDTH`).
* Parameterizable number of clock cycles per step (`TICKS_PER_STEP`).
* Output (`led_out`) rotates left with circular wrap-around.

---

## DESIGN CONSTRAINTS

* Sequential design using non-blocking assignments.
* Asynchronous active-low reset initializes `led_out` to `0000...0001`.
* `tick_cnt` counter determines step timing.
* Clean, glitch-free LED transitions (exactly one LED ON at a time).

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS

* `tick_cnt` increments on every clock cycle when `enable=1`.
* When `tick_cnt` reaches `TICKS_PER_STEP-1`, it resets to zero and advances `led_out`.
* `led_out` shifts left using a circular rotation:

```verilog
led_out <= {led_out[WIDTH-2:0], led_out[WIDTH-1]};
```

* Reset (`rst_n=0`) forces `led_out` = `0000...0001`.
* If `enable=0`, both `tick_cnt` and `led_out` hold their state.
* The design is parameterized for easy scaling of LED width and step timing.

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES

| Case | Scenario                      | Expected Behavior                         | Observation |
| ---- | ----------------------------- | ----------------------------------------- | ----------- |
| 1    | Post-reset hold with enable=0 | Output = `00000001`, no movement          | Correct     |
| 2    | Run 10 steps                  | LEDs rotate left step-by-step             | Correct     |
| 3    | Pause/resume mid-step         | Rotation pauses, resumes at same position | Correct     |
| 4    | Long hold (enable=0)          | Output frozen, no step advances           | Correct     |
| 5    | Wrap-around                   | Last LED shifts back to first LED         | Correct     |
| 6    | Enable edge near boundary     | Clean transition, no missed/double steps  | Correct     |
| 7    | Final cadence check           | Continuous smooth rotation over long run  | Correct     |

---

## RESULTS & ANALYSIS

* Simulation waveforms confirm the LEDs rotate correctly with exact timing.
* Pausing (`enable=0`) reliably freezes both the counter and LED outputs.
* Wrap-around behavior works correctly (`10000000 → 00000001`).
* Edge cases near step boundaries are handled cleanly.
* The design passed all **7 test scenarios** with **0 errors** at simulation time 1,555,000.

---

## CHALLENGES & CONCLUSIONS

* Challenge was to implement circular shifting without shift operators, since the bits had to wrap around
* The design is synthesizable, robust, and scalable with parameters `WIDTH` and `TICKS_PER_STEP`.
* Verified through testbench: **All 7 cases passed successfully.**


