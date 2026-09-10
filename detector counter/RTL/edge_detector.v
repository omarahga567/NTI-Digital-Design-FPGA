module edge_detector(
    input clk,
    input reset,
    input in,
    output  rising_tick,
    output  falling_tick,
    output  edge_tick
);

localparam IDLE      = 2'b00;
localparam RISE_TICK  = 2'b01;
localparam HIGH      = 2'b10;
localparam FALL_TICK  = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always@(*) begin
    case(state)
        IDLE: begin
            if(in) begin
                next_state = RISE_TICK;
            end else begin
                next_state = IDLE;
            end
        end

        RISE_TICK: begin
            if(!in) begin
                next_state = FALL_TICK;
            end else begin
                next_state = HIGH;
            end
        end

        HIGH: begin
            if(!in) begin
                next_state = FALL_TICK;
            end else begin
                next_state = HIGH;
            end
        end

        FALL_TICK: begin
            next_state = IDLE;
        end
    endcase
end


assign rising_tick = (state == RISE_TICK);
assign falling_tick = (state == FALL_TICK);
assign edge_tick = (rising_tick)|(falling_tick);

endmodule