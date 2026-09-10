`timescale 1ns / 1ps

module tb_light_chaser;

    parameter WIDTH = 10;
    parameter SIM_FREQ = 2_500_000;   // fast for simulation

    reg  clk;
    reg  reset_n;
    reg  hold_n;
    wire [WIDTH-1:0] shift_out;

    
    light_chaser #(
        .INPUT_FREQ_HZ  (50_000_000),
        .OUTPUT_FREQ_HZ (SIM_FREQ),
        .WIDTH          (WIDTH)
    ) dut (
        .clk       (clk),
        .reset_n   (reset_n),
        .hold_n    (hold_n),
        .shift_out (shift_out)
    );

    initial clk = 0;
    always #10 clk = ~clk;

   
    task wait_slow;
        #(1_000_000_000 / SIM_FREQ);
    endtask

    initial begin
        $dumpfile("tb_light_chaser.vcd");
        $dumpvars(0, tb_light_chaser);

        $display("===== Light Chaser TB =====");

       
        reset_n = 0;
        hold_n  = 1;
        #100;
        $display("[%0t] After reset : %b", $time, shift_out);  

   
        reset_n = 1;
        $display("--- Free running ---");
        repeat (WIDTH+5) begin
            wait_slow;
            $display("[%0t] shift_out = %b", $time, shift_out);
        end

  
        $display("--- Hold test ---");
        hold_n = 0;
        $display("[%0t] Hold ON  : %b", $time, shift_out);
        repeat (4) begin
            wait_slow;
            $display("[%0t] Held     : %b", $time, shift_out);  
        end

   
        hold_n = 1;
        $display("--- Resume ---");
        repeat (4) begin
            wait_slow;
            $display("[%0t] Running  : %b", $time, shift_out);
        end

        $display("--- Reset while running ---");
        reset_n = 0;
        #50;
        $display("[%0t] Reset mid : %b", $time, shift_out);  
        reset_n = 1;

        repeat (2) begin
            wait_slow;
            $display("[%0t] before rst: %b", $time, shift_out);
        end

        repeat (WIDTH) begin
            reset_n = 0;
            wait_slow;
            $display("[%0t] after rst: %b", $time, shift_out);
        end

        $display("===== DONE =====");
        $finish;
    end

endmodule