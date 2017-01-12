// Floating-point adder testing circuit

module fp_adder_test
    (
    input  wire       clk,
    input  wire[15:0] sw,
    output wire[3:0]  an,
    output wire[7:0]  sseg
    );

    // signal declaration
    wire      sign1, sign2, sign_out;
    wire[3:0] exp1, exp2, exp_out;
    wire[7:0] frac1, frac2, frac_out;
    wire[7:0] led0, led1, led2, led3;

    // body
    // set up the fp adder input signals
    assign sign1 = sw[15];
    assign exp1  = 4'b0010;
    assign frac1 = {1'b1, sw[14:12], 4'b0000};
    assign sign2 = sw[11];
    assign exp2  = sw[10:7];
    assign frac2 = {1'b1, sw[6:0]};

    // instance of fp adder
    fp_adder fp_unit
        (.sign1(sign1), .sign2(sign2),
         .exp1(exp1), .exp2(exp2),
         .frac1(frac1), .frac2(frac2),
         .sign_out(sign_out), .exp_out(exp_out),
         .frac_out(frac_out));

    // three instances of hex decoders
    // exponent
    hex_to_sseg sseg_unit_0
        (.hex(exp_out), .dp(1'b0), .sseg(led0));
    // 4 LSBs of fraction
    hex_to_sseg sseg_unit_1
        (.hex(frac_out[3:0]), .dp(1'b1), .sseg(led1));
    // 4 MSBs of fraction
    hex_to_sseg sseg_unit_2
        (.hex(frac_out[7:4]), .dp(1'b0), .sseg(led2));
    // sign
    assign led3 = (sign_out) ? 8'b11111110 : 8'b11111111;

    // instance of 7-seg LED display mux
    disp_mux disp_unit
        (.clk(clk), .reset(1'b0), .in0(led0), .in1(led1),
         .in2(led2), .in3(led3), .an(an), .sseg(sseg));

endmodule
 