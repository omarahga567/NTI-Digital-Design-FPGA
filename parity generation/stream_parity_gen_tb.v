`timescale 1ns/1ps

module parity_tb;

reg clk;
reg reset;
reg serial_in;

wire parity_out;
wire valid;

parity dut (
    .clk(clk),
    .reset(reset),
    .serial_in(serial_in),
    .parity_out(parity_out),
    .valid(valid)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    serial_in = 0;

    #10;
    reset = 0;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;

    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;

    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;

    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;

    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 1;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;
    @(negedge clk); serial_in = 0;

    #20;
    $finish;
end

endmodule