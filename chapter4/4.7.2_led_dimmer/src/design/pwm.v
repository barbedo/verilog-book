// PWM circuit

module pwm
    (
    input   wire      clk, reset,
    input   wire[3:0] duty_cycle,
    output  wire      pwm_signal
    );

    // signal declaration
    reg       pwm_reg,     pwm_next;
    reg[3:0]  counter_reg;
    wire[3:0] counter_next;

    // body
    // register
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            begin
                pwm_reg     <= 1'b0;
                counter_reg <= 0;
            end
        else
            begin
                pwm_reg     <= pwm_next;
                counter_reg <= counter_next;
            end
                
    end

    // next-state logic
    assign counter_next = (counter_reg == 4'b1111) ? 0 : counter_reg + 1;
    always @*
    begin
        if (counter_reg < duty_cycle)
            pwm_next = 1'b1;
        else
            pwm_next = 1'b0;
    end
    
    // output logic
    assign pwm_signal = pwm_reg;

endmodule
