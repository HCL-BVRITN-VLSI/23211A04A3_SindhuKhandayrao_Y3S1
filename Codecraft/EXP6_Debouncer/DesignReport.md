

# **DESIGN REPORT: DebouncerLite Module**

## **Problem Statement**

The goal is to remove glitches and noise from a digital input signal. Mechanical switches or sensors can bounce, creating unwanted multiple transitions. This module ensures only signals stable for **N clock cycles** are considered valid.

---

## **Use Case**

* Mechanical switches or buttons
* Sensors producing noisy pulses
* Any system needing stable digital input

---

## **Design Requirements**

* Input sampled synchronously with clock.
* Output changes only after **N stable cycles**.
* Asynchronous active-low reset clears all registers.
* Short glitches (< N cycles) are ignored.

---

## **Design Method**

1. **Input Synchronization:** Two flip-flops (`sync1`, `sync2`) stabilize the input.
2. **Stability Counter:** Counts cycles where input differs from `debounced`.
3. **Debounced Update:** When count reaches N, output updates.
4. **Reset Handling:** All registers reset asynchronously on `rst_n = 0`.

---

## **Simulation Observations from Waveform**

* **sync1 and sync2** properly synchronize `noisy_in`.
* **count** increments when `sync2` differs from `debounced`.
* **debounced** changes only after count reaches N-1, confirming correct debounce.
* Short spikes in `noisy_in` do **not** change `debounced`.
* Long stable periods trigger output after N cycles.
* Reset (`rst_n`) correctly clears `debounced` and `count`.

Overall, the waveform confirms the module works correctly.

---

## **Test Cases (Simplified)**

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

---

## **Conclusion**

The `debouncerlite` module successfully filters noise, ignores short glitches, and updates output only after N stable cycles. The uploaded waveform confirms correct operation.



