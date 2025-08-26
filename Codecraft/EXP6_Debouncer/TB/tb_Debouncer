`timescale 1ns/1ps
// ---------------------------------------------------------
// DebouncerLite
// - 2FF synchronizer on noisy_in
// - Output toggles only after N consecutive cycles where
//   sync2 != debounced (i.e., new level is stable)
// ---------------------------------------------------------
//module debouncerlite #(
//    parameter int N = 5
// ) (
//    input  logic clk,
//    input  logic rst_n,      // async active-low
//    input  logic noisy_in,
//    output logic debounced
// );
module tb_debouncerlite;

    localparam int N      = 5;
    localparam int CLK_NS = 10;

    logic clk, rst_n, noisy_in;
    logic debounced;

    debouncerlite #(.N(N)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_in(noisy_in),
        .debounced(debounced)
    );

    // Clock
    initial clk = 1'b0;
    always #(CLK_NS/2) clk = ~clk;

    // VCD
    initial begin
        $dumpfile("debouncerlite_tb.vcd");
        $dumpvars(0, tb_debouncerlite);
    end

    // ---------------- Reference Model ----------------
    logic sync1_m, sync2_m, debounced_ref;
    localparam int CW = (N <= 2) ? 1 : $clog2(N);
    logic [CW:0] cnt_ref;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync1_m       <= 1'b0;
            sync2_m       <= 1'b0;
            debounced_ref <= 1'b0;
            cnt_ref       <= '0;
        end else begin
            sync1_m <= noisy_in;
            sync2_m <= sync1_m;

            if (sync2_m == debounced_ref) begin
                cnt_ref <= '0;
            end else begin
                if (cnt_ref >= (N-1)) begin
                    debounced_ref <= sync2_m;
                    cnt_ref       <= '0;
                end else begin
                    cnt_ref <= cnt_ref + 1'b1;
                end
            end
        end
    end

    // ---------------- Checker ----------------
    int errors;  // no initializer here
    int tests;   // test counter (only driven in initial)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            errors <= 0;
        end else begin
            if (debounced !== debounced_ref) begin
                errors <= errors + 1;
                $display("ERROR t=%0t: DUT debounced=%0b, REF=%0b",
                         $time, debounced, debounced_ref);
            end
        end
    end

    // ---------------- Stimulus helpers ----------------
    task automatic wait_cycles(input int c);
        repeat (c) @(posedge clk);
    endtask

    task automatic drive_level(input logic lvl, input int cycles);
        noisy_in = lvl;
        wait_cycles(cycles);
    endtask

    task automatic bounce_pattern(input logic base,
                                  input int length,
                                  input bit pattern []);
        for (int i = 0; i < length; i++) begin
            noisy_in = pattern[i];
            @(posedge clk);
        end
        noisy_in = base;
    endtask

    // Fixed bounce patterns
    bit pattern1 [0:4] = '{1,0,1,0,1};
    bit pattern2 [0:5] = '{0,1,0,1,0,0};

    // ---------------- Test Plan ----------------
    initial begin
        tests   = 0;
        noisy_in = 1'b0;
        rst_n    = 1'b0;
        wait_cycles(4);
        rst_n    = 1'b1;
        wait_cycles(2);

        $display("\nCASE 1: Short high glitch (<N)");
        drive_level(1'b1, N-3);
        drive_level(1'b0, 5);
        tests++;

        $display("\nCASE 2: Exactly N-1 high then drop");
        drive_level(1'b1, N-1);
        drive_level(1'b0, 6);
        tests++;

        $display("\nCASE 3: Bouncy then stable HIGH (>=N)");
        bounce_pattern(1'b1, $size(pattern1), pattern1);
        drive_level(1'b1, N+5);
        tests++;

        $display("\nCASE 4: Bouncy then stable LOW (>=N)");
        bounce_pattern(1'b0, $size(pattern2), pattern2);
        drive_level(1'b0, N+5);
        tests++;

        $display("\nCASE 5: Spaced spikes");
        repeat (4) begin
            drive_level(1'b1, 1);
            drive_level(1'b0, 3);
        end
        tests++;

        $display("\nCASE 6: Clean press long");
        drive_level(1'b1, N+8);
        tests++;

        $display("\nCASE 7: Clean release long");
        drive_level(1'b0, N+8);
        tests++;

        $display("\nCASE 8: Rapid toggle");
        for (int i = 0; i < 20; i++) begin
            noisy_in = ~noisy_in;
            @(posedge clk);
        end
        drive_level(1'b0, 5);
        tests++;

        $display("\nCASE 9: Two valid presses");
        drive_level(1'b1, N+5);
        drive_level(1'b0, N+5);
        drive_level(1'b1, N+5);
        tests++;

        $display("\nCASE 10: Two valid releases");
        drive_level(1'b0, N+5);
        drive_level(1'b1, N-2);
        drive_level(1'b0, N+5);
        tests++;

        $display("\nCASE 11: Reset");
        drive_level(1'b1, N+3);
        rst_n = 0; @(posedge clk); rst_n = 1;
        drive_level(1'b0, 6);
        tests++;

        $display("\nCASE 12: Post-reset press");
        drive_level(1'b1, N+5);
        tests++;

        $display("\n--------------------------------");
        $display("Tests issued   : %0d", tests);
        $display("Errors detected: %0d", errors);
        $display("--------------------------------\n");

        wait_cycles(5);
        $finish;
    end

endmodule
