// Programmable square wave generator

module square_wave_gen
    (
    input  wire      clk, reset,
    input  wire[3:0] on_period, off_period,
    output wire      signal
    );

    // signal declaration
    localparam BASE_CYCLES = 10;
    reg        signal_reg, signal_next;
    reg[3:0]   on_period_reg, off_period_reg;
    wire[3:0]  on_period_next, off_period_next;
    reg[3:0]   period_counter_reg, period_counter_next;
    reg[4:0]   base_counter_reg;
    wire[4:0]  base_counter_next;
    wire       base_tick;

    // body
    // register
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            begin
                signal_reg         <= 1'b0;
                base_counter_reg   <= 0;
                period_counter_reg <= 0;
                on_period_reg      <= 0;
                off_period_reg     <= 0;
            end
        else
            begin
                signal_reg         <= signal_next;
                on_period_reg      <= on_period_next;
                off_period_reg     <= off_period_next;
                base_counter_reg   <= base_counter_next;
                period_counter_reg <= period_counter_next;
            end
    end

    // next-state logic
    // read input
    assign on_period_next = on_period;
    assign off_period_next = off_period;
    assign base_counter_next   = (base_counter_reg == BASE_CYCLES-1) ? 0 : base_counter_reg + 1;
    assign base_tick           = (base_counter_reg == BASE_CYCLES-1) ? 1'b1 : 1'b0;
    
    // detect when to go high or low
    always @*
    begin
        // default: keep old value
        signal_next         = signal_reg;
        period_counter_next = period_counter_reg;
        
        // every 100ns
        if (base_tick)
            begin
                period_counter_next = period_counter_reg + 1;
                // if high
                if (signal_reg)
                    begin
                        // check if configured period already passed
                        // inequality, so if the user changes to a smaller period, the signal
                        // will be changed on next clk
                        // if on or off period are zero, then they will switch by the smallest period (100ns)
                        if (period_counter_reg >= on_period_reg-1 || on_period_reg == 0)
                            begin
                                signal_next         = 1'b0;  // go to low
                                period_counter_next = 0;
                            end
                    end
                // if low
                else
                    begin
                        // check if configured period already passed
                        if (period_counter_reg >= off_period_reg-1 || off_period_reg == 0)
                            begin
                                signal_next         = 1'b1; // go to high
                                period_counter_next = 0;
                            end
                    end
                end
    end
    
    // output
    assign signal = signal_reg;

endmodule