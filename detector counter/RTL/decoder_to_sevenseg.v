module decoder_7seg(
    input [3:0] rising_count,
    input [3:0] falling_count,
    input [3:0] total_count,
    input reset,
    output reg [6:0] R,
    output reg [6:0] R_C,
    output reg [6:0] F,
    output reg [6:0] F_C,
    output reg [6:0] T,
    output reg [6:0] T_C
);

always @(*) begin
    if (reset) begin
        R = 7'b1001000; //n
        R_C = 7'b1000001;//u
        F = 7'b1000111;//l
        F_C = 7'b1000111;//l
        T = 7'b1111111;
        T_C = 7'b1111111;
    end else begin
        case (rising_count)
            4'h0: R_C = 7'b1000000; //0
            4'h1: R_C = 7'b1111001; //1
            4'h2: R_C = 7'b0100100; //2
            4'h3: R_C = 7'b0110000; //3
            4'h4: R_C = 7'b0011001; //4
            4'h5: R_C = 7'b0010010; //5
            4'h6: R_C = 7'b0000010; //6
            4'h7: R_C = 7'b1111000; //7
            4'h8: R_C = 7'b0000000; //8
            4'h9: R_C = 7'b0010000; //9
            4'ha: R_C = 7'b0001000; //A
            4'hb: R_C = 7'b0000011; //b
            4'hc: R_C = 7'b1000110; //c
            4'hd: R_C = 7'b0100001; //d
            4'he: R_C = 7'b0000110; //E
            4'hf: R_C = 7'b0001110; //F
            default: R_C = 7'b1111111;
        endcase

        case (falling_count)
            4'h0: F_C = 7'b1000000; //0
            4'h1: F_C = 7'b1111001; //1
            4'h2: F_C = 7'b0100100; //2
            4'h3: F_C = 7'b0110000; //3
            4'h4: F_C = 7'b0011001; //4
            4'h5: F_C = 7'b0010010; //5
            4'h6: F_C = 7'b0000010; //6
            4'h7: F_C = 7'b1111000; //7
            4'h8: F_C = 7'b0000000; //8
            4'h9: F_C = 7'b0010000; //9
            4'ha: F_C = 7'b0001000; //A
            4'hb: F_C = 7'b0000011; //b
            4'hc: F_C = 7'b1000110; //c
            4'hd: F_C = 7'b0100001; //d
            4'he: F_C = 7'b0000110; //E
            4'hf: F_C = 7'b0001110; //F
            default: F_C = 7'b1111111;
        endcase

        case (total_count)
            4'h0: T_C = 7'b1000000; //0
            4'h1: T_C = 7'b1111001; //1
            4'h2: T_C = 7'b0100100; //2
            4'h3: T_C = 7'b0110000; //3
            4'h4: T_C = 7'b0011001; //4
            4'h5: T_C = 7'b0010010; //5
            4'h6: T_C = 7'b0000010; //6
            4'h7: T_C = 7'b1111000; //7
            4'h8: T_C = 7'b0000000; //8
            4'h9: T_C = 7'b0010000; //9
            4'ha: T_C = 7'b0001000; //A
            4'hb: T_C = 7'b0000011; //b
            4'hc: T_C = 7'b1000110; //c
            4'hd: T_C = 7'b0100001; //d
            4'he: T_C = 7'b0000110; //E
            4'hf: T_C = 7'b0001110; //F
            default: T_C = 7'b1111111;
        endcase
        R=7'b0001000; //R
        F=7'b0001110; //F
        T=7'b0000110; //T
    end
    
end 
endmodule