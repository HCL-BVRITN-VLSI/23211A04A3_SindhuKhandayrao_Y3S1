module bitbalancer (
    input        clk,       // clock input, synchronous operation
    input        reset,     // asynchronous reset, active high
    input  [7:0] in,        // 8-bit input vector to count ones in
    output reg [3:0] count  // 4-bit output count of number of ones in input
);

    integer i;              // loop variable for iterating input bits

    always @(posedge clk or posedge reset) begin
        if (reset) 
        begin
            count <= 0;     // reset count to zero when reset is asserted
        end 
        else 
        begin
            count <= 0;     // initialize count to zero before counting
            for (i = 0; i < 8; i = i + 1) 
            begin
                count <= count + in[i];  // add 1 for every bit set in input
            end
        end
    end
endmodule


/*
module bitbalancer(
  input  [7:0] in,
  output [3:0] count
);
  assign count = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
endmodule
*/
