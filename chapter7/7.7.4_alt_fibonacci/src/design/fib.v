// Fibonacci number circuit

module fib
  (
      input  wire       clk, reset,
      input  wire       start,
      input  wire[4:0]  i,
      output wire       ready, done_tick,
      output wire[19:0] f
  );

  // symbolic state declaration
  localparam[1:0]
      idle = 2'b00,
      op   = 2'b01,
      done = 2'b10;

  // signal declaration
  reg[1:0]  state;
  reg[19:0] t0, t1;
  reg[4:0]  n;

  // merged registers and next-state logic
  always @(posedge clk, posedge reset)

    if (reset)
      begin
        state <= idle;
        t0    <= 0;
        t1    <= 0;
        n     <= 0;
      end

    else
      case (state)
        idle:
          begin
            if (start)
              begin
                t0    <= 20'd0;
                t1    <= 20'd1;
                n     <= i;
                state <= op;
              end
          end
        op:
          if (n == 0)
            begin
              t1    <= 0;
              state <= done;
            end
          else if (n == 1)
            begin
              state <= done;
            end
          else
            begin
              t1 <= t1 + t0;
              t0 <= t1;
              n  <= n - 1;
            end
        done:
          state <= idle;
      endcase

  // output
  assign f = t1;
  assign done_tick = (state == done);
  assign ready     = (state == idle);

endmodule
