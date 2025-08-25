module graycoder #(
  parameter N = 4 // width of binary input
)(
  input wire clk,
  input wire [N-1:0] bin_in, // binary input
  output reg [N-1:0] gray_out //gray code output
);

  integer i; // used for loop iteration

  always @(posedge clk)
    begin
    // MSB of gray code is same as MSB of binary
    gray_out[N-1] <= bin_in[N-1];
    // for all remaining bits:
    // gray[i] = bin_in[i] ^ bin_in[i+1]
    for (i = N-2; i >= 0; i = i-1) 
      begin
        gray_out[i] <= bin_in[i] ^ bin_in[i+1];
      end
  end
endmodule
