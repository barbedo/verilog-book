// Parking lot occupancy counter testing circuit

module car_park_test
    (
     input  wire      clk, reset,  // reset is btnC
     input  wire[1:0] btn,  // btnD is 0, btnU is 1
     output wire[3:0] an,
     output wire[7:0] sseg
    );

    // signal declaration
    wire      inner_sensor, outer_sensor;
    wire      exit, enter;
    wire[7:0] val;

    // debouncing circuit instances
    debounce db_unit1
        (.clk(clk), .reset(reset), .sw(btn[0]),
         .db_level(inner_sensor), .db_tick());
    debounce db_unit2
         (.clk(clk), .reset(reset), .sw(btn[1]),
          .db_level(outer_sensor), .db_tick());

    // car park sensor instance
    car_park_sensor cap_park_unit
        (.clk(clk), .reset(reset), 
         .a(outer_sensor), .b(inner_sensor), 
         .enter(enter), .exit(exit));

    // counter instance
    counter counter_unit
        (.clk(clk), .reset(reset),
         .inc(enter), .dec(exit),
         .val(val));

    // display instance
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .hex3(4'b0), .hex2(4'b0),
         .hex1(val[7:4]), .hex0(val[3:0]),
         .dp_in(4'b0000), .an(an), .sseg(sseg));

endmodule
