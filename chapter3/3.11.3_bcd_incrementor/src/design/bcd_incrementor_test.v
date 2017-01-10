// Three-digit BCD incrementor test circuit

module bcd_incrementor_test
    (
    input  wire       clk,
    input  wire[11:0] sw,
    output wire[7:0]  sseg,
    output wire[3:0]  an,
    output wire       led_carry
    );

    // signal declaration
    wire[3:0] out0, out1, out2;
    wire[7:0] led0, led1, led2, led3;
    
    // instance of 3-digit incrementor
    bcd_3digit_incrementor bdc_incrementor_unit
        (.digit0(sw[3:0]), .digit1(sw[7:4]), .digit2(sw[11:8]),
         .out0(out0), .out1(out1), .out2(out2), .carry(led_carry));
    
    // instances of bcd decoder
    bcd_to_sseg bcd_to_sseg_unit0
        (.bcd(out0), .dp(1'b1), .sseg(led0));
    bcd_to_sseg bcd_to_sseg_unit1
        (.bcd(out1), .dp(1'b1), .sseg(led1));
    bcd_to_sseg bcd_to_sseg_unit2
        (.bcd(out2), .dp(1'b1), .sseg(led2));
    // blank rightmost led
    assign led3 = 8'b11111111;
    
    // instance of display mux
    disp_mux disp_unit
        (.clk(clk), .reset(1'b0),
        .in0(led0), .in1(led1),
        .in2(led2), .in3(led3),
        .an(an), .sseg(sseg));

endmodule