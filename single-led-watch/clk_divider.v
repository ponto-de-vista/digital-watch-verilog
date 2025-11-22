// Arquivo: clk_divider.v (Pulso Único de 1 Hz)
module clk_divider (
    input wire clk_in,    // 27 MHz
    output wire timer_tick // Pulso de 1 ciclo a cada 1 segundo
);

// MAX_COUNT = 27,000,000 - 1
parameter MAX_COUNT = 25'd26999999; 

reg [24:0] timer_count = 25'd0; 
wire timer_done = (timer_count == MAX_COUNT);

always @(posedge clk_in) begin 
    if (timer_done) begin
        timer_count <= 25'd0; 
    end else begin
        timer_count <= timer_count + 1'b1;
    end
end

// O pulso é HIGH por UM ciclo de 27MHz a cada segundo.
assign timer_tick = timer_done;

endmodule