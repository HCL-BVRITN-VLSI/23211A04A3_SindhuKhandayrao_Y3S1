module seqcheck #(parameter int WINDOW = 5, THRESHOLD = 3) (
    input  logic clk,
    input  logic rst_n,
    input  logic in_sig,
    output logic hit
);

    // 2FF Synchronizer
    // Synchronize input and detect rising edges
    logic sync_ff1, sync_ff2, sync_prev;
    logic rise_detected;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1   <= 1'b0;
            sync_ff2   <= 1'b0;
            sync_prev  <= 1'b0;
        end else begin
            sync_ff1   <= in_sig;
            sync_ff2   <= sync_ff1;
            sync_prev  <= sync_ff2;
        end
    end

    // Rising edge detection
    assign rise_detected = sync_ff2 & ~sync_prev;

    // Ring Buffer + Running Sum 
    // Store last WINDOW rises and maintain a running sum
    logic [WINDOW-1:0] edge_history;    // ring buffer of recent rises
    logic [2:0] running_sum;            // sum of rises in window
    logic [2:0] buffer_index;           // current position in ring buffer
    logic threshold_prev;                // previous threshold status

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_history   <= 0;
            running_sum    <= 0;
            buffer_index   <= 0;
            threshold_prev <= 1'b0;
            hit            <= 1'b0;
        end else begin
            // Update running sum: remove oldest, add new rise
            running_sum <= running_sum - edge_history[buffer_index] + rise_detected;

            // Store the current rise in the ring buffer
            edge_history[buffer_index] <= rise_detected;

            // Move to next position in the ring buffer
            buffer_index <= (buffer_index == WINDOW-1) ? 0 : buffer_index + 1;

            // Generate a 1-cycle pulse when threshold crossed
            hit <= ((running_sum - edge_history[buffer_index] + rise_detected) >= THRESHOLD)
                   & ~threshold_prev;

            // Save previous threshold state for next cycle
            threshold_prev <= ((running_sum - edge_history[buffer_index] + rise_detected) >= THRESHOLD);
        end
    end

endmodule
