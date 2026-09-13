module parity (
    input clk,
    input reset,
    input serial_in,
    output parity_out,
    output valid
);

reg [7:0] serial_data;
reg [2:0] counter;

always @(posedge clk ) begin
    if(reset) begin
        serial_data<=8'h0;
        counter<=0;
    end else begin
        serial_data<={serial_data[6:0],serial_in};
        counter<=counter+1;
    end
end

assign parity_out = parity_cal(serial_data);
assign valid = valid_calc(counter);

function parity_cal;
    input [7:0] data_register;
    begin
        parity_cal = ^data_register;
    end
endfunction

function  valid_calc;
   input [2:0] count;
   if (count==3'b111) begin
     valid_calc=1;
   end else begin
    valid_calc=0;
   end
    
endfunction    
endmodule