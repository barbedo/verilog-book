// Dual-mode comparator testing circuit

module comparator_top
  (
    input wire       clk,
    input wire       btnC,
    input wire[15:0] sw,
    output wire      led
  );

  // internal signals
  wire[7:0] a, b;
  wire      out, out_unsigned, out_signed;
  wire      toggle_mode;
  reg       mode;

  // inputs
  assign a   = sw[7:0];
  assign b   = sw[15:8];
  // output
  assign led = mode ? out_signed : out_unsigned;

  // instantiations
  debounce db_unit
    (.clk(clk), .reset(1'b0), .sw(btnC),
     .db_level(), .db_tick(toggle_mode));
  unsigned_comparator u_comp_unit
    (.a(a), .b(b), .out(out_unsigned));
  signed_comparator s_comp_unit
    (.a(a), .b(b), .out(out_signed));

  // Latch to toggle the comparison mode
  always @(posedge clk)
  begin
    mode <= mode;
    if (toggle_mode)
      mode <= mode + 1;
  end

endmodule