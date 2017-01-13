// PWM circuit testbench

`timescale 1 ns / 10 ps

module pwm_tb;

    // signal declaration
    localparam T = 10;  // clk period
    reg      clk, reset;
    reg[3:0] duty_cycle;
    wire     pwm_signal;

    reg[4:0] counter;

    // instance
    pwm uut
        (.clk(clk), .reset(reset), 
         .duty_cycle(duty_cycle), .pwm_signal(pwm_signal));

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
        for (duty_cycle = 0, counter = 0; 
             counter < 16; 
             counter = counter + 1, duty_cycle = duty_cycle + 1)
            begin
                repeat(36) @(negedge clk);
            end
        $stop;
    end

endmodule
