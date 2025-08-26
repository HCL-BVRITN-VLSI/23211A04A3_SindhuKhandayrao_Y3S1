module debouncerlite #(
    parameter N = 5              // number of stable cycles required
)(
    input  wire clk,             // clock
    input  wire rst_n,           // async active-low reset
    input  wire noisy_in,        // noisy switch input
    output reg  debounced        // clean output
);

    // synchronizer (2 flip-flops)
    reg sync1, sync2;

    // counter to check stability
    reg [2:0] count;  //0-5 max of 3 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync1     <= 0;
            sync2     <= 0;
            debounced <= 0;
            count     <= 0;
        end else begin
            // step 1: synchronize the input
            sync1 <= noisy_in;
            sync2 <= sync1;

            // step 2: compare with current debounced output
            if (sync2 == debounced) begin
                count <= 0;   // same level → reset counter
            end else begin
                count <= count + 1;   // different → count
                if (count == N-1) begin
                    debounced <= sync2; // stable long enough → update
                    count     <= 0;
                end
            end
        end
    end

endmodule
