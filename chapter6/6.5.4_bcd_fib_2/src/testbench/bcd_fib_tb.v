// Fibonnaci circuit with BCD IO testbench

`timescale 1 ns / 10 ps;

module bcd_fib_tb;

    // signal declaration
    localparam T = 10; // clk period
    reg        clk, reset;
    reg        start;
    reg[3:0]   bcd1, bcd0;
    wire[3:0]  out_bcd3, out_bcd2, out_bcd1, out_bcd0;

    // instance of uut
    bcd_fib uut
        (.clk(clk), .reset(reset), .start(start),
         .bcd1(bcd1), .bcd0(bcd0),
         .out_bcd3(out_bcd3), .out_bcd2(out_bcd2), 
         .out_bcd1(out_bcd1), .out_bcd0(out_bcd0));

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

        repeat(1) @(negedge clk); // wait a bit

        for (bcd1 = 0; bcd1 < 10; bcd1 = bcd1 + 1) begin
            for (bcd0 = 0; bcd0 < 10; bcd0 = bcd0 + 1) begin
                // hold start for one clock
                start = 1'b1;
                #T;
                start = 1'b0;
                
                // wait for result, since there is no signal
                // tell that the calculation has ended
                repeat(50) @(negedge clk);
            end
        end

        $stop;
    end

endmodule
