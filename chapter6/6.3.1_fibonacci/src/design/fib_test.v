// Fibonacci number testing circuit

module fib_test
    (
     input  wire      clk, reset,
     input  wire      btn,
     input  wire[4:0] sw,
     output wire[3:0] an,
     output wire[7:0] sseg,
     output wire[1:0] led
    );

    // signal declaration
    wire      start;
    wire[4:0] in;
    wire[3:0] hex3, hex2, hex1, hex0;

    // intance of debouncers
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));
    genvar i;
    generate
    for (i = 0; i < 5; i = i + 1) begin : sw_debouncer
        debounce sw_unit
            (.clk(clk), .reset(reset), .sw(sw[i]),
             .db_level(in[i]), .db_tick());            
    end
    endgenerate

    // instance of fibonacci circuit
    fib fib_unit
        (.clk(clk), .reset(reset), .start(start),
         .i(in), .ready(led[0]), .done_tick(led[1]),
         .f({hex3, hex2, hex1, hex0}));

    // instance of display unit
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .hex3(hex3), .hex2(hex2),
         .hex1(hex1), .hex0(hex0),
         .dp_in(4'b1111), .an(an), .sseg(sseg));

endmodule
