

## DebouncerLite Module Design Report

## Problem Statement

The goal of this project is to design a synchronous digital module that filters out noise from a digital input signal. Mechanical switches or sensors often produce glitches or bounces that generate multiple unwanted transitions. The DebouncerLite module ensures that only signals stable for a minimum of N clock cycles are considered valid, generating a clean, debounced output.

## Use Case

Debouncing is widely used in:

* Mechanical push-buttons or switches to prevent multiple unintended transitions.
* Keypads and control panels in digital systems.
* Any digital interface where a clean, glitch-free signal is required for reliable operation.

## Design Requirements

* The module accepts a noisy digital input signal.
* Operates synchronously with a clock input (clk).
* Supports an asynchronous reset (rst\_n) that clears the output.
* Produces a clean, debounced output.
* Ensures the output changes only when the input has been stable for N consecutive clock cycles.

## Design Constraints

* Synchronous design, with non-blocking assignments for sequential logic.
* Active-low asynchronous reset.
* Parameterizable stability period N for flexibility.

## Design Methodology & Implementation Details

The DebouncerLite module works as follows:

* Input signal passes through a counter-based stability checker.
* If the input remains stable for N consecutive clock cycles, the output is updated.
* The design uses a sequential always block triggered by posedge clk or negedge rst\_n.
* Non-blocking assignments ensure proper sequential behavior and synthesis compatibility.
* The module provides a clean output that eliminates glitches or bounces from mechanical switches.

## Functional Simulation Methodology & Test Cases

| Case | Scenario                | Expected Output               | Observation |
| ---- | ----------------------- | ----------------------------- | ----------- |
| 1    | Short glitch (\<N)      | No change                     | Correct     |
| 2    | N-1 cycles high         | No change                     | Correct     |
| 3    | Bouncy then stable HIGH | Goes high after N cycles      | Correct     |
| 4    | Bouncy then stable LOW  | Goes low after N cycles       | Correct     |
| 5    | Spaced spikes           | No change                     | Correct     |
| 6    | Long high               | Goes high once                | Correct     |
| 7    | Long low                | Goes low once                 | Correct     |
| 8    | Rapid toggle            | Output stable                 | Correct     |
| 9    | Two valid presses       | Detects both                  | Correct     |
| 10   | Two valid releases      | Detects both                  | Correct     |
| 11   | Reset                   | Output and counter cleared    | Correct     |
| 12   | Post-reset press        | Output updates after N cycles | Correct     |


>

## Results & Analysis

* Simulation waveforms confirm that the debounced output matches expectations for all input patterns.
* The output remains stable even when the input experiences rapid glitches.
* The counter ensures the module ignores spurious transitions shorter than N clock cycles.
* The module reliably produces a clean signal suitable for synchronous digital systems.

## Challenges & Conclusions

* The main challenge was ensuring proper timing and avoiding race conditions in the counter-based logic.
* Determining the appropriate value of N required balancing responsiveness and glitch filtering.
* The DebouncerLite design is synthesizable, robust, and provides reliable debouncing for mechanical inputs.
* For systems requiring immediate response, the stability period N can be adjusted or the module can be combined with combinational logic.

