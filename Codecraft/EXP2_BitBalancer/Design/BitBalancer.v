module bitbalancer (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [3:0] count
);

    integer i;

    always @(posedge clk or posedge reset) 
    begin
        if (reset)
         begin
            count <= 0;
        end
        else begin
            count <= 0;
            for (i = 0; i < 8; i = i + 1)
             begin
                count <= count + in[i];
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
