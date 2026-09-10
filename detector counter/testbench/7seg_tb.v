`timescale 1ns/1ps

module decoder_7seg_tb;

    reg [3:0] rising_count;
    reg [3:0] falling_count;
    reg [3:0] total_count;
    reg reset;

    wire [6:0] R;
    wire [6:0] R_C;
    wire [6:0] F;
    wire [6:0] F_C;
    wire [6:0] T;
    wire [6:0] T_C;

    decoder_7seg dut (
        .rising_count(rising_count),
        .falling_count(falling_count),
        .total_count(total_count),
        .reset(reset),
        .R(R),
        .R_C(R_C),
        .F(F),
        .F_C(F_C),
        .T(T),
        .T_C(T_C)
    );

    initial begin

       
        reset = 1;
        rising_count = 0;
        falling_count = 0;
        total_count = 0;

        #10;

        $display("RESET:");
        $display("R=%b R_C=%b F=%b F_C=%b T=%b T_C=%b",
                 R, R_C, F, F_C, T, T_C);

        
        reset = 0;

        // Test 0
        rising_count = 0;
        falling_count = 0;
        total_count = 0;
        #10;

        $display("0: R_C=%b F_C=%b T_C=%b",
                 R_C, F_C, T_C);

        
        rising_count = 1;
        falling_count = 1;
        total_count = 1;
        #10;

        $display("1: R_C=%b F_C=%b T_C=%b",
                 R_C, F_C, T_C);

        
        rising_count = 5;
        falling_count = 9;
        total_count = 4'hA;
        #10;

        $display("5/9/A: R_C=%b F_C=%b T_C=%b",
                 R_C, F_C, T_C);

        rising_count = 4'hF;
        falling_count = 4'hE;
        total_count = 4'hD;
        #10;

        $display("F/E/D: R_C=%b F_C=%b T_C=%b",
                 R_C, F_C, T_C);

       
        $display("--------------------------------");
        $display("Testing all 7-segment values");

        for (integer i = 0; i < 16; i = i + 1) begin

            rising_count = i;
            falling_count = i;
            total_count = i;

            #5;

            $display("Count = %h | R_C=%b | F_C=%b | T_C=%b",
                     i, R_C, F_C, T_C);
        end

        $display("--------------------------------");
        $display("7-SEG TEST FINISHED");

        $finish;

    end

endmodule