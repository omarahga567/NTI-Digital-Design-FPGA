module shift_register#(
    parameter  WIDTH = 10
)(
    input clk,
    input reset_n,
    input hold_n,
    output reg [WIDTH-1:0] shift_out
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_out <= {1'b1, {(WIDTH-1){1'b0}}};
        end
        else if (!hold_n) begin
            shift_out <= shift_out;
        end
        else begin
            shift_out <= {shift_out[0], shift_out[WIDTH-1:1]};
        end
    end
    
endmodule