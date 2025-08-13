//METHOD-1
/*Checking LSB of the data_in if it is 1 then odd else even
module evenoddfsm(
    input clk,reset,in_valid,
    input [7:0] data_in,
    output reg even,odd
);

always @(posedge clk or posedge reset)
    begin
        if(reset)
            begin
            even<=1'b0;
            odd<=1'b0;
            end
        else if(in_valid)
            begin
                if (data_in[0]==1'b1)
                    begin
                        even<=1'b0;
                        odd<=1'b1;
                    end
                else
                    begin
                        odd<=1'b0;
                        even<=1'b1;
                    end
            end
    end
endmodule
*/

// METHOD-2
// Using FSM with three states: IDLE,ODD,EVEN


module evenoddfsm (
    input clk,
    input reset,        
    input in_valid,     
    input [7:0] data_in,
    output reg even,
    output reg odd
);

    //3 states
    localparam IDLE = 2'b00;
    localparam EVEN = 2'b01;
    localparam ODD  = 2'b10;

    

    //logic
    always @(*) begin
        next_state = state; // default: hold state
        if (in_valid) begin
            if (data_in[0] == 1'b0)      // LSB = 0 → even
                next_state = EVEN;
            else                         // LSB = 1 → odd
                next_state = ODD;
        end
    end

    //state transitions
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(*) begin
        even = 1'b0;
        odd  = 1'b0;
        case (state)
            EVEN: even = 1'b1;
            ODD:  odd  = 1'b1;
        endcase
    end

endmodule