module register #(parameter WIDTH=8)(
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] register_data;

always @(posedge clk) begin
    if (rst) begin
        register_data <= 0;
    end
    else if (load) begin
        register_data <= data_in;
    end
end

assign data_out = register_data;

endmodule