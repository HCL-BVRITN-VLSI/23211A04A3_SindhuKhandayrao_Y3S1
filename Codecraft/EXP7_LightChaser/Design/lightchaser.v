// Code your design here
// -----------------------------------------------------------
// LightChaser
// Rotating LED (circular left shift) every TICKS_PER_STEP clocks
// when enable=1. Holds state when enable=0. Async active-low reset.
// On reset: led_out = 1 (bit0 high).
// -----------------------------------------------------------
module lightchaser #(
    parameter WIDTH          = 8,   // number of LEDs
    parameter TICKS_PER_STEP = 4    // number of clocks before one step
)(
    input  wire              clk,     // clock input
    input  wire              rst_n,   // asynchronous reset, active LOW
    input  wire              enable,  // 1 = rotate LEDs, 0 = hold state
    output reg  [WIDTH-1:0]  led_out  // LED outputs 
);

   reg [TICKS_PER_STEP-1:0] tick_cnt;  // counter to keep track of clocks per step

    // sequential always block: triggered on clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            tick_cnt <= 0;                  // clear counter on reset
            led_out  <= 1;                  // start with LED0 ON (0000...0001)
        end 
        else if (enable) 
        begin
            if (tick_cnt == TICKS_PER_STEP-1) 
            begin
                tick_cnt <= 0;              // reset counter after full step
                // circular left shift:
                // move MSB to LSB and shift left
                // e.g., 00000001 → 00000010 → ... → 10000000 → 00000001
                led_out <= {led_out[WIDTH-2:0], led_out[WIDTH-1]};
            end 
            else 
            begin
                tick_cnt <= tick_cnt + 1;   // increment counter each clock
            end
        end
        // if enable = 0 → do nothing (hold state)
    end

endmodule
