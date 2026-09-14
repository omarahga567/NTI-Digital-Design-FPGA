module counter_f #(
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

 
    function [WIDTH-1:0] next_count;
        input [WIDTH-1:0] current_count;
        input             enable;

        begin
            if (enable)
                next_count = current_count + 1'b1;
            else
                next_count = current_count;
        end
    endfunction

    always @(posedge clk) begin
        if (rst)
            cnt_out_reg <= {WIDTH{1'b0}};
        else if (load)
            cnt_out_reg <= cnt_in;
        else
            cnt_out_reg <= next_count(cnt_out_reg, enab);
    end

    assign cnt_out = cnt_out_reg;

endmodule