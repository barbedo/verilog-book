// Fibonacci circuit with BCD IO test circuit

module bcd_fib_test
    (
     input  wire      clk, reset,
     input  wire      btn,
     input  wire[7:0] sw,
     output wire[3:0] an,
     output wire[7:0] sseg
    );

    // signal declaration
    wire      start;
    wire[3:0] bcd3, bcd2, bcd1, bcd0;
 
    // debouncing circuit
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));

    // bcd fib circuit
    bcd_fib bcd_fib_unit
        (.clk(clk), .reset(reset),
         .start(start), .bcd1(sw[7:4]), .bcd0(sw[3:0]),
         .out_bcd3(bcd3), .out_bcd2(bcd2), .out_bcd1(bcd1),
         .out_bcd0(bcd0));

    // display unit
    disp_hex_mux dp_unit
        (.clk(clk), .reset(reset),
         .hex3(bcd3), .hex2(bcd2),
         .hex1(bcd1), .hex0(bcd0),
         .dp_in(4'b1111), .an(an),
         .sseg(sseg));

endmodule
