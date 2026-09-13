module controller(

    input [2:0] phase,
    input [2:0] opcode,
    input zero,

    output reg sel,
    output reg rd,
    output reg Id_ir,
    output reg halt,
    output reg Inc_pc,
    output reg Ld_ac,
    output reg Ld_pc,
    output reg wr,
    output reg data_en

);

always @(*) begin
    $display("DUT: phase=%b opcode=%b zero=%b", phase, opcode, zero);

    case (phase)

        // INSTRUCTION ADDRESS
        3'b000: begin
            sel = 1;
             rd      = 0;
             Id_ir   = 0;
             halt    = 0;
             Inc_pc  = 0;
             Ld_ac   = 0;
             Ld_pc   = 0;
             wr      = 0;
             data_en = 0;
        end

        // INSTRUCTION FETCH
        3'b001: begin
            sel = 1;
            rd  = 1;
            Id_ir   = 0;
             halt    = 0;
             Inc_pc  = 0;
             Ld_ac   = 0;
             Ld_pc   = 0;
             wr      = 0;
             data_en = 0;
        end

        // INSTRUCTION LOAD
        3'b010: begin
            sel   = 1;
            rd    = 1;
            Id_ir = 1;
            halt    = 0;
             Inc_pc  = 0;
             Ld_ac   = 0;
             Ld_pc   = 0;
             wr      = 0;
             data_en = 0;
        end

        // IDLE
        3'b011: begin
            sel   = 1;
            rd    = 1;
            Id_ir = 1;
            halt    = 0;
             Inc_pc  = 0;
             Ld_ac   = 0;
             Ld_pc   = 0;
             wr      = 0;
             data_en = 0;
        end

        // OP ADDRESS
        3'b100: begin
            sel = 0;
            rd  = 0;
            Id_ir = 0;
            halt   = (opcode == 3'b000);
            Inc_pc = 1;
            Ld_ac   = 0;
            Ld_pc   = 0;
            wr      = 0;
            data_en = 0;
        end

        // OP FETCH
        3'b101: begin
            sel = 0;
            rd = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101)? 1 : 0;
            Id_ir = 0;
            halt =0;
            Inc_pc = 0;
            Ld_ac   = 0;
            Ld_pc   = 0;
            wr      = 0;
            data_en = 0;
        end

        // ALU OP
        3'b110: begin
            sel = 0;
            rd = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101)? 1 : 0;
            Id_ir=0;
            halt=0;

            Inc_pc = (opcode == 3'b001 && zero)? 1 : 0;
            Ld_ac=0;
            Ld_pc = (opcode == 3'b111)? 1 : 0;
            wr=0;
            data_en = (opcode == 3'b110)? 1 : 0;
        end

        
        3'b111: begin
            sel = 0;
            rd= (opcode == 3'b010 ||opcode == 3'b011 ||opcode == 3'b100 ||opcode == 3'b101) ?1:0;
            Id_ir=0;
            halt=0;
            Inc_pc=0;
            Ld_ac = (opcode == 3'b010 ||opcode == 3'b011 ||opcode == 3'b100 ||opcode == 3'b101) ?1:0;
            Ld_pc = (opcode == 3'b111)? 1 : 0;
            wr = (opcode == 3'b110) ? 1 : 0;
            data_en = (opcode == 3'b110) ? 1 : 0;
        end

        default: begin
            
            sel     = 0;
            rd      = 0;
            Id_ir   = 0;
            halt    = 0;
            Inc_pc  = 0;
            Ld_ac   = 0;
            Ld_pc   = 0;
            wr      = 0;
            data_en = 0;
        end

    endcase

end

endmodule