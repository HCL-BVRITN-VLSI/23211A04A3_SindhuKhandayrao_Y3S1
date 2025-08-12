/* this can be done in 2 methods

METHOD-1
by reordering and using concatenation operator
out = {in[3:0], in[7:4]};
// it provides 0 delay, uses 0 memory elements, so this method is efficient 

METHOD-2
by masking the upper and lower nibbles separately
for example let's consider the number to be
in = 1101 0101
upper nibble mask (perform AND operation to get only the required part) with 1111 0000 
and lower nibble mask with 0000 1111
then move the lower nibble bits up by moving to left that is left shift by 4 bits
and similarly move the upper nibble bits by moving to right that is right shift by 4 bits
here's an outline of the implementation:

lower = in & 0000_1111;
upper = in & 1111_0000;
out = (lower << 4) | (upper >> 4);

this is not efficient in terms of memory, speed, and simplicity.

so choosing method-1 makes a lot more sense when working with hardware
*/
module nibbleswapper(clk,reset,in,swap_en,out);
input clk,reset;
input [7:0] in;
input swap_en;
output reg [7:0] out;
always @(posedge clk or posedge reset)
begin
    if (reset)
        begin
            out <= 8'h 00;
        end
    else if (swap_en)
        begin
            out <= {in[3:0], in[7:4]}; //only when swap is eanbled then swap should happen
            
        end
    else
        begin 
            out<=out;
        end
end
endmodule

