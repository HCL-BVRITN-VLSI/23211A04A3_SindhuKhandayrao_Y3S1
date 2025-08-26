## DESIGN REPORT: DebouncerLite Module
## PROBLEM STATEMENT

The goal of this project is to design a robust debouncing module that filters out noise from a digital input signal. Mechanical switches or sensors often produce glitches or bounces that can generate multiple unwanted transitions. The debouncerlite module ensures that only signals stable for a minimum of N clock cycles are considered valid, generating a clean, debounced output.

## USE CASE

Mechanical push-buttons or switches prone to bouncing

Sensors generating asynchronous noisy pulses

Any system requiring a stable digital input to trigger events reliably

The module ensures accurate detection of input changes, avoiding false triggers caused by short glitches or oscillations.

## DESIGN REQUIREMENTS

Input signal is sampled synchronously with the clock.

Output toggles only after N consecutive cycles of a stable input level.

Asynchronous active-low reset initializes all registers.

Counter tracks stability of the input relative to the current debounced output.

Short spikes shorter than N cycles are ignored.

## DESIGN CONSTRAINTS

Larger N increases noise immunity but adds latency to detection.

Module assumes a single clock domain.

Output is updated synchronously on the clock edge.

## DESIGN METHODOLOGY

Input Synchronization: Two flip-flops (sync1, sync2) synchronize the noisy input to avoid metastability.

Stability Counter: A counter tracks how long the input differs from the debounced output.

Debounced Update: When the input remains stable for N cycles, debounced is updated.

Reset Handling: All registers and counters are cleared asynchronously on rst_n = 0.

## FUNCTIONAL SIMULATION & TEST CASES
*CASE 1*: Short high glitch (<N)

Scenario: Input briefly goes high for fewer than N cycles.

Expectation: No change in output.

Result: debounced remains low.

Analysis: Short glitches are ignored successfully.

*CASE 2*: Exactly N-1 high then drop

Scenario: Input goes high for N-1 cycles and then returns low.

Expectation: Output should not change.

Result: debounced remains low.

Analysis: Module requires full N cycles to confirm stability.

*CASE 3*: Bouncy then stable HIGH (>=N)

Scenario: Input oscillates initially then remains high for >= N cycles.

Expectation: Output transitions to high after stability period.

Result: debounced correctly updates after N stable cycles.

Analysis: Debouncer correctly filters initial bounce and detects stable signal.

*CASE 4*: Bouncy then stable LOW (>=N)

Scenario: Input oscillates then remains low for >= N cycles.

Expectation: Output transitions to low after stability period.

Result: debounced correctly updates low.

Analysis: Module correctly identifies stable low despite bounces.

*CASE 5*: Spaced spikes

Scenario: Input toggles briefly with gaps in between.

Expectation: Output does not change for isolated spikes.

Result: debounced remains stable.

Analysis: Short isolated transitions are ignored, demonstrating effective spike filtering.

*CASE 6*: Clean press long

Scenario: Input stays high for much longer than N cycles.

Expectation: Output transitions high once.

Result: debounced goes high after N cycles and remains high.

Analysis: Continuous stable high input is handled correctly without multiple updates.

*CASE 7*: Clean release long

Scenario: Input stays low for much longer than N cycles.

Expectation: Output transitions low once.

Result: debounced goes low and stays low.

Analysis: Long stable low signals are detected reliably.

*CASE 8*: Rapid toggle

Scenario: Input alternates rapidly, faster than N cycles.

Expectation: Output remains stable.

Result: No false transitions occur in debounced.

Analysis: Module filters high-frequency noise successfully.

*CASE 9*: Two valid presses

Scenario: Two separate periods of stable high input, each >= N cycles.

Expectation: Output toggles high for first stable input, low in between, then high again.

Result: debounced reflects both presses correctly.

Analysis: Multiple valid events are detected with correct timing.

*CASE 10*: Two valid releases

Scenario: Two separate stable low periods separated by high input.

Expectation: Output toggles low appropriately.

Result: debounced follows input correctly.

Analysis: Module handles multiple low transitions accurately.

*CASE 11*: Reset

Scenario: Module reset is asserted during operation.

Expectation: All registers and output cleared.

Result: debounced, count, and sync registers reset to 0.

Analysis: Reset works asynchronously and reliably.

*CASE 12*: Post-reset press

Scenario: Input goes high after reset.

Expectation: Output transitions high after N stable cycles.

Result: debounced updates correctly.

Analysis: Module resumes normal operation after reset.

RESULTS & ANALYSIS

The module successfully filtered short glitches and bounces.

Output only changes when input is stable for N consecutive cycles.

Reset works as intended, and module recovers correctly.

All 12 test cases passed with zero false transitions.

CONCLUSIONS

The debouncerlite module provides a simple and effective hardware solution to filter noisy digital inputs. It reliably generates debounced output signals suitable for mechanical switches, sensors, and other asynchronous inputs. By adjusting the parameter N, designers can balance noise immunity and detection latency according to their application needs.