// Alternative debouncer testbench

`timescale 1 ns / 10 ps

module alt_db_fsm_tb;

    // signal declaration
    localparam T = 10; // clk period
    reg  clk, reset;
    reg  sw;
    wire db;
    
    // instance of uut
    alt_db_fsm uut
        (.clk(clk), .reset(reset), .sw(sw), .db(db));

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
        sw = 1'b0;
        repeat(3) @(negedge clk);
        #(T/4);     // sw changes outside of clock edge
        sw = 1'b1;
        // simulate bouncing on rising
        #(1000*T);
        sw = 1'b0;
        #(1000*T);
        sw = 1'b1;
        #(1000*T);
        sw = 1'b0;
        #(1000*T);
        sw = 1'b1;
        // wait for 100 ms
        #100000000;
        #(T/4);     // sw changes outside of clock edge
        sw = 1'b0;
        // simulate bouncing on falling
        #(1000*T);
        sw = 1'b1;
        #(1000*T);
        sw = 1'b0;
        #(1000*T);
        sw = 1'b1;
        #(1000*T);
        sw = 1'b0;
        // wait for 20 + 10 ms
        #30000000;
        $stop;
    end

endmodule
