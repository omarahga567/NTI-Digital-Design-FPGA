module light_chaser #(
    parameter  INPUT_FREQ_HZ  = 50_000_000,
    parameter  OUTPUT_FREQ_HZ = 8,
    parameter  WIDTH = 10
)(
    input  clk,
    input  reset_n,
    input  hold_n,
    output  [WIDTH-1:0] shift_out
);

    wire slow_clk;

    clk_divider #(
        .INPUT_FREQ_HZ(INPUT_FREQ_HZ),
        .OUTPUT_FREQ_HZ(OUTPUT_FREQ_HZ)
    ) u_clk_divider (
        .clk     (clk),
        .reset_n (reset_n),
        .clk_out (slow_clk)
    );

    shift_register #(
        .WIDTH(WIDTH)
    ) u_shift_register (
        .clk       (slow_clk),
        .reset_n   (reset_n),
        .hold_n    (hold_n),
        .shift_out (shift_out)
    );

endmodule