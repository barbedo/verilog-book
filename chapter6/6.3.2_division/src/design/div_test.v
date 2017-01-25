// Division circuit test

module div_test
    (
     input  wire       clk, reset,
     input  wire[15:0] sw,
     input  wire       btn,
     output wire[3:0]  an,
     output wire[7:0]  sseg,
     output wire[1:0]  led
    );

    // signal declaration
    wire      db_btn;
    wire[3:0] hex3, hex2, hex1, hex0;

    // instance of debouncer
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(db_btn));

    // instance of division circuit
    div #(.W(8), .CBIT(4)) div_unit
        (.clk(clk), .reset(reset), .start(db_btn),
         .dvnd(sw[15:8]), .dvsr(sw[7:0]),
         .done_tick(led[1]), .ready(led[0]),
         .quo({hex1, hex0}), .rmd({hex3, hex2}));

    // instance of display unit
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .hex3(hex3), .hex2(hex2),
         .hex1(hex1), .hex0(hex0),
         .dp_in(4'b1011), .an(an),
         .sseg(sseg));

endmodule
