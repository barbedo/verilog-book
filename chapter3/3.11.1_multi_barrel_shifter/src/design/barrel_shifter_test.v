// Multi-directional barrel shifter test circuit

module barrel_shifter_test
    (
    input  wire[11:0] sw,
    output wire[7:0]  led
    );
    
    // bit width and exponent
    localparam N = 32;
    localparam M = 5;

    // instance of barrel shifter
    barrel_shifter_rev #(.N(N), .M(M)) uut
        (.a(sw[7:0]), .amt(sw[10:8]), .lr(sw[11]), .y(led));

endmodule
