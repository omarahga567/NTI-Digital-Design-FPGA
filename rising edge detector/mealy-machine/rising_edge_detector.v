`timescale 1ns/1ps

module rising_edge_detector(
    input clk,
    input rest,
    input In,
    output tick
);

    localparam ZERO = 1'b0;
    localparam ONE  = 1'b1;

    reg current_state;
    reg next_state;

    always @(posedge clk or posedge rest) begin
        if (rest)
            current_state <= ZERO;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)

            ZERO: begin
                if (In)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end

            ONE: begin
                if (In)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end

            default:
                next_state = ZERO;

        endcase
    end

    
    assign tick = (current_state == ZERO) && In;

endmodule