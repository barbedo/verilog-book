// Mealy and Moore edge detectors comparison

`timescale 1 ns / 10 ps

module edge_detect_tb;

    // signal declaration
    localparam T = 10; //clk period
    reg  clk, reset;
    reg  level;
    wire tick_mealy;
    wire tick_moore;

    // instance
    edge_detect_moore edg_moore
        (.clk(clk), .reset(reset), .level(level),
         .tick(tick_moore));
    // mealy edge detector instance
    edge_detect_mealy edg_mealy
        (.clk(clk), .reset(reset), .level(level),
         .tick(tick_mealy));

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
        level = 1'b0;
        repeat(3) @(negedge clk);
        level = 1'b1;
        repeat(3) @(negedge clk);
        level = 1'b1;
        @(negedge clk);
        level = 1'b0;
        repeat(3) @(negedge clk);
        $stop;
    end

endmodule
