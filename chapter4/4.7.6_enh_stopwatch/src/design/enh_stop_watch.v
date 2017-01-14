// Nested if-statement description for a stopwatch

module enh_stop_watch
    (
    input  wire       clk,
    input  wire       go, clr, back,
    output wire[3:0]  d3, d2, d1, d0
    );

    // declaration
    localparam DVSR = 10000000;
    reg[23:0]  ms_reg;
    wire[23:0] ms_next;
    reg[3:0]   d3_reg, d2_reg, d1_reg, d0_reg;
    reg[3:0]   d3_next, d2_next, d1_next, d0_next;
    wire       ms_tick;

    // body
    // register
    always @(posedge clk)
    begin
        ms_reg  <= ms_next;
        d3_reg  <= d3_next;
        d2_reg  <= d2_next;
        d1_reg  <= d1_next;
        d0_reg  <= d0_next;
    end

    // next-state logic
    // 0.1 sec tick generator mod-10.000.000
    assign ms_next = (clr || (ms_reg==DVSR && (go || back))) ? 4'b0 :
                     (go || back) ? ms_reg + 1 :
                                    ms_reg;
    assign ms_tick = (ms_reg==DVSR) ? 1'b1 : 1'b0;

    // 4-digit bcd up counter
    always @*
    begin
        // default: keep the previous value
        d0_next = d0_reg;
        d1_next = d1_reg;
        d2_next = d2_reg;
        d3_next = d3_reg;
        if (clr)
            begin
                d0_next = 4'b0;
                d1_next = 4'b0;
                d2_next = 4'b0;
                d3_next = 4'b0;
            end
        else if (ms_tick)
            // count up
            if (go)
                if (d0_reg != 9)
                    d0_next = d0_reg + 1;
                else                                    // reach X.XX.9
                    begin
                        d0_next = 4'b0;
                        if (d1_reg != 9)
                            d1_next = d1_reg + 1;
                        else                            // reach X.X9.9
                            begin
                                d1_next = 4'b0;
                                if (d2_reg != 5)
                                    d2_next = d2_reg + 1;
                                else                    // reach X.59.9
                                    begin
                                        d2_next = 4'b0;
                                        if (d3_reg != 9)
                                            d3_next = d3_reg + 1;
                                        else            // reach 9.59.9 and get stuck
                                            begin
                                                d3_next = d3_reg;
                                                d2_next = d2_reg;
                                                d1_next = d1_reg;
                                                d0_next = d0_reg;
                                            end
                                    end
                            end
                    end
            // count down
            else if (back)
                // get stuck if 0.00.0
                if ({d0_reg, d1_reg, d2_reg, d3_reg} == 16'b0)
                    begin
                        d0_next = 0;
                        d1_next = 0;
                        d2_next = 0;
                        d3_next = 0;
                    end
                else if (d0_reg != 0)
                    d0_next = d0_reg - 1;
                else                    // reach X.XX.0
                    begin
                        d0_next = 9;
                        if (d1_reg != 0)
                            d1_next = d1_reg - 1;
                        else            // reach X.X0.0
                            begin
                                d1_next = 9;
                                if (d2_reg != 0)
                                    d2_next = d2_reg - 1;
                                else   // reach X.00.0
                                    begin
                                        d2_next = 5;
                                        if (d3_reg != 0)
                                            d3_next = d3_reg - 1;
                                        else
                                            d3_next = 9;
                                    end
                            end
                    end
                            
    end
    // output logic
    assign d0 = d0_reg;
    assign d1 = d1_reg;
    assign d2 = d2_reg;
    assign d3 = d3_reg;

endmodule
