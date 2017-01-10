// 12-bit dual-priority encoder test circuit

module dual_prio_test
    (
    input  wire       clk,
    input  wire[11:0] sw,
    output wire[7:0]  sseg,
    output wire[3:0]  an
    );

    // signal declaration
    wire[3:0] out_first, out_second;
    wire[7:0] led0, led1, led2, led3;

    // instance of priority encoder
    dual_prio_encoder prio_encoder_unit
        (.r(sw), .first(out_first), .second(out_second));

    // instances of hex decoder
    // second priority on leftmost LED
    hex_to_sseg sseg_unit_left
        (.hex(out_second), .dp(1'b1), .sseg(led0));
    // first priority on second LED
    hex_to_sseg sseg_unit_right
        (.hex(out_first), .dp(1'b1), .sseg(led1));
    // blank other LEDs
    assign led2 = 8'b11111111;
    assign led3 = 8'b11111111;
    
    // instance of display mux
    disp_mux disp_unit
        (.clk(clk), .reset(1'b0),
        .in0(led0), .in1(led1),
        .in2(led2), .in3(led3),
        .an(an), .sseg(sseg));

endmodule
