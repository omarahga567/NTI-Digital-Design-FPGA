module edge_counter(
    input rising_tick,
    input falling_tick,
    input edge_tick,
    input clk,
    input reset,
    output reg [3:0] rise_count,
    output reg [3:0] fall_count,
    output reg [3:0] total_count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rise_count <= 0;
            fall_count <= 0;
            total_count <= 0;
        end else begin
            if (rising_tick) begin
                rise_count <= rise_count + 1;
                total_count <= total_count + 1;
            end
            if (falling_tick) begin
                fall_count <= fall_count + 1;
                total_count <= total_count + 1;
            end
        end
    end
endmodule