module memory_test;

    localparam AWIDTH = 5;
    localparam DWIDTH = 8;

    reg                  clk;
    reg                  wr;
    reg                  rd;
    reg  [AWIDTH-1:0]    addr;
    wire [DWIDTH-1:0]    data;
    reg  [DWIDTH-1:0]    rdata;


    reg [AWIDTH-1:0] address;
    reg [DWIDTH-1:0] test_data;

    assign data = rdata;

    memory #(
        .AWIDTH(AWIDTH),
        .DWIDTH(DWIDTH)
    ) memory_inst (
        .clk  (clk),
        .wr   (wr),
        .rd   (rd),
        .addr (addr),
        .data (data)
    );



    task write_memory;
        input [AWIDTH-1:0] address_in;
        input [DWIDTH-1:0] data_in;

        begin
            wr    = 1;
            rd    = 0;
            addr  = address_in;
            rdata = data_in;

            $display("Writing addr=%b data=%b",
                     address_in, data_in);

            @(negedge clk);
        end
    endtask



    task read_memory;
        input [AWIDTH-1:0] address_in;

        begin
            wr    = 0;
            rd    = 1;
            addr  = address_in;
            rdata = 'bz;

            $display("Reading addr=%b", address_in);

            @(negedge clk);
        end
    endtask



    task expect;
        input [DWIDTH-1:0] exp_data;

        begin
            if (data !== exp_data) begin
                $display("TEST FAILED");
                $display("At time %0d addr=%b data=%b",
                         $time, addr, data);
                $display("data should be %b", exp_data);
                $finish;
            end
            else begin
                $display("At time %0d addr=%b data=%b",
                         $time, addr, data);
            end
        end
    endtask


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin : TEST

        @(negedge clk);

        write_memory(5'h00, 8'hFF);
        write_memory(5'h1F, 8'hA0);

        read_memory(5'h00);
        expect(8'hFF);

        read_memory(5'h1F);
        expect(8'hA0);


        $display("Writing ascending data to descending addresses");

        address  = 5'h1F;
        test_data = 8'h00;

        while (address) begin
            write_memory(address, test_data);

            address   = address - 1'b1;
            test_data = test_data + 1'b1;
        end


        $display("Reading ascending data from descending addresses");

        address   = 5'h1F;
        test_data = 8'h00;

        while (address) begin
            read_memory(address);
            expect(test_data);

            address   = address - 1'b1;
            test_data = test_data + 1'b1;
        end

        $display("TEST PASSED");
        $finish;

    end

endmodule