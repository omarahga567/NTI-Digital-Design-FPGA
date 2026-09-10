module top(clk, reset, in, R, F, T, R_C, F_C, T_C);
    input clk;
    input reset;
    input in;
    output [6:0] R;
    output [6:0] F;
    output [6:0] T;
    output [6:0] R_C;
    output [6:0] F_C;
    output [6:0] T_C;

    wire rising_tick;
    wire falling_tick;
    wire edge_tick;
    wire [3:0] rise_count;
    wire [3:0] fall_count;
    wire [3:0] total_count;
    wire clk_out;

    clk_divider clk_div(
        .clk(clk),
        .reset(reset),
        .clk_out(clk_out)
    );

    edge_detector ed(
        .clk(clk_out),
        .reset(reset),
        .in(in),
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .edge_tick(edge_tick)
    );

    edge_counter ec(
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .edge_tick(edge_tick),
        .clk(clk_out),
        .reset(reset),
        .rise_count(rise_count),
        .fall_count(fall_count),
        .total_count(total_count)
    );

    decoder_7seg decoder(
        .rising_count(rise_count),
        .falling_count(fall_count),
        .total_count(total_count),
        .reset(reset),
        .R(R),
        .R_C(R_C),
        .F(F),
        .F_C(F_C),
        .T(T),
        .T_C(T_C)
    );

    
endmodule