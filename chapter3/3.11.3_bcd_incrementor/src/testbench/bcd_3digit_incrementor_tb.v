// Three-digit BCD incrementor testbench

`timescale 1 ns / 10 ps

module bcd_3digit_incrementor_tb;

    // signal declaration
    reg[3:0]  digit0, digit1, digit2;
    wire[3:0] out0, out1, out2;
    wire      carry;

    // instance of uut
    bcd_3digit_incrementor uut
        (.digit0(digit0), .digit1(digit1), .digit2(digit2),
         .out0(out0), .out1(out1), .out2(out2), .carry(carry));

    // test vector
    initial
    begin
        for (digit2 = 0; digit2 < 10; digit2 = digit2 + 1) begin
            for (digit1 = 0; digit1 < 10; digit1 = digit1 + 1) begin
                for (digit0 = 0; digit0 < 10; digit0 = digit0 + 1) begin
                #1;
                end
            end
        end
        $stop;
    end

endmodule
