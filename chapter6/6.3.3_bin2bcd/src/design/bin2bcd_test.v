// Binary-to-BCD conversion testing circuit

module bin2bcd_test
    (
     input  wire       clk, reset,
     input  wire       btn,
     input  wire[12:0] sw,
     output wire[3:0]  an,
     output wire[7:0]  sseg,
     output wire[1:0]  led
    );

    // signal declaration
    wire      start;
    wire[3:0] bcd3, bcd2, bcd1, bcd0;

    // instance of debouncer
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));

    // instance of binary-to-bcd converter
    bin2bcd bin2bcd_unit
        (.clk(clk), .reset(reset), .start(start),
         .bin(sw), .ready(led[0]), .done_tick(led[1]),
         .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));

    // instance of display unit
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .hex3(bcd3), .hex2(bcd2),
         .hex1(bcd1), .hex0(bcd0),
         .dp_in(4'b1111), .an(an), .sseg(sseg));

endmodule
