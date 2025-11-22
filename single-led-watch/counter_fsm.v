// Arquivo: counter_fsm.v (Máquina de Estados Completa)
module counter_fsm (
    input wire clk,           // sys_clk (27MHz)
    input wire timer_tick,    // Pulso de 1 ciclo a cada 1s
    
    input wire btn_mode,      // Seletor de Estado (M)
    input wire btn_start,     // Ação 1 (S)
    input wire btn_adjust,    // Ação 2 (A)
    
    output wire [3:0] display_out,

    output wire status_watch_out,
    output wire status_change_out,
    output wire status_chrono_out
);

localparam S_WATCH  = 2'b00;
localparam S_CHANGE = 2'b01;
localparam S_CHRONO = 2'b10;

reg [1:0] current_state = S_WATCH;

reg [3:0] watch_count_reg = 4'd0; // Contador do Modo Relógio
reg [3:0] chrono_count_reg = 4'd0; // Contador do Modo Cronômetro
reg chrono_running = 1'b0;        // Flag para rodar o cronômetro

reg btn_start_prev = 1'b0;
reg btn_adjust_prev = 1'b0;

wire start_edge;
wire adjust_edge;

assign start_edge = btn_start & (~btn_start_prev);
assign adjust_edge = btn_adjust & (~btn_adjust_prev);

// --- Lógica Sequencial (FSM e Ações) ---
always @(posedge clk) begin
    
    // Atualiza o estado anterior dos botões para detecção de borda
    btn_start_prev <= btn_start;
    btn_adjust_prev <= btn_adjust;
    
    // O botão Mode (M) atua como seletor de estado (transição M=1, mantém M=0)
    if (btn_mode) begin
        case (current_state)
            S_WATCH: current_state <= S_CHANGE;
            S_CHANGE: current_state <= S_CHRONO;
            S_CHRONO: current_state <= S_WATCH;
            default: current_state <= S_WATCH;
        endcase
    end
    
    // ===================================
    // 2. Lógica de Ação Baseada no Estado
    // ===================================
    case (current_state)
        
        S_WATCH: begin
            if (timer_tick) begin
                if (watch_count_reg == 4'd9) watch_count_reg <= 4'd0; 
                else watch_count_reg <= watch_count_reg + 1'b1; 
            end
        end
        
        S_CHANGE: begin
        end
        
        S_CHRONO: begin
        end
        
    endcase
end

assign status_watch_out = (current_state == S_WATCH);
assign status_change_out = (current_state == S_CHANGE);
assign status_chrono_out = (current_state == S_CHRONO);

assign display_out = (current_state == S_CHRONO) ? chrono_count_reg : watch_count_reg;

endmodule