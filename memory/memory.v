module memory #(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8
)(
    input clk,
    input wr,
    input rd,
    input [AWIDTH-1:0] addr,
    inout [DWIDTH-1:0] data
);

    reg [DWIDTH-1:0] mem [0:(2**AWIDTH)-1];
    reg [DWIDTH-1:0] data_reg;

    always @(posedge clk) begin
        if (wr) begin
            mem[addr] <= data;
        end
        else if (rd) begin
            data_reg <= mem[addr];
        end
    end

    assign data = rd ? data_reg : {DWIDTH{1'bz}};

endmodule