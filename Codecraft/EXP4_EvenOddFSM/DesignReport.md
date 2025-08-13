Design Report
Problem Statement
The objective is to design a synchronous digital finite state machine (FSM) that determines whether an 8-bit input value is even or odd. The FSM operates on a valid input signal (in_valid) and produces mutually exclusive outputs:

even = 1 if the number is even

odd = 1 if the number is odd

The FSM should hold its previous output when in_valid is low, and reset asynchronously when required.

Use Case
Even/odd detection is a common requirement in:

Arithmetic processing units

Digital filters and control systems

Hardware-based data classification

Game Development

Address alignment checks (e.g., in memory-mapped devices)

Design Requirements
Accepts an 8-bit input (data_in)

Operates synchronously with a clock (clk)

Has an asynchronous, active-high reset

Uses a control signal (in_valid) to update the output only when valid data is present

Retains the previous state when in_valid = 0

Outputs only one active flag at a time (even XOR odd = 1 for valid data)

Design Constraints
Fully synchronous sequential logic

Outputs change only on the rising edge of the clock when in_valid is high

Reset clears both even and odd outputs to zero

Design Methodology & Implementation
FSM Type: Moore machine (chosen for output stability independent of data_in transitions).

State Encoding:

IDLE → Initial state after reset, no output active

EVEN → Last valid input was even

ODD → Last valid input was odd

Transition Logic:

On in_valid = 1:

If data_in[0] = 0 → go to EVEN

If data_in[0] = 1 → go to ODD

On in_valid = 0 → remain in current state

On reset = 1 → go to IDLE
Implementation Approach:

Extract LSB (data_in[0]) to determine parity

Use a case-based FSM with two states (S_EVEN, S_ODD)

Non-blocking assignments in sequential always block

Functional Simulation Methodology & Test Cases
Test No.	Input (dec)	in_valid	Expected Output	Description
1	0	1	EVEN	Zero is even
2	1	1	ODD	Smallest odd
3	2	1	EVEN	Smallest even > 0
4	255	1	ODD	Max value odd
5	128	1	EVEN	MSB set, LSB 0
6	127	1	ODD	MSB unset, odd
7	254	1	EVEN	Max even
8	3	0	NO CHANGE	Hold state (in_valid=0)
9	4	1	EVEN	Regular even
10	5	1	ODD	Regular odd
11	10	1	EVEN	Multi-bit even
12	11	1	ODD	Multi-bit odd
13	6	0	NO CHANGE	Hold state
14	6	1	EVEN	Regular even
15	9	1	ODD	Regular odd
16	12	1	EVEN	Regular even
17	13	1	ODD	Regular odd
18	14	1	EVEN	Regular even
19	15	1	ODD	Regular odd
20	16	1	EVEN	Larger even

Results & Analysis
Simulation confirmed correct classification for all 20 test cases

Outputs matched expectations with no glitches

FSM correctly held state when in_valid = 0

Moore choice ensured output stability across the clock period

The LSB-based parity detection ensured minimal logic

Challenges Faced
in_valid Handling – Initially, outputs were updating even when in_valid was low. Required additional condition in state transition logic.

Asynchronous Reset Behavior – If reset was asserted mid-cycle, outputs glitched; solved by ensuring reset dominates in sequential always block.

Waveform Verification – Moore FSM outputs appeared one cycle delayed compared to Mealy; needed clarification during debugging.

Edge Case Testing – Had to verify behavior with both extreme values (0 and 255) and alternating valid/no-valid patterns.

Conclusion
The Even/Odd FSM is a compact, reliable design using a Moore architecture.
It passes all functional test cases, handles hold conditions properly, and is ready for integration in larger systems where stable output classification is required.