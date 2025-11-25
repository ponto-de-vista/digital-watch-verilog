module Contador(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire clr,
    input  wire [2:0] config_digit, 
    input  wire config_add,  
    output reg [3:0] s_unidade,
    output reg [3:0] s_dezena,
    output reg [3:0] m_unidade,
    output reg [3:0] m_dezena,
    output reg [3:0] h_unidade,
    output reg [3:0] h_dezena
);

    localparam UM_SEGUNDO = 50_000_000;
    
    // Prescaler de 26 bits
    reg [25:0] prescaler_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            prescaler_reg <= 0;
            s_unidade     <= 0; 
            s_dezena     <= 0;
            m_unidade     <= 0;
            m_dezena     <= 0;
            h_unidade     <= 0;
            h_dezena     <= 0;
        end else if (clr) begin
            prescaler_reg <= 0;
            s_unidade     <= 0; 
            s_dezena     <= 0;
            m_unidade     <= 0;
            m_dezena     <= 0;
            h_unidade     <= 0;
            h_dezena     <= 0;
        end
        else begin
            if (config_add) begin
                case(config_digit)
                    3'd0: s_unidade <= (s_unidade == 9) ? 0 : s_unidade + 1;
                    3'd1: s_dezena  <= (s_dezena  == 5) ? 0 : s_dezena  + 1;
                    3'd2: m_unidade <= (m_unidade == 9) ? 0 : m_unidade + 1;
                    3'd3: m_dezena  <= (m_dezena  == 5) ? 0 : m_dezena  + 1;
                    3'd4: begin
                        // Ao ajustar unidade da hora, cuida para não passar de 23h
                        if (h_dezena == 2 && h_unidade >= 3) h_unidade <= 0;
                        else if (h_unidade == 9) h_unidade <= 0;
                        else h_unidade <= h_unidade + 1;
                    end
                    3'd5: begin 
                        // Ao ajustar dezena da hora, limita em 2
                        if (h_dezena >= 2) h_dezena <= 0;
                        else h_dezena <= h_dezena + 1;
                        
                        // Segurança: Se mudar dezena pra 2 e unidade for >3 (ex: 19 -> 29), corrige pra 20
                        if (h_dezena == 1 && h_unidade > 3) h_unidade <= 0; 
                    end
                endcase
            end


            // O prescaler atingiu 1 segundo?
            else if (enable && !config_add) begin
                if (prescaler_reg == UM_SEGUNDO - 1) begin
                    prescaler_reg <= 0; // Reinicia o prescaler
                    
                    if (s_unidade == 9) begin
                        s_unidade <= 0;

                        s_dezena <= s_dezena + 1;

                        if(s_dezena == 5) begin
                            s_dezena <= 0;

                            m_unidade <= m_unidade + 1;

                            if(m_unidade == 9)begin
                                m_unidade <= 0;

                                m_dezena <= m_dezena + 1;

                                if(m_dezena == 5) begin
                                    m_dezena <= 0;

                                    h_unidade <= h_unidade + 1;

                                    if(h_dezena == 2 && h_unidade == 3)begin
                                        h_dezena <= 0;
                                        h_unidade <= 0;
                                    end

                                    if(h_unidade == 9)begin
                                        h_unidade <= 0; 

                                        h_dezena <= h_dezena + 1;
                                    end
                                end
                            end
                        end 
                    end
                    // Se for menor que 9, apenas incrementa.
                    else begin
                        s_unidade <= s_unidade + 1;
                    end
                    
                end
                // Se não atingiu 1 segundo, apenas continua contando o prescaler
                else begin
                    prescaler_reg <= prescaler_reg + 1;
                end
            end
        end
    end

endmodule
