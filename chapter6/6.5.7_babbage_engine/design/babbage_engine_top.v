// Babbage difference engine emulation testing circuit

module babbage_engine_top
  (
    input wire       clk,
    input wire       btnD, // reset
    input wire       btnC, // start
    input wire[5:0]  sw,
    input wire       sw_sel,
    output wire[3:0] an,
    output wire[7:0] sseg
  );

  // signal declaration
  wire       reset;
  wire       start;
  reg        calc_start, bcd_start;
  wire       bcd_done, calc_done, calc_done_f, calc_done_h;
  wire       calc_start_f, calc_start_h;
  wire[19:0] calc_out, calc_out_f, calc_out_h;
  wire[3:0]  bcd3, bcd2, bcd1, bcd0;
  reg[3:0]   dp_in;

  // component instantiation
  debounce db_start_unit
    (.clk(clk), .reset(reset), .sw(btnC),
     .db_level(), .db_tick(start));
  babbage_engine_f babbage_f_unit
    (.clk(clk), .reset(reset), .start(calc_start_f), 
     .done_tick(calc_done_f), .in(sw), .out(calc_out_f));
  babbage_engine_h babbage_h_unit
    (.clk(clk), .reset(reset), .start(calc_start_h),
     .done_tick(calc_done_h), .in(sw), .out(calc_out_h));
  bin2bcd bin2bcd_unit
    (.clk(clk), .reset(reset), .start(bcd_start),
     .bin(calc_out[13:0]), .ready(), .done_tick(bcd_done),
     .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
  disp_hex_mux disp_unit
    (.clk(clk), .reset(reset), .dp_in(4'b1111),
     .hex3(bcd3), .hex2(bcd2), .hex1(bcd1), .hex0(bcd0),
     .an(an), .sseg(sseg));

  // assignments and equation selection
  assign reset = btnD;
  assign calc_start_f = (sw_sel == 0) ? calc_start : 0;
  assign calc_start_h = (sw_sel == 1) ? calc_start : 0;
  assign calc_out     = (sw_sel == 0) ? calc_out_f : calc_out_h;
  assign calc_done    = (sw_sel == 0) ? calc_done_f : calc_done_h;

  // main control FSM
  localparam[1:0]
    idle    = 2'b00,
    calc    = 2'b01,
    bin2bcd = 2'b10;
  // signal declaration
  reg[1:0]  state_reg, state_next;
  // FSM state register
  always @(posedge clk, posedge reset)
    if (reset)
      state_reg <= idle;
    else
      state_reg <= state_next;
  // FSMD next-state logic
  always @*
  begin
    state_next = state_reg;
    calc_start = 1'b0;
    bcd_start  = 1'b0;
    
    case (state_reg)
      idle:
        if (start)
          begin
            state_next = calc;
            calc_start = 1'b1;
          end
      calc:
        if (calc_done)
          begin
            state_next = bin2bcd;
            bcd_start  = 1'b1;
          end
      bin2bcd:
        if (bcd_done)
          state_next = idle;
    endcase
  end

endmodule