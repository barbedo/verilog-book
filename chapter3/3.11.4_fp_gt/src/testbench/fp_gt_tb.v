// Floating point greater-than circuit testbench

`timescale 1 ns / 10 ps

module fp_gt_tb;

    // signal declaration
    reg       sign1, sign2;
    reg[3:0]  exp1, exp2;
    reg[7:0]  frac1, frac2;
    wire      out;

    // instance of uut
    fp_gt uut(.sign1(sign1), .sign2(sign2),
              .exp1(exp1), .exp2(exp2),
              .frac1(frac1), .frac2(frac2),
              .gt(out));

    // test vector
    initial
    begin
        // num1 > num2, same exp, (num1, num2) > 0
        sign1 = 0;
        frac1 = 8'b11000000;
        exp1  = 4'b0100;
        sign2 = 0;
        frac2 = 8'b10100000;
        exp2  = 4'b0100;
        #10;
        // num1 < num 2, same exp, (num1, num2) > 0
        sign1 = 0;
        frac1 = 8'b10100000;
        exp1  = 4'b0100;
        sign2 = 0;
        frac2 = 8'b11000000;
        exp2  = 4'b0100;
        #10;
        // num1 > num 2, exp1 > exp2, (num1, num2) > 0
        sign1 = 0;
        frac1 = 8'b10100000;
        exp1  = 4'b0110;
        sign2 = 0;
        frac2 = 8'b11000000;
        exp2  = 4'b0100;
        #10;
        // num1 < num2, exp1 < exp2, (num1, num2) > 0
        sign1 = 0;
        frac1 = 8'b10100000;
        exp1  = 4'b0100;
        sign2 = 0;
        frac2 = 8'b11000000;
        exp2  = 4'b0110;
        #10;
        // num1 > num2, (num1 > 0, num2 < 0)
        sign1 = 0;
        frac1 = 8'b10100000;
        exp1  = 4'b0100;
        sign2 = 1;
        frac2 = 8'b11000000;
        exp2  = 4'b0110;
        #10;
        // num1 < num2, (num1 < 0, num2 > 0)
        sign1 = 1;
        frac1 = 8'b10100000;
        exp1  = 4'b0100;
        sign2 = 0;
        frac2 = 8'b11000000;
        exp2  = 4'b0110;
        #10;
        // num1 > num2, (num1, num2 < 0)
        sign1 = 1;
        frac1 = 8'b10100000;
        exp1  = 4'b0100;
        sign2 = 1;
        frac2 = 8'b11000000;
        exp2  = 4'b0110;
        #10;
        // num1 < num2, (num1, num2 < 0)
        sign1 = 1;
        frac1 = 8'b10100000;
        exp1  = 4'b0110;
        sign2 = 1;
        frac2 = 8'b11000000;
        exp2  = 4'b0100;
        $stop;
    end


endmodule
