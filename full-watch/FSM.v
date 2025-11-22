module FSM(
    input wire btn_mode, 
    input wire btn_start, 
    input wire btn_change,
    input wire reset, 
    input wire clk,
    output reg [3:0] s_unidade_fsm,
    output reg [3:0] s_dezena_fsm,
    output reg [3:0] m_unidade_fsm,
    output reg [3:0] m_dezena_fsm,
    output reg [3:0] h_unidade_fsm,
    output reg [3:0] h_dezena_fsm);

reg [1:0] state;

localparam RELOGIO = 2'b00, CRONOMETRO = 2'b01;

reg crono_rodando;
wire crono_reset;
assign crono_reset = (state == CRONOMETRO && btn_change) || state == RELOGIO;

reg prev_mode, prev_start;

wire [3:0] s_unidade_relogio, s_dezena_relogio, m_unidade_relogio, m_dezena_relogio, h_unidade_relogio, h_dezena_relogio;

wire [3:0] s_unidade_cronometro, s_dezena_cronometro, m_unidade_cronometro, m_dezena_cronometro, h_unidade_cronometro, h_dezena_cronometro;

Contador Contador_relogio (
    .clk    (clk),
    .rst  (reset),
    .enable  (1'b1),
    .clr (1'b0),
    .s_unidade (s_unidade_relogio), 
    .s_dezena (s_dezena_relogio),
    .m_unidade (m_unidade_relogio),
    .m_dezena (m_dezena_relogio),
    .h_unidade (h_unidade_relogio),
    .h_dezena (h_dezena_relogio)
);

Contador Contador_cronometro (
    .clk    (clk),
    .rst  (reset),
    .enable (crono_rodando),
    .clr(crono_reset),
    .s_unidade (s_unidade_cronometro), 
    .s_dezena (s_dezena_cronometro),
    .m_unidade (m_unidade_cronometro),
    .m_dezena (m_dezena_cronometro),
    .h_unidade (h_unidade_cronometro),
    .h_dezena (h_dezena_cronometro)
);

always @(posedge clk or negedge reset) begin
    if (!reset)begin
        crono_rodando <= 0;
        state <= RELOGIO;
        prev_mode <= 0;
        prev_start <= 0;
    end
    else begin 
        prev_mode <= btn_mode;
        prev_start <= btn_start;
        // Botão Mode: Troca de tela
        if (btn_mode && !prev_mode) begin
            if (state == RELOGIO)begin
                state <= CRONOMETRO;
            end
            else state <= RELOGIO;
        end

        // Botão Start: Troca start/pause (Só no Cronometro)
        if (btn_start && !prev_start && state == CRONOMETRO) begin
            crono_rodando <= ~crono_rodando;
        end
    end
end

always @(*) begin
    case(state)
        RELOGIO: begin
            s_unidade_fsm = s_unidade_relogio;
            s_dezena_fsm = s_dezena_relogio;
            m_unidade_fsm = m_unidade_relogio;
            m_dezena_fsm = m_dezena_relogio;
            h_unidade_fsm = h_unidade_relogio;
            h_dezena_fsm = h_dezena_relogio;
        end

        CRONOMETRO: begin
            s_unidade_fsm = s_unidade_cronometro;
            s_dezena_fsm = s_dezena_cronometro;
            m_unidade_fsm = m_unidade_cronometro;
            m_dezena_fsm = m_dezena_cronometro;
            h_unidade_fsm = h_unidade_cronometro;
            h_dezena_fsm = h_dezena_cronometro;
        end
    endcase    
end

endmodule