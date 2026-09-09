module gray2binary #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray_in,
    output [WIDTH-1:0] binary_out
);

    genvar i;

    assign binary_out[WIDTH-1] = gray_in[WIDTH-1];

    generate
        for (i = WIDTH-2; i >= 0; i = i - 1) begin 
            assign binary_out[i] = binary_out[i+1] ^ gray_in[i];
        end
    endgenerate

endmodule
