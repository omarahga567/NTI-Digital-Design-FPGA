`timescale 1ns/1ps
module debouncing_circuit#(parameter TICK_CYCLE=5)(
    input original_sw,
    input clk,
    output debouncing_db
);

localparam ZERO = 3'b000 ;
localparam WAIT1_1 = 3'b001 ;
localparam WAIT1_2 = 3'b010 ;
localparam WAIT1_3 = 3'b011 ;
localparam ONE = 3'b100 ;
localparam WAIT0_1 = 3'b101 ;
localparam WAIT0_2 = 3'b110 ;
localparam WAIT0_3 = 3'b111 ;

reg [2:0] current_state,next_state;

localparam COUNT_WIDTH = $clog2(TICK_CYCLE) ;
reg [COUNT_WIDTH-1:0] count=0;
reg m_tick;
always@(posedge clk) begin
    if (count==TICK_CYCLE-1) begin
        count<=0;
        m_tick<=1;
    end else begin
        count<=count+1;
        m_tick<=0;
    end
    current_state<=next_state;
end

always @(*) begin
    case (current_state)
       ZERO: begin
          if (original_sw)
             next_state = WAIT1_1;
          else
             next_state = ZERO;
       end
        WAIT1_1: begin
            if (!original_sw)
                next_state = ZERO;
            else if (m_tick)
                next_state = WAIT1_2;
            else
                next_state = WAIT1_1;
        end

        WAIT1_2: begin
            if (!original_sw)
                next_state = ZERO;
            else if (m_tick)
                next_state = WAIT1_3;
            else
                next_state = WAIT1_2;
        end

        WAIT1_3: begin
            if (!original_sw)
                next_state = ZERO;
            else if (m_tick)
                next_state = ONE;
            else
                next_state = WAIT1_3;
        end

        ONE: begin
            if (!original_sw)
                next_state = WAIT0_1;
            else
                next_state = ONE;
        end

        WAIT0_1: begin
            if (original_sw)
                next_state = ONE;
            else if (m_tick)
                next_state = WAIT0_2;
            else
                next_state = WAIT0_1;
        end

        WAIT0_2: begin
            if (original_sw)
                next_state = ONE;
            else if (m_tick)
                next_state = WAIT0_3;
            else
                next_state = WAIT0_2;
        end

        WAIT0_3: begin
            if (original_sw)
                next_state = ONE;
            else if (m_tick)
                next_state = ZERO;
            else
                next_state = WAIT0_3;
        end

        default:
            next_state = ZERO;

    endcase
end

assign debouncing_db =
       (current_state == ONE)     ||
       (current_state == WAIT0_1) ||
       (current_state == WAIT0_2) ||
       (current_state == WAIT0_3);

    
endmodule