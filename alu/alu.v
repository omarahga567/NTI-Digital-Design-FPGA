module alu(in_a, in_b, opcode, a_is_zero, alu_out);
  parameter WIDTH=8;
  input  [WIDTH-1:0] in_a ;
  input  [WIDTH-1:0] in_b ;
  input  [2:0] opcode ;
  output  reg a_is_zero ;
  output reg [WIDTH-1:0] alu_out   ;

  always @(*) begin
    if (in_a == {WIDTH{1'b0}}) begin
      a_is_zero = 1'b1;
    end else begin
        a_is_zero = 1'b0;
    end
      case (opcode)
        3'b000: alu_out = in_a;
        3'b001: alu_out = in_a;
        3'b010: alu_out = in_a + in_b;
        3'b011: alu_out = in_a & in_b;
        3'b100: alu_out = in_a ^ in_b;
        3'b101: alu_out = in_b;
        3'b110: alu_out = in_a;
        3'b111: alu_out = in_a;
        default: alu_out = {WIDTH{1'bx}};
      endcase

    
  end
    
endmodule