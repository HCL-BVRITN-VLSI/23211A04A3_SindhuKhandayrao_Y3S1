// Code your design here
module PulseTracer # (
  parameter FILTER_LEN=3 //number of cycles required to be considered as a high pulse
)(input wire clk, //clock is a continous signal hence it is declared as a wire
  input wire rst_n, //since reset is active low pin that is its active when it's value is zero
  input wire noisy_in,//the noisy input signal from which high pulses should be detected
  output reg pulse_out //for output pulse
 );
  reg [FILTER_LEN-1:0] filter_reg; //it is a register(memory) which holds FILTER_LEN number of high or low pulses to detect the high pulse
  reg debounced; //steady version of noisy input
  reg prev_debounced; //to store previously debounced values

  always@(posedge clk or negedge rst_n) //when clock is high or reset is active
    begin
      if (!rst_n) //if rst_n==0,since it is active low pin
        begin
          //initialize all values to zero when the signal is reset
          debounced<=0; 
          prev_debounced<=0;
          filter_reg<=0;
          pulse_out <=0;
          //non-blocking assignment for parallel allocation or since we are in always block-sequential circuit
        end
      else
        begin
          filter_reg={filter_reg[FILTER_LEN-2:0],noisy_in};//store the phase of the noisy input either low or high

          // update debounced based on new filter_reg value
          if (&filter_reg)//if all the bits are hgh in the present cyckle(depends on filter length)
            begin
              debounced<=1'b1;
            end
          else if (~|filter_reg) //if all the bits in the present cycle are low its considered to be low (product(or) of all 0's gives 0 so if if its low
            begin 
              debounced<=1'b0;
            end
          // if filter_reg mixed, keep debounced as is 

          pulse_out <= debounced & (~prev_debounced);//to identify when it is goin from zero to one
          prev_debounced <= debounced;//if no change in noise
        end
    end
endmodule