module bcd_para_7seg(
    input  wire [3:0] bcd_in, // Entrada: o número 0000 a 1001
    output reg  [6:0] segments  // Saída: os 7 LEDs
);

    always @(bcd_in)
    begin
        case(bcd_in)
            4'b0000: segments = 7'b1000000; // 0
            4'b0001: segments = 7'b1111001; // 1
            4'b0010: segments = 7'b0100100; // 2
            4'b0011: segments = 7'b0110000; // 3
            4'b0100: segments = 7'b0011001; // 4
            4'b0101: segments = 7'b0010010; // 5
            4'b0110: segments = 7'b0000010; // 6
            4'b0111: segments = 7'b1111000; // 7
            4'b1000: segments = 7'b0000000; // 8
            4'b1001: segments = 7'b0011000; // 9
            // Para valores 10-15, mostra um 'E' de Erro
            default: segments = 7'b0000110; 
        endcase
    end
endmodule