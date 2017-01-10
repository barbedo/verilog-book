// Single digit BCD incrementor

module bcd_digit_incrementor
    (
    input  wire[3:0] bcd_in,
    input  wire      inc,
    output reg[3:0]  bcd_out,
    output reg       carry
    );

    always@*
    begin
        if (inc)
            begin
                if (bcd_in == 4'b1001) begin
                    bcd_out = 4'b0000;
                    carry   = 1'b1;
                end
                else begin
                    bcd_out = bcd_in + 1;
                    carry = 1'b0;
                end
            end
        else
            begin
                bcd_out = bcd_in;
                carry = 1'b0;
            end
    end

endmodule