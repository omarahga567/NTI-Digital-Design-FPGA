module counter #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rst,
    input                  load,
    input                  enab,
    input  [WIDTH-1:0]     cnt_in,
    output [WIDTH-1:0]     cnt_out
);

    reg [WIDTH-1:0] cnt_out_reg;

    always @(posedge clk) begin
        if (rst) begin
            cnt_out_reg <= {WIDTH{1'b0}};
        end
        else if (load) begin
            cnt_out_reg <= cnt_in;
        end
        else if (enab) begin
            cnt_out_reg <= cnt_out_reg + 1'b1;
        end
    end

    assign cnt_out = cnt_out_reg;

endmodule