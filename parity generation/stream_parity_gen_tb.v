`timescale 1ns/1ps

module parity_tb;

reg clk;
reg reset;
reg serial_in;

wire parity_out;
wire valid;

reg [7:0] data;
integer i;
integer j;

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

task send_byte;
    input [7:0] data;
    begin
        for (j = 7; j >= 0; j = j - 1) begin
            @(negedge clk);
            serial_in = data[j];
        end
    end
endtask

initial begin
    reset = 1;
    serial_in = 0;

    #10;
    reset = 0;

    for (i = 0; i < 256; i = i + 1) begin
        data = i[7:0];
        send_byte(data);
    end

    #20;
    $finish;
end

endmodule