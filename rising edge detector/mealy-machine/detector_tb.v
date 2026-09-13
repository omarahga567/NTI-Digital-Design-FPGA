`timescale 1ns/1ps

module rising_edge_detector_tb;

    reg clk;
    reg rest;
    reg In;

    wire tick;

    integer errors;

    rising_edge_detector dut (
        .clk(clk),
        .rest(rest),
        .In(In),
        .tick(tick)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_tick;
        input expected;
        begin
            #1;

            if (tick !== expected) begin
                $display("TEST FAILED: time=%0t In=%b tick=%b expected=%b",
                         $time, In, tick, expected);
                errors = errors + 1;
            end
            else begin
                $display("TEST PASSED: time=%0t In=%b tick=%b",
                         $time, In, tick);
            end
        end
    endtask

    initial begin

        errors = 0;

        rest = 1;
        In   = 0;

        #1;
        check_tick(0);

        rest = 0;

        In = 0;
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 1;
        check_tick(1);

        @(posedge clk);
        check_tick(0);

        In = 1;
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 0;
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 1;
        check_tick(1);

        @(posedge clk);
        check_tick(0);

        In = 0;
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 1;
        check_tick(1);

        @(posedge clk);
        check_tick(0);

        In = 1;
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        if (errors == 0) begin
            $display("\n========================================");
            $display("          TEST PASSED");
            $display("========================================");
        end
        else begin
            $display("\n========================================");
            $display("          TEST FAILED");
            $display("Errors = %0d", errors);
            $display("========================================");
        end

        $finish;

    end

endmodule