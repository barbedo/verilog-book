// Floating point greater-than circuit
// out == 1 when 1 > 2

module fp_gt
    (
    input  wire      sign1, sign2,
    input  wire[3:0] exp1,  exp2,
    input  wire[7:0] frac1, frac2,
    output reg       gt
    );

    // body
    always @*
    begin
        // sort input with greatest absolute value
        if ({exp1, frac1} == {exp2, frac2}) gt = 1'b0;
        else if ({exp1, frac1} > {exp2, frac2})
            begin
                if ((sign1 == 1'b0 && sign2 == 1'b0)
                     || (sign1 == 1'b0 && sign2 == 1'b1)) gt = 1'b1;
                else gt = 1'b0;
            end
        else
            begin
                if ((sign1 == 1'b1 && sign2 == 1'b1)
                     || (sign1 == 1'b0 && sign2 == 1'b1)) gt = 1'b1;
                else gt = 1'b0;
            end
    end

endmodule
