`timescale 1ns/1ps

module tb_edge_detector;

    reg  clk;
    reg  reset;
    reg  in;

    wire rise_tick;
    wire fall_tick;
    wire edge_tick;

    edge_detector dut (
        .clk       (clk),
        .reset     (reset),
        .in        (in),
        .rising_tick (rise_tick),
        .falling_tick (fall_tick),
        .edge_tick (edge_tick)
    );

  
    initial clk = 0;
    always #5 clk = ~clk;

    
    initial begin
        $dumpfile("tb_edge_detector.vcd");
        $dumpvars(0, tb_edge_detector);
    end

    
    initial begin
        reset = 1;
        in    = 0;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

       
        @(negedge clk); in = 1;
        repeat (3) @(posedge clk);
        @(negedge clk); in = 0;
        repeat (3) @(posedge clk);

       
        @(negedge clk); in = 1;
        @(negedge clk);
        in = 0;
        repeat (2) @(posedge clk);

       
        @(negedge clk); 
        in = 1;
        repeat (5) @(posedge clk);
        @(negedge clk); in = 0;
        repeat (3) @(posedge clk);

        $finish;
    end

  
    reg rise_seen, fall_seen;
    always @(posedge clk) begin
        if (!reset) begin
            if (rise_tick && rise_seen)
                $display("ERROR @%0t: rise_tick held for more than one cycle", $time);
            if (fall_tick && fall_seen)
                $display("ERROR @%0t: fall_tick held for more than one cycle", $time);
            rise_seen <= rise_tick;
            fall_seen <= fall_tick;
        end else begin
            rise_seen <= 0;
            fall_seen <= 0;
        end
    end

   
    initial begin
        $display(" time reset in state rise fall edge");
        $monitor("%4t   %b     %b   %b     %b    %b    %b",
                  $time, reset, in, dut.state, rise_tick, fall_tick, edge_tick);
    end

endmodule
