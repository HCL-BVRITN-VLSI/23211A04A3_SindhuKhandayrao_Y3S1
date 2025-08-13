

# **DESIGN REPORT**

## **1. Problem Statement**

The goal of this project is to design a reliable **Pulse Detection Module** that filters out noise from a noisy input signal and generates a clean, **single-clock-cycle pulse** on the stable rising edge of the input.

Noisy signals can cause **false triggers**, so **debouncing** is required to ensure accurate detection.

---

## **2. Use Case**

The **PulseTracer** module can be applied in scenarios where input signals are prone to glitches or bouncing, such as:

* Mechanical switches
* Sensors
* Asynchronous digital inputs

It ensures that only **stable high signals**, sustained for a defined number of clock cycles, generate pulses—preventing **erroneous system behavior** caused by noise.

---

## **3. Design Requirements**

* Detect when the noisy input stays continuously **high** for **FILTER\_LEN** clock cycles.
* Generate a **one-clock-cycle pulse** at the **rising edge** of the stable input.
* Ignore short glitches or noise shorter than **FILTER\_LEN** cycles.
* Provide a **reliable reset** that initializes internal registers and outputs.

---

## **4. Design Constraints**

* **FILTER\_LEN** directly impacts detection latency:

  * Larger → better noise filtering, more delay
  * Smaller → faster response, less filtering
* Operates in a **synchronous clock domain**; noisy input sampled at clock rate.
* **Reset** is **active-low** and **asynchronous**.

---

## **5. Design Methodology & Implementation**

**Core Principle:** Debouncing using a shift register.

**Implementation Steps:**

1. **Sampling & Storage:**

   * Use a **shift register (`filter_reg`)** to store the last **FILTER\_LEN** samples of the noisy input.
2. **Stability Check:**

   * All bits high → input considered **stable high**.
   * All bits low → input considered **stable low**.
3. **Debounced Signal:**

   * Stored in `debounced` register.
4. **Edge Detection:**

   * Compare `debounced` to `prev_debounced`.
   * **0 → 1 transition** triggers a one-clock-cycle **`pulse_out`**.
5. **Reset Logic:**

   * Active-low reset clears all registers and outputs to `0`.

---

## **6. Functional Simulation Methodology & Test Cases**

| **Test Case**                        | **Description**                                           | **Expected Result**                  |
| ------------------------------------ | --------------------------------------------------------- | ------------------------------------ |
| **1: Short Glitch — No Pulse**       | Input high for < FILTER\_LEN cycles.                      | No pulse generated.                  |
| **2: Valid Pulse Detection**         | Input high for exactly FILTER\_LEN cycles.                | Single pulse generated.              |
| **3: Alternating Noise**             | Random highs/lows, never stable high for FILTER\_LEN.     | No pulse generated.                  |
| **4: Two Valid Pulses**              | Two stable high periods separated by a low period.        | Two separate pulses generated.       |
| **5: Long Held High**                | Input high beyond FILTER\_LEN.                            | Only one initial pulse generated.    |
| **6: Glitch During Rising Period**   | High interrupted by brief low before FILTER\_LEN reached. | Pulse only after second stable high. |
| **7: Noise Followed by Valid Pulse** | Random noise followed by stable high period.              | Single valid pulse generated.        |

---

## **7. Results & Analysis**

* **Glitches & Noise:** Successfully filtered.
* **Pulse Timing:** Exactly **one clock cycle** on stable rising edges.
* **No False Pulses:** Verified under multiple noise patterns.
* **Robustness:** Recovered correctly after noise sequences.

---

## **8. Challenges & Conclusions**

**Challenges:**

* Selecting **FILTER\_LEN** involved balancing **noise immunity vs. response speed**.
* Shorter values → more responsive but less immune.
* Longer values → more immune but slower.

**Conclusion:**
The **PulseTracer** module provides an **efficient and adaptable** solution for detecting stable pulses from noisy inputs. By tuning **FILTER\_LEN**, it can be tailored for specific applications, ensuring **accurate and noise-immune detection** in real-world conditions.

