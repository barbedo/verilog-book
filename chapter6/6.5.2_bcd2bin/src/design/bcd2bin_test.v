// Binary-to-BCD conversion testing circuit

module bcd2bin_test
    (
     input  wire      clk, reset,
     input  wire      btn,
     input  wire[7:0] sw,
     output wire[3:0] an,
     output wire[7:0] sseg,
     output wire[7:0] led
    );

    // signal declaration
    wire      start;
    wire[3:0] bcd1, bcd0;
    assign bcd1 = sw[7:4];
    assign bcd0 = sw[3:0];

    // instance of debouncer
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));

    // instance of bcd-to-binary converter
    bcd2bin bcd2bin_unit
        (.clk(clk), .reset(reset), .start(start),
         .bin(led[6:0]), .ready(led[7]), .done_tick(),
         .bcd1(bcd1), .bcd0(bcd0));

    // instance of display unit
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .hex3(4'b0000), .hex2(4'b0000),
         .hex1(bcd1), .hex0(bcd0),
         .dp_in(4'b1111), .an(an), .sseg(sseg));

endmodule
