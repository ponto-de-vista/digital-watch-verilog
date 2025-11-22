module Contador(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire clr,
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
        // 2. Lógica de Clock (Síncrona)
        else begin
            // O prescaler atingiu 1 segundo?
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
                if(enable == 1)begin 
                prescaler_reg <= prescaler_reg + 1;
                end
            end
        end
    end

endmodule
