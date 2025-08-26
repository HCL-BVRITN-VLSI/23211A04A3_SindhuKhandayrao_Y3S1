module edgehighlighter #(
  parameter bit USE_SYNC = 1   // 1: use 2FF sync on in_sig; 0: treat //as synchronous
) (
    input  logic clk,
    input  logic rst_n,          // async active-low
    input  logic in_sig,         // 
    output logic rise_pulse,     // 1 when a 0->1 edge occurs (1 cycle)
    output logic fall_pulse      // 1 when a 1->0 edge occurs (1 cycle)
 );