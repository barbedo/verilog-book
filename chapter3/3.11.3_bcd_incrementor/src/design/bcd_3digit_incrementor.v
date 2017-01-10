// Three-digit BCD incrementor

module bcd_3digit_incrementor
    (
    input  wire[3:0] digit0, digit1, digit2,
    output wire[3:0] out0, out1, out2,
    output wire      carry
    );

    // internal signal declaration
    wire carry0, carry1;
    
    // instances of digit incrementors
    bcd_digit_incrementor inc0
        (.bcd_in(digit0), .inc(1'b1), .bcd_out(out0), .carry(carry0));
    bcd_digit_incrementor inc1
        (.bcd_in(digit1), .inc(carry0), .bcd_out(out1), .carry(carry1));
    bcd_digit_incrementor inc2
        (.bcd_in(digit2), .inc(carry1), .bcd_out(out2), .carry(carry));

endmodule