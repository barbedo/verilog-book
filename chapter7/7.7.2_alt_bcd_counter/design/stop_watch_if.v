// Nested if-statement description for a stopwatch

module stop_watch_if
  (
    input  wire       clk,
    input  wire       go, clr,
    output reg[3:0]   d2, d1, d0
  );

  // declaration
  localparam DVSR = 10000000;
  reg[23:0]  ms;
  reg[3:0]   d2_next, d1_next, d0_next;
  wire       ms_tick;

  // body
  always @(posedge clk)
  begin
    if (clr)
      begin
        d0 <= 4'b0;
        d1 <= 4'b0;
        d2 <= 4'b0;
        ms <= 23'b0;
      end
    else 
      begin
        if (ms_tick)
          if (d0 != 9)
            d0 <= d0 + 1;
          else
            begin
              d0 <= 4'b0;
              if (d1 != 9)
                d1 <= d1 + 1;
              else // reach X99
                begin
                  d1 <= 4'b0;
                  if (d2 != 9)
                    d2 <= d2 + 1;
                  else // reach 999
                    d2 <= 4'b0;
                end
          end
        if (go)
          if (ms == DVSR)
            ms <= 23'b0;
          else
            ms <= ms + 1;
      end
    // d0, d1, d2 and ms keep their value by default 
  end

   assign ms_tick = (ms == DVSR) ? 1'b1 : 1'b0;

endmodule
