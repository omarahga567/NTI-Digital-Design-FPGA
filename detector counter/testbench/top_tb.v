
`timescale 1ns/1ps

module top_tb;

    reg clk;
    reg reset;
    reg in;

    wire [6:0] R;
    wire [6:0] F;
    wire [6:0] T;
    wire [6:0] R_C;
    wire [6:0] F_C;
    wire [6:0] T_C;

   
    integer expected_rise;
    integer expected_fall;
    integer expected_total;

    integer errors;

    top dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .R(R),
        .F(F),
        .T(T),
        .R_C(R_C),
        .F_C(F_C),
        .T_C(T_C)
    );

    always #5 clk = ~clk;


   
    task check_counts;
        begin

            if (dut.rise_count !== expected_rise[3:0]) begin
                $display("ERROR: Rise count mismatch!");
                $display("       Expected = %0d", expected_rise);
                $display("       Actual   = %0d", dut.rise_count);
                errors = errors + 1;
            end

            if (dut.fall_count !== expected_fall[3:0]) begin
                $display("ERROR: Fall count mismatch!");
                $display("       Expected = %0d", expected_fall);
                $display("       Actual   = %0d", dut.fall_count);
                errors = errors + 1;
            end

            if (dut.total_count !== expected_total[3:0]) begin
                $display("ERROR: Total count mismatch!");
                $display("       Expected = %0d", expected_total);
                $display("       Actual   = %0d", dut.total_count);
                errors = errors + 1;
            end

            if ((dut.rise_count === expected_rise[3:0]) &&
                (dut.fall_count === expected_fall[3:0]) &&
                (dut.total_count === expected_total[3:0])) begin

                $display("PASS: Rise=%0d Fall=%0d Total=%0d",
                         dut.rise_count,
                         dut.fall_count,
                         dut.total_count);
            end

        end
    endtask


    
    task rising_edge;
        begin

            in = 0;

            @(negedge dut.clk_out);

            in = 1;

            @(negedge dut.clk_out);
            @(negedge dut.clk_out);

            expected_rise = expected_rise + 1;
            expected_total = expected_total + 1;

            check_counts;

        end
    endtask


    
    task falling_edge;
        begin

            in = 1;

        
            @(negedge dut.clk_out);

            in = 0;

            
            @(negedge dut.clk_out);
            @(negedge dut.clk_out);

            expected_fall = expected_fall + 1;
            expected_total = expected_total + 1;

            check_counts;

        end
    endtask


    
    initial begin

        clk = 0;
        reset = 1;
        in = 0;

        expected_rise = 0;
        expected_fall = 0;
        expected_total = 0;

        errors = 0;


        

        #20;

        if ((dut.rise_count !== 0) ||
            (dut.fall_count !== 0) ||
            (dut.total_count !== 0)) begin

            $display("ERROR: Counters are not zero after reset!");
            errors = errors + 1;

        end
        else begin
            $display("PASS: Reset");
        end

        reset = 0;


      
        $display("");
        $display("TEST 1: Rising edge");

        rising_edge;


       

        $display("");
        $display("TEST 2: Falling edge");

        falling_edge;


      

        $display("");
        $display("TEST 3: Rising edge");

        rising_edge;


        

        $display("");
        $display("TEST 4: Falling edge");

        falling_edge;


    

        $display("");
        $display("TEST 5: Long HIGH input");

        in = 0;
        @(negedge dut.clk_out);

        in = 1;

        repeat (10)
            @(negedge dut.clk_out);

        expected_rise = expected_rise + 1;
        expected_total = expected_total + 1;

        check_counts;


     

        $display("");
        $display("TEST 6: Long LOW input");

        in = 0;

        repeat (10)
            @(negedge dut.clk_out);

        expected_fall = expected_fall + 1;
        expected_total = expected_total + 1;

        check_counts;



        $display("");
        $display("========================================");
        $display("FINAL RESULT");
        $display("========================================");

        $display("Expected Rise  = %0d", expected_rise);
        $display("Actual Rise    = %0d", dut.rise_count);

        $display("Expected Fall  = %0d", expected_fall);
        $display("Actual Fall    = %0d", dut.fall_count);

        $display("Expected Total = %0d", expected_total);
        $display("Actual Total   = %0d", dut.total_count);

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("***** TEST PASSED *****");
        end
        else begin
            $display("***** TEST FAILED *****");
            $display("Number of errors = %0d", errors);
        end

        $display("========================================");

        $finish;

    end

endmodule

