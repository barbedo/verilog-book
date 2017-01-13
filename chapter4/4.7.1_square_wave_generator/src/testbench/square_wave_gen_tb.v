// Programmable square wave generator testbench

`timescale 1 ns / 10 ps;

module square_wave_gen_tb;

    localparam T = 10;  // clk period
    reg       clk, reset;
    reg[3:0]  on_period, off_period;
    wire      signal;

    // instance of uut
    square_wave_gen uut
        (.clk(clk), .reset(reset), .on_period(on_period),
         .off_period(off_period), .signal(signal));

    // clock
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end
    
    initial
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
    end

    initial
    begin
        on_period  = 4'b0011;
        off_period = 4'b0001;
        repeat(100) @(negedge clk);
        on_period  = 4'b0000;
        off_period = 4'b0010;
        repeat(100) @(negedge clk);
        $stop;
    end

endmodule
