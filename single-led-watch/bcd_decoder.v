// Arquivo: seven_seg_decoder.v
module seven_seg_decoder (
    input  wire [3:0] bcd_in,    
    output reg  [6:0] segments   // Ordem: [A B C D E F G]
);
    
    always @(*) begin
        // Padrão binário: segments[6]=A, [5]=B, [4]=C, [3]=D, [2]=E, [1]=F, [0]=G
        case(bcd_in)
            4'd0: segments = 7'b1111110; // 0 
            4'd1: segments = 7'b0110000; // 1
            4'd2: segments = 7'b1101101; // 2
            4'd3: segments = 7'b1111001; // 3
            4'd4: segments = 7'b0110011; // 4
            4'd5: segments = 7'b1011011; // 5
            4'd6: segments = 7'b1011111; // 6
            4'd7: segments = 7'b1110000; // 7
            4'd8: segments = 7'b1111111; // 8
            4'd9: segments = 7'b1111011; // 9
            
            default: segments = 7'b0000000; // Display OFF
        endcase
    end
endmodule