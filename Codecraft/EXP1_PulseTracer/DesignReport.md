DESIGN REPORT
PROBLEM STATEMENT
The goal of this project is to create a reliable pulse detection module that filters out noise from a noisy input signal and generates a clean, single-cycle pulse on the stable rising edge of the input. Noisy signals often cause false triggers, so debouncing is required to ensure accurate detection.

USE CASE
This PulseTracer module can be used wherever input signals are prone to glitches or bouncing—such as mechanical switches, sensors, or asynchronous digital inputs. It ensures that only stable high signals, sustained for a certain time, generate pulses, preventing erroneous system behavior caused by noise.

DESIGN REQUIREMENTS
The module must detect when the noisy input signal stays continuously high for a predefined number of clock cycles (FILTER_LEN).

Generate a one-clock-cycle pulse output at the rising edge of the stable input.

Ignore short glitches or noise shorter than FILTER_LEN cycles.

Reset functionality must initialize the internal registers and outputs reliably.

DESIGN CONSTRAINTS
The debounce filter length (FILTER_LEN) impacts detection latency; a larger value filters noise better but increases delay.

The design assumes a synchronous clock domain and requires the noisy input to be sampled at the clock rate.

The reset is active-low and asynchronous.

DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
The design uses a shift register (filter_reg) to store the last FILTER_LEN samples of the noisy input.

When all bits in the shift register are high, the input is considered stable high.

When all bits are low, the input is considered stable low.

The stable input is stored in debounced.

To detect the rising edge, the current debounced value is compared to the previous value (prev_debounced).

When debounced transitions from 0 to 1, the output pulse_out is asserted for one clock cycle.

All registers and outputs are reset to 0 during active-low reset.

FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
Test Case 1 : Short Glitch — No Pulse Expected
In this test, the noisy input is briefly set high for only 1 clock cycle, which is less than the required FILTER_LEN (3 cycles). This simulates a short glitch or noise spike. The expectation is that the PulseTracer module will not generate a pulse output, because the input did not remain stable high long enough to be considered valid.

Test Case 2 : Valid Pulse Detection
Here, the input signal stays continuously high for exactly FILTER_LEN clock cycles, which satisfies the debounce length. This simulates a clean rising edge that should be detected as stable. The module should output a single-cycle pulse at the first clock after the input is recognized as stable. This confirms the core functionality of the debounce and pulse generation.

Test Case 3 : Alternating Noise — No Pulse Expected
This case feeds a random pattern of highs and lows to simulate noisy or bouncing signals. Because the input does not stay stable high for FILTER_LEN consecutive cycles at any point, the module should not produce any pulses. This verifies the robustness of the filter against fluctuating noise.

Test Case 4 : Two Valid Pulses with Low Separation
This test simulates two stable high signals separated by a low period. The first high period lasts for at least FILTER_LEN cycles, triggering the first pulse. Then the signal goes low for a few cycles, resetting the filter. Finally, a second stable high period again longer than FILTER_LEN cycles occurs, triggering a second pulse. This verifies that the module can detect multiple pulses separated by low intervals reliably.

Test Case 5 : Long Held High — Only One Pulse
In this case, the input goes high and stays high for a long duration, well beyond the debounce period. The module should generate only one pulse at the initial rising edge and then keep the output low for subsequent cycles despite the input staying high. This prevents multiple pulses from being generated for a single continuous high input.

Test Case 6 : Glitch During Rising Period
Here, the input starts to rise but is interrupted by a brief low glitch before reaching the full FILTER_LEN stable cycles. After the glitch, the input again remains high for enough cycles to become stable. This test checks that the debounce filter resets when glitches occur and correctly detects a pulse only after the input stabilizes again, preventing false triggers during the glitch.

Test Case 7 : Random Noise Followed by Valid Pulse
This final test applies a long sequence of random noise to simulate a real-world noisy environment. After the noise period, the input is driven low briefly and then held high stably for FILTER_LEN cycles, expecting a valid pulse. This test verifies that the module can recover from noisy conditions and still detect a correct pulse when a stable input eventually arrives.

RESULTS & ANALYSIS
Simulation waveforms confirm that the module filters out glitches and noise, generating pulses only on stable rising edges. The pulse output remains high for exactly one clock cycle at the correct time, matching the design intent. No false pulses were seen during noisy conditions or glitches, demonstrating effective debounce filtering.

CHALLENGES & CONCLUSIONS
Choosing an appropriate FILTER_LEN required balancing noise immunity against responsiveness. Shorter FILTER_LEN values are more responsive but prone to noise, while longer values add latency. The testbench confirmed the design behaves correctly under various noise and input conditions. Overall, the PulseTracer module provides a simple and effective solution to detect stable pulses from noisy signals and can be easily adapted for different applications by tuning FILTER_LEN.

