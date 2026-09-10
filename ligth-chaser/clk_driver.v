module clk_divider #(
    parameter  INPUT_FREQ_HZ  = 50_000_000,
    parameter  OUTPUT_FREQ_HZ = 8
)(
    input   clk,
    input   reset_n,
    output reg clk_out
);

    localparam  DIV_COUNT =
        INPUT_FREQ_HZ / (2 * OUTPUT_FREQ_HZ);

    localparam  COUNTER_WIDTH = $clog2(DIV_COUNT);

    reg  [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_out <= 1'b0;
        end
        else if (counter == DIV_COUNT-1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end

endmodule