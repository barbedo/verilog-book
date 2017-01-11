// Floating-point to signed integer

module fp_to_int
    (
    input  wire[12:0] fp,
    output reg[7:0]   int,
    output reg        uf, of
    );

    // internal signal declaration
    wire      fp_sign;
    wire[3:0] fp_exp;
    wire[7:0] fp_frac;
    assign {fp_sign, fp_exp, fp_frac} = fp;

    reg[6:0]  int_unsigned;
    // buffer == {overflow_part (23:15), 
    //            int_abs_val   (14:8),
    //            fp_fraction   (7:0)}
    // after shifting the buffer by fp_exp, we can extract
    // the absolute value of the integer of the buffer
    reg[23:0] buffer;

    always @*
    begin
        buffer[7:0]  = fp_frac[7:0];
        buffer[23:8] = 0;

        // barrel shift because i'm lazy
        buffer = buffer << fp_exp;

        int_unsigned = buffer[14:8];

        // negative
        if (fp_sign) int = {1'b1, ~(int_unsigned) + 1};
        // positive
        else int = {1'b0, int_unsigned};
        
        uf = 1'b0;
        of = 1'b0;
        // detect underflow
        if (buffer[23:8] == 0) uf = 1'b1;
        // detect overflow
        else if (buffer[23:15] != 0) of = 1'b1;
    end

endmodule
