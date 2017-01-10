// Single digit BCD incrementor testbench

`timescale 1 ns / 10 ps

module bcd_digit_incrementor_tb;

    // signal declaration
    reg[3:0]  bcd_in;
    reg       inc;
    wire[3:0] bcd_out;
    wire      carry;
    
    // instance of digit incrementor
    bcd_digit_incrementor inc0
        (.bcd_in(bcd_in), .inc(inc), .bcd_out(bcd_out), .carry(carry));

    // test vector
    initial
    begin
        inc = 1'b1;
        for (bcd_in = 0; bcd_in < 10; bcd_in = bcd_in + 1) begin
            #5;
        end
        $stop;
    end

endmodule
