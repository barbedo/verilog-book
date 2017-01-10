// Floating point greater-than test circuit
// led activates when num1 > num2

module fp_gt_test
    (
    input  wire[15:0] sw,
    output wire       led
    );

    // internal signals declaration
    wire      sign1, sign2;
    wire[3:0] exp1,  exp2;
    wire[7:0] frac1, frac2;

    // num1
    assign sign1 = sw[7];
    assign exp1  = {2'b11, sw[6:5]};
    assign frac1 = {3'b100, sw[4:0]};
    // num2
    assign sign2 = sw[15];
    assign exp2  = {2'b11, sw[14:13]};
    assign frac2 = {3'b100, sw[12:8]};
    
    // instance of uut
    fp_gt fp_gt_unit(.sign1(sign1), .sign2(sign2),
                     .exp1(exp1), .exp2(exp2),
                     .frac1(frac1), .frac2(frac2),
                     .gt(led));


endmodule
