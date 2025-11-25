module relogio_simples_top(
    input wire btn_mode, 
    input wire reset,
    input wire btn_start, 
    input wire btn_change, 
    input wire clk,
    output wire [6:0] HEX0,   // Display de 7-segmentos
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

    wire [3:0] s_unidade, s_dezena, m_unidade, m_dezena, h_unidade, h_dezena;
    wire is_config;
    wire [2:0] config_digit;

    reg [24:0] pisca_counter;
    wire pisca_on;

    FSM fsm(
        .btn_mode (btn_mode), 
        .btn_start (btn_start), 
        .btn_change (btn_change),
        .reset (reset),
        .clk (clk),
        .s_unidade_fsm (s_unidade),
        .s_dezena_fsm (s_dezena),
        .m_unidade_fsm (m_unidade),
        .m_dezena_fsm (m_dezena),
        .h_unidade_fsm (h_unidade),
        .h_dezena_fsm (h_dezena),
        .config_digit (config_digit),
        .is_config(is_config)
    );

    always @(posedge clk) begin
        pisca_counter <= pisca_counter + 1;
    end

    assign pisca_on = pisca_counter[24];

    wire [6:0] valor_hex0, valor_hex1, valor_hex2, valor_hex3, valor_hex4, valor_hex5;

    assign HEX0 = (pisca_on && is_config && config_digit == 0 ? 7'b1111111 : valor_hex0);
    assign HEX1 = (pisca_on && is_config && config_digit == 1 ? 7'b1111111 : valor_hex1);
    assign HEX2 = (pisca_on && is_config && config_digit == 2 ? 7'b1111111 : valor_hex2);
    assign HEX3 = (pisca_on && is_config && config_digit == 3 ? 7'b1111111 : valor_hex3);
    assign HEX4 = (pisca_on && is_config && config_digit == 4 ? 7'b1111111 : valor_hex4);
    assign HEX5 = (pisca_on && is_config && config_digit == 5 ? 7'b1111111 : valor_hex5);

    //Instancia dos decodificadores
     bcd_para_7seg U_Decodificador_Seg (
        .bcd_in   (s_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex0)            // Conecta a saída 'segments' aos pinos físicos HEX0
    );
	 
	bcd_para_7seg D_Decodificador_Seg (
        .bcd_in   (s_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex1)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg U_Decodificador_Min (
        .bcd_in   (m_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex2)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg D_Decodificador_Min (
        .bcd_in   (m_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex3)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg U_Decodificador_H (
        .bcd_in   (h_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex4)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg D_Decodificador_H (
        .bcd_in   (h_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (valor_hex5)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

endmodule
