module gray2sevenseg_test;

    localparam WIDTH = 4;

    reg  [WIDTH-1:0] gray_in;
    wire [6:0]       seg_out;

    gray2sevenseg #(
        .WIDTH(WIDTH)
    ) dut (
        .gray_in(gray_in),
        .seg_out(seg_out)
    );


    task expect;
        input [3:0] expected_gray;
        input [6:0] expected_seg;

        begin

            gray_in = expected_gray;

            #1;

            if (seg_out !== expected_seg) begin

                $display("TEST FAILED");

                $display(
                    "Time=%0t Gray=%b Seg=%b Expected=%b",
                    $time,
                    gray_in,
                    seg_out,
                    expected_seg
                );

                $finish;

            end

            else begin

                $display(
                    "PASS: Time=%0t Gray=%b Seg=%b",
                    $time,
                    gray_in,
                    seg_out
                );

            end

        end
    endtask


    initial begin


        expect(4'b0000, 7'b1000000);

        expect(4'b0001, 7'b1111001);

        expect(4'b0011, 7'b0100100);

        expect(4'b0010, 7'b0110000);

        expect(4'b0110, 7'b0011001);

        expect(4'b0111, 7'b0010010);

        expect(4'b0101, 7'b0000010);

        expect(4'b0100, 7'b1111000);

        expect(4'b1100, 7'b0000000);

        expect(4'b1101, 7'b0010000);

        expect(4'b1111, 7'b0001000);

        expect(4'b1110, 7'b0000011);

        expect(4'b1010, 7'b1000110);

        expect(4'b1011, 7'b0100001);
E
        expect(4'b1001, 7'b0000110);

        expect(4'b1000, 7'b0001110);


        $display("");
        $display("==============================");
        $display("       TEST PASSED");
        $display("==============================");

        $finish;

    end

endmodule