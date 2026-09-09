module gray2sevenseg #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray_in,
    output [6:0]       seg_out
);

    wire [WIDTH-1:0] binary_out;

    
    gray2binary #(
        .WIDTH(WIDTH)
    ) gray2binary_inst (
        .gray_in   (gray_in),
        .binary_out(binary_out)
    );

    
    binary2sevenseg decoder_inst (
        .binary_in(binary_out[3:0]),
        .seg_out  (seg_out)
    );

endmodule
