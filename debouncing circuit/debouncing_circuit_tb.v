`timescale 1ns/1ps

module debouncing_circuit_tb;

reg clk;
reg sw;
wire debouncing_bd;

integer i;
parameter TICK_CYCLES = 5;

debouncing_circuit #(.TICK_CYCLE(TICK_CYCLES)) dut (
    .clk(clk),
    .original_sw(sw),
    .debouncing_db(debouncing_bd)
);

initial begin
    clk = 0;
    forever begin
        #10 clk = ~clk;
    end
end

initial begin

    sw = 0;

    #30;

    for (i = 0; i < 20; i = i + 1) begin
        sw = $random % 2;
        #1;
    end

    sw = 1;

    #400;

    if (debouncing_bd != 1) begin
        $display("ERROR - (0 to 1) TEST FAILED");
    end
    else begin
        $display("TEST PASSED - (0 to 1)");
    end

    #1000;

    for (i = 0; i < 20; i = i + 1) begin
        sw = $random % 2;
        #1;
    end

    sw = 0;

    #400;

    if (debouncing_bd != 0) begin
        $display("ERROR - (1 to 0) TEST FAILED");
    end
    else begin
        $display("TEST PASSED - (1 to 0)");
    end

    #500;

    $finish;

end

endmodule