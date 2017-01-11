// Signed integer to floating-point converter

module int_to_fp
    (
    input  wire[7:0] int,
    output wire[12:0] fp
    );

    // internal signal declaration
    wire     int_sign;
    reg[6:0] int_unsigned;
    assign   int_sign = int[7];
    
    wire     fp_sign;
    reg[3:0] fp_exp;
    reg[7:0] fp_frac;
    assign fp_sign = int_sign;
    assign fp = {fp_sign, fp_exp, fp_frac};

    always @*
    begin
        // negative
        if (int_sign) int_unsigned = ~(int[6:0]) + 1;
        // positive
        else int_unsigned = int[6:0];
        
        // exp is how many shifts it takes to turn the value into a fraction
        // frac is the value of the fraction after these shifts
        if (int_unsigned[6]) 
            begin 
                fp_exp  = 7;
                fp_frac = {int_unsigned[6:0], 1'b0};
            end
        else if (int_unsigned[5])
            begin
                fp_exp = 6;
                fp_frac = {int_unsigned[5:0], 2'b00};
            end
        else if (int_unsigned[4])
            begin
                fp_exp = 5;
                fp_frac = {int_unsigned[4:0], 3'b000};
            end
        else if (int_unsigned[3])
            begin
                fp_exp = 4;
                fp_frac = {int_unsigned[3:0], 4'b0000};
            end
        else if (int_unsigned[2])
            begin
                fp_exp = 3;
                fp_frac = {int_unsigned[2:0], 5'b00000};
            end
        else if (int_unsigned[1])
            begin
                fp_exp = 2;
                fp_frac = {int_unsigned[1:0], 6'b000000};
            end
        else if (int_unsigned[0])
            begin
                fp_exp = 1;
                fp_frac = {int_unsigned[0], 7'b0000000};
            end
        else // zero
            begin
                fp_exp = 0;
                fp_frac = 0;
            end
    end

endmodule