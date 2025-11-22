module relogio_simples_top(
    input wire btn_mode, 
    input wire reset,
    input wire btn_start, 
    input wire btn_change, 
    input wire clk,
    output wire [6:0] HEX0,   // Display de 7-segmentos (PIN_C14, etc.)
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

    wire [3:0] s_unidade, s_dezena, m_unidade, m_dezena, h_unidade, h_dezena;

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
        .h_dezena_fsm (h_dezena)
    );

    // ---- Instanciação do Módulo 2: O Decodificador ----
    // "Cria" uma cópia do nosso decodificador
     bcd_para_7seg U_Decodificador_Seg (
        .bcd_in   (s_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX0)            // Conecta a saída 'segments' aos pinos físicos HEX0
    );
	 
	bcd_para_7seg D_Decodificador_Seg (
        .bcd_in   (s_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX1)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg U_Decodificador_Min (
        .bcd_in   (m_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX2)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg D_Decodificador_Min (
        .bcd_in   (m_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX3)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg U_Decodificador_H (
        .bcd_in   (h_unidade), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX4)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );

    bcd_para_7seg D_Decodificador_H (
        .bcd_in   (h_dezena), // Conecta o *mesmo* fio interno à entrada 'bcd_in'
        .segments (HEX5)            // Conecta a saída 'segments' aos pinos físicos HEX1
    );



endmodule
