module rising_edge_detector(
    input clk,
    input rest,
    input In,
    output tick
);
    localparam ZERO = 2'b00;
    localparam EDGE = 2'b01;
    localparam ONE = 2'b10;

    reg [1:0] current_state, next_state;

always @(posedge clk or posedge rest) begin
    if (rest) begin
        current_state <= ZERO;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        ZERO: begin
            if (In) begin
                next_state = EDGE;
            end else begin
                next_state = ZERO;
            end
        end
        EDGE: begin
                next_state = ONE;
        end
        ONE: begin
            if (In) begin
                next_state = ONE;
            end else begin
                next_state = ZERO;
            end
        end
        default: next_state = ZERO;
    endcase
end

assign tick = (current_state == EDGE) ? 1'b1 : 1'b0;



endmodule