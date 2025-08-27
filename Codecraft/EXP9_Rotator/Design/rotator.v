// -----------------------------------------------------------
// RotatorUnit
// - Parametric-bit rotate register (default 8-bit)
// - On each clk:
//       if !rst_n: clear
//       else if load=1: state <= data_in (highest priority)
//       else if enable=1:
//              if dir=0 -> rotate-left
//              if dir=1 -> rotate-right
//       else hold
// -----------------------------------------------------------
module rotatorunit #(
   parameter int WIDTH = 8
) (
   input  logic              clk,
   input  logic              rst_n,      // async active-low reset
   input  logic              enable,     // gate for rotate
   input  logic              load,       // synchronous load (highest priority)
   input  logic              dir,        // 0: left, 1: right
   input  logic [WIDTH-1:0]  data_in,
   output logic [WIDTH-1:0]  data_out
);

   logic [WIDTH-1:0] state;

   // Async reset, synchronous update
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         state <= '0;  // clear on reset
      end else if (load) begin
         // load has highest priority
         state <= data_in;
      end else if (enable) begin
         if (dir == 1'b0) begin
            // Rotate left: MSB -> LSB
            state <= {state[WIDTH-2:0], state[WIDTH-1]};
         end else begin
            // Rotate right: LSB -> MSB
            state <= {state[0], state[WIDTH-1:1]};
         end
      end
      // else: hold
   end

   assign data_out = state;

endmodule
