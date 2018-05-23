// Babbage difference engine emulation circuit
// for the h(2) = n^3 + 2n^2 + 2n + 1 polynomial

module babbage_engine_h
  (
    input wire        clk, reset,
    input wire        start,
    output reg        done_tick,
    input wire[5:0]   in,
    output wire[19:0] out
  );

  // symbolic state declaration
  localparam[1:0]
    idle = 2'b00,
    calc = 2'b01,
    done = 2'b10;

  // constant declarations
  localparam H0 = 1, F1 = 5, G2 = 10, G_INC = 6;

  // signal declaration
  reg[1:0]  state_reg, state_next;
  reg[5:0]  n_reg, n_next;
  reg[5:0]  i_reg, i_next;
  reg[19:0] h_reg, h_next;
  reg[19:0] f_reg, f_next;
  reg[19:0] g_reg, g_next;

  // body
  // FSM state and data registers
  always @(posedge clk, posedge reset)
    if (reset)
      begin
        state_reg <= idle;
        n_reg     <= 0;
        i_reg     <= 0;
        h_reg     <= 0;
        f_reg     <= 0;
        g_reg     <= 0;
      end
    else
      begin
        state_reg <= state_next;
        n_reg     <= n_next;
        i_reg     <= i_next;
        h_reg     <= h_next;
        f_reg     <= f_next;
        g_reg     <= g_next;
      end

  // FSMD next-state logic
  always @*
  begin
    state_next = state_reg;
    n_next     = n_reg;
    i_next     = i_reg;
    h_next     = h_reg;
    f_next     = f_reg;
    g_next     = g_reg;
    done_tick  = 1'b0;

    case (state_reg)
      idle:
        if (start)
          begin
            state_next = calc;
            n_next     = in;
            i_next     = 0;
            h_next     = H0;
            f_next     = F1;
            g_next     = G2;
          end
      calc:
        if (n_reg == i_reg)
          state_next = done;
        else
          begin
            i_next = i_reg + 1;
            h_next = h_reg + f_reg;
            f_next = f_reg + g_reg;
            g_next = g_reg + G_INC;
          end
      done:
        begin
          state_next = idle;
          done_tick  = 1'b1;
        end
      default:
        state_next = idle;
    endcase
  end

// output
assign out = h_reg;

endmodule