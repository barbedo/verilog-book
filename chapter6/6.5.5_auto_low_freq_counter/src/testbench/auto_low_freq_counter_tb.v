// // Low-frequency counter testbench

`timescale 1 ns / 10 ps

module auto_low_freq_counter_tb;

    // signal declaration
    localparam T = 10; // clk period
    reg        clk, reset;
    reg        start;
    reg        si1, si2, si3;  // test signals
    reg[1:0]   sel;
    localparam cnt1 = 11_000;
    localparam cnt2 = 300_000;
    localparam cnt3 = 17_000_000;
    wire        si;
    wire[3:0]  bcd3, bcd2, bcd1, bcd0;
    wire[1:0]  decimal_counter;

    // instance of uut
    auto_low_freq_counter uut
        (.clk(clk), .reset(reset),
         .start(start), .si(si),
         .bcd3(bcd3), .bcd2(bcd2),
         .bcd1(bcd1), .bcd0(bcd0),
         .decimal_counter(decimal_counter));

    // selection of input source
    assign si = (sel == 0) ? si1 :
                (sel == 1) ? si2 :
                (sel == 2) ? si3 : 1'bx;

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

    // signal one: 0.11 ms period => 9090.91Hz
    always
    begin
        si1 = 1'b0;
        #(cnt1*T);
        si1 = 1'b1;
        #T;
    end

    // signal two: 3 ms period => 333.333Hz
    always
    begin
        si2 = 1'b0;
        #(cnt2*T);
        si2 = 1'b1;
        #T;
    end

    // signal three: 170 ms period => 5.88235Hz
    always
    begin
        si3 = 1'b0;
        #(cnt3*T);
        si3 = 1'b1;
        #T;
    end

    // test vector
    initial
    begin

        repeat(5) @(negedge clk); // wait a few clocks

        // signal 1
        sel = 0;
        start = 1;
        repeat(5) @(negedge clk); // wait a few clocks
        start = 0;
        #(cnt1*T*3); // wait 2 cycles
        repeat(5) @(negedge clk); // wait a few clocks

        // signal 2
        sel = 1;
        start = 1;
        repeat(5) @(negedge clk); // wait a few clocks
        start = 0;
        #(cnt2*T*3); // wait 2 cycles
        repeat(5) @(negedge clk); // wait a few clocks

        // signal 3
        sel = 2;
        start = 1;
        repeat(5) @(negedge clk); // wait a few clocks
        start = 0;
        #(cnt3*T*3); // wait 2 cycles
        repeat(5) @(negedge clk); // wait a few clocks

        $stop;
    end

endmodule
