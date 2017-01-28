// BCD-to-binary conversion circuit testbench

`timescale 1 ns / 10 ps

module bcd2bin_tb;

    // signal declaration
    localparam T = 10; // clk period
    reg       clk, reset;
    reg       start;
    reg[3:0]  bcd1, bcd0;
    wire      ready, done_tick;
    wire[6:0] bin;

    // instance of uut
    bcd2bin uut
        (.clk(clk), .reset(reset), .start(start),
         .bcd1(bcd1), .bcd0(bcd0), .ready(ready),
         .done_tick(done_tick), .bin(bin));

    // clock
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end

    // reset
    initial
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
    end

    // test vector
    initial
    begin

        repeat(10) @(negedge clk); // wait a bit

        for (bcd1 = 0; bcd1 < 10; bcd1 = bcd1 + 1) begin
            for (bcd0 = 0; bcd0 < 10; bcd0 = bcd0 + 1) begin
                start = 1'b1;
                @(posedge done_tick); // wait for result
                start = 1'b0;
                repeat(3) @(negedge clk); // wait a bit
            end
        end

        $stop;
    end

endmodule
