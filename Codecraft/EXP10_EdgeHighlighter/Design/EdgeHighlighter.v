
module edgehighlighter #(
    parameter bit USE_SYNC = 1   // 1: use 2FF sync on input, 0: input treated synchronous
)(
    input  logic clk,
    input  logic rst_n,          // async active-low reset
    input  logic in_sig,         // input signal to detect edges
    output logic rise_pulse,     // goes high 1 cycle on rising edge
    output logic fall_pulse      // goes high 1 cycle on falling edge
);

    // internal signals
    logic s1, s2;    // for optional 2-flip-flop sync
    logic cur, prev; // current and previous input

    // optional synchronizer
    generate
        if (USE_SYNC) begin
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    s1 <= 0; 
                    s2 <= 0;
                end else begin
                    s1 <= in_sig;
                    s2 <= s1;
                end
            end
            assign cur = s2;
        end else begin
            assign cur = in_sig;
        end
    endgenerate

    // edge detection logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev       <= 0;
            rise_pulse <= 0;
            fall_pulse <= 0;
        end else begin
            rise_pulse <= cur & ~prev;  // 0->1 edge
            fall_pulse <= ~cur & prev;  // 1->0 edge
            prev       <= cur;           // store current input
        end
    end

endmodule
