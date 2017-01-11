// Floating-point to signed integer converter testbench

`timescale 1 ns / 10ps

module fp_to_int_tb;

    // signal declaration
    wire[12:0] fp;
    wire[7:0]  int;
    wire       uf, of;
    
    reg[13:0]  count;
    reg        fp_sign;
    reg[3:0]   fp_exp;
    reg[7:0]   fp_frac;
    assign fp = {fp_sign, fp_exp, fp_frac};
    
    // instance of uut
    fp_to_int uut(.fp(fp), .int(int), .uf(uf), .of(of));
    
    // test vector
    initial
    begin
        // all exponents for frac == 8'b10100000 an sign == 0
        fp_sign = 0;
        fp_exp  = 0;
        fp_frac = 8'b10100000;
        for (count = 0; count < 5'b10000; count = count + 1, fp_exp = fp_exp + 1)  #1;

        // all exponents for frac == 8'b10101000 an sign == 0
        fp_sign = 0;
        fp_exp  = 0;
        fp_frac = 8'b10100000;
        for (count = 0; count < 5'b10000; count = count + 1, fp_exp = fp_exp + 1)  #1;

        // all exponents for frac == 8'b10100000 an sign == 1
        fp_sign = 1;
        fp_exp  = 0;
        fp_frac = 8'b10100000;
        for (count = 0; count < 5'b10000; count = count + 1, fp_exp = fp_exp + 1)  #1;
        $stop;
    end

endmodule
