`timescale 1ns/1ps

module edge_counter_tb;

    reg clk;
    reg reset;
    reg rising_tick;
    reg falling_tick;

    wire [3:0] rise_count;
    wire [3:0] fall_count;
    wire [3:0] total_count;

    edge_counter dut (
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .clk(clk),
        .reset(reset),
        .rise_count(rise_count),
        .fall_count(fall_count),
        .total_count(total_count)
    );

    
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        rising_tick = 0;
        falling_tick = 0;

    
        #12;
        reset = 0;

       
        @(negedge clk);
        rising_tick = 1;

        @(negedge clk);
        rising_tick = 0;

        
        @(negedge clk);
        rising_tick = 1;

        @(negedge clk);
        rising_tick = 0;

        @(negedge clk);
        falling_tick = 1;

        @(negedge clk);
        falling_tick = 0;

      
        @(negedge clk);
        falling_tick = 1;

        @(negedge clk);
        falling_tick = 0;

      
        #20;

        $display("--------------------------------");
        $display("rise_count  = %0d", rise_count);
        $display("fall_count  = %0d", fall_count);
        $display("total_count = %0d", total_count);
        $display("--------------------------------");

        if (rise_count == 2 &&
            fall_count == 2 &&
            total_count == 4) begin

            $display("TEST PASSED");

        end else begin

            $display("TEST FAILED");

        end

        $finish;
    end

endmodule