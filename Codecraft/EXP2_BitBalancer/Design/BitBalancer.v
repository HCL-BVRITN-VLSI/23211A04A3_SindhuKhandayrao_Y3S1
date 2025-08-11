module bitbalancer (clk,reset,in,count);
    
    input [7:0]in;
    input clk,reset;
    output reg [3:0]count;
   
    integer i;
  always @(posedge clk or posedge reset) begin
    if (reset)                     //when input is reset,count should be 0
                count <= 0;
            else begin                   
                count <= 0;
              for (i = 0; i < 8; i = i + 1)
                  count = count + in[i];        //adds the total number of ones ,everytime one is detected  it is added to count
              
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
