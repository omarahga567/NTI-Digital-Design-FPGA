module rising_edge_detector_tb;

    reg clk;
    reg rest;
    reg In;
    wire tick;


    rising_edge_detector dut (
        .clk(clk),
        .rest(rest),
        .In(In),
        .tick(tick)
    );
    initial begin
        clk=0;
        forever #5 clk = ~clk; 
    end



    task check_tick;
        input expected_tick;
        begin
            @(negedge clk); 
            if (tick !== expected_tick) begin
                $display("Test failed at time %t: Expected tick = %b, Got tick = %b", $time, expected_tick, tick);
                $finish;
            end else begin
                $display("Test passed at time %t: tick = %b, Input = %b", $time, tick, In);
            end
        end
        endtask

    initial begin
        @(posedge clk);
        rest = 1;
        In   = 0;
        #1;
        @(negedge clk);

        if (tick !== 0) begin
            $display("TEST FAILED: Reset did not produce tick=0");
        end
        else begin
            $display("RESET TEST PASSED");
        end

        rest = 0;
          @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 1;

        @(posedge clk);
        check_tick(1);



          @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);
        
          In = 0;

        @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        In = 1;

        @(posedge clk);
        check_tick(1);

        @(posedge clk);
        check_tick(0);



         @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);

        @(posedge clk);
        check_tick(0);



        In = 0;

        @(posedge clk);
        check_tick(0);

        In = 1;

        @(posedge clk);
        check_tick(1);

        @(posedge clk);
        check_tick(0);

     $display("\n========================================");
            $display("          TEST PASSED");
            $display("========================================");


            $finish;

    end


    
endmodule