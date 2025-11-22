// Arquivo: watch.v (FINAL - Uso de Timer Tick para Sincronização)
module watch (
    input wire sys_clk,       // Clock do sistema (27MHz)
    
    // Entradas diretas dos botões
    input wire btn_mode_in, 
    input wire btn_start_in, 
    input wire btn_adjust_in,
    
    // Saídas para o display de 7 segmentos (7 pinos)
    output wire [6:0] seg_out,

    // NOVAS SAÍDAS DE STATUS
    output wire status_watch,
    output wire status_change,
    output wire status_chrono
);

// Sinais internos
wire timer_tick; // Pulso de 1 ciclo a cada segundo
wire [3:0] bcd_count;


// 1. Divisor de Clock para 1Hz (Gera um pulso de 1 ciclo)
clk_divider divider (
    .clk_in(sys_clk),
    .timer_tick(timer_tick) // Conecta o pulso de 1Hz de 1 ciclo
);

// 2. Máquina de Estados e Contador
counter_fsm fsm (
    .clk(sys_clk),
    .timer_tick(timer_tick), // Usa o pulso de alta frequência para incrementar
    .btn_mode(btn_mode_in),
    .btn_start(btn_start_in),
    .btn_adjust(btn_adjust_in),
    .display_out(bcd_count),
    .status_watch_out(status_watch),
    .status_change_out(status_change),
    .status_chrono_out(status_chrono)
);

// 3. Decodificador de 7 Segmentos
seven_seg_decoder decoder (
    .bcd_in(bcd_count),
    .segments(seg_out)
);

endmodule