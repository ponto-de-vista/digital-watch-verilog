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
        output reg [3:0] h_dezena_fsm,
        //ARMAZENA A POSICAO QUE ESTA SENDO CONFIGURADA
        output reg [2:0] config_digit,
        //VERIFICA SE ESTA NO MODO DE CONFIGURACAO
        output wire is_config
        );

    reg [1:0] state;

    localparam RELOGIO = 2'b00, CRONOMETRO = 2'b01, CFG = 2'b10;

    reg crono_rodando;
    wire crono_reset;
    assign crono_reset = (state == CRONOMETRO && btn_change) || state == RELOGIO;

    //DETECTAR BORDA
    reg prev_mode, prev_start, prev_change;
    wire click_mode = (btn_mode && !prev_mode);
    wire click_start = (btn_start && !prev_start);
    wire click_change = (btn_change && !prev_change);

    //VERIFICA SE QUER ADICIONAR 1 E SE ESTA EM CONFIG
    assign config_add = (state == CFG && click_change);  
    assign is_config = (state == CFG);   

    //FIOS INTERNOS
    wire [3:0] s_unidade_relogio, s_dezena_relogio, m_unidade_relogio, m_dezena_relogio, h_unidade_relogio, h_dezena_relogio;
    wire [3:0] s_unidade_cronometro, s_dezena_cronometro, m_unidade_cronometro, m_dezena_cronometro, h_unidade_cronometro, h_dezena_cronometro;

    Contador Contador_relogio (
        .clk    (clk),
        .rst  (reset),
        .enable  (state != CFG),
        .clr (1'b0),
        .config_digit (config_digit), 
        .config_add (config_add), 
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
        .config_digit (3'b000), 
        .config_add (1'b0), 
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
            prev_change <= btn_change;
            prev_mode <= btn_mode;
            prev_start <= btn_start;

            case(state)
                RELOGIO: begin
                    if (click_mode) state <= CRONOMETRO;
                end
                CRONOMETRO: begin
                    if (click_mode) state <= CFG;
                    if(click_start) crono_rodando <= ~crono_rodando;
                end
                CFG: begin
                    if (click_mode) begin
                        config_digit <= 3'b000;
                        state <= RELOGIO;
                    end
                    if(click_start)begin
                        if(config_digit == 5) config_digit <= 0;
                        else config_digit <= config_digit + 1;
                    end
                end
            endcase
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
            CFG: begin
                s_unidade_fsm = s_unidade_relogio;
                s_dezena_fsm = s_dezena_relogio;
                m_unidade_fsm = m_unidade_relogio;
                m_dezena_fsm = m_dezena_relogio;
                h_unidade_fsm = h_unidade_relogio;
                h_dezena_fsm = h_dezena_relogio;
            end
        endcase    
    end
endmodule