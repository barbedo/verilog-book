// Fibonacci circuit with BCD IO

module bcd_fib
    (
     input  wire      clk, reset,
     input  wire      start,
     input  wire[3:0] bcd1, bcd0,
     output reg[3:0]  out_bcd3, out_bcd2, out_bcd1, out_bcd0
    );

    // symbolic state declaration
    localparam[1:0]
        s_idle    = 2'b00,
        s_bcd2bin = 2'b01,
        s_fib     = 2'b10,
        s_bin2bcd = 2'b11;

    // signal declaration
    reg[1:0]   state_reg, state_next;
    reg[3:0]   fib_bcd3_reg, fib_bcd2_reg, fib_bcd1_reg, fib_bcd0_reg;
    reg[3:0]   fib_bcd3_next, fib_bcd2_next, fib_bcd1_next, fib_bcd0_next;
    wire[3:0]  bcd3_tmp, bcd2_tmp, bcd1_tmp, bcd0_tmp;
    reg[4:0]   n_reg, n_next;
    reg[11:0]  bcd2b_reg, bcd2b_next;
    reg[19:0]  t0_reg, t0_next, t1_reg, t1_next;
    reg[12:0]  p2s_reg, p2s_next;

    // FSM state and data registers
    always @(posedge clk, posedge reset)
        if (reset)
            begin
                state_reg    <= s_idle;
                n_reg        <= 0;
                bcd2b_reg    <= 0;
                t0_reg       <= 0;
                t1_reg       <= 0;
                fib_bcd3_reg <= 0;
                fib_bcd2_reg <= 0;
                fib_bcd1_reg <= 0;
                fib_bcd0_reg <= 0;
                p2s_reg      <= 0;
            end
        else
            begin
                state_reg    <= state_next;
                n_reg        <= n_next;
                bcd2b_reg    <= bcd2b_next;
                t0_reg       <= t0_next;
                t1_reg       <= t1_next;
                fib_bcd3_reg <= fib_bcd3_next;
                fib_bcd2_reg <= fib_bcd2_next;
                fib_bcd1_reg <= fib_bcd1_next;
                fib_bcd0_reg <= fib_bcd0_next;
                p2s_reg      <= p2s_next;
            end

    // FSM next-state logic
    always @*
    begin
        // defaults
        state_next    = state_reg;
        bcd2b_next    = bcd2b_reg;
        n_next        = n_reg;
        t0_next       = t0_reg;
        t1_next       = t1_reg;
        fib_bcd3_next = fib_bcd3_reg;
        fib_bcd2_next = fib_bcd2_reg;
        fib_bcd1_next = fib_bcd1_reg;
        fib_bcd0_next = fib_bcd0_reg;
        p2s_next      = p2s_reg;

        case (state_reg)
            s_idle:
                if (start)
                    begin
                        n_next     = 4;
                        state_next = s_bcd2bin;
                        bcd2b_next = {bcd1, bcd0, 4'b0};
                    end
            s_bcd2bin:
                begin
                    bcd2b_next = bcd2b_reg >> 1;
                    if (bcd2b_reg[8])
                        bcd2b_next[7:4] = {1'b0, bcd2b_reg[7:5]} + 4'b0101;
                    n_next = n_reg - 1;
                    if (n_next == 0)
                        begin
                            state_next = s_fib;
                            t0_next    = 0;
                            t1_next    = 20'd1;
                            n_next     = bcd2b_next[4:0]; // truncate if higher
                                                          // will be checked later for overflow
                        end
                end
            s_fib:
                begin
                    if (n_reg == 0)
                        begin
                            t1_next       = 0;
                            state_next    = s_bin2bcd;
                            fib_bcd3_next = 0;
                            fib_bcd2_next = 0;
                            fib_bcd1_next = 0;
                            fib_bcd0_next = 0;
                            n_next        = 4'b1101;
                            p2s_next      = 0;
                        end
                    else if (n_reg == 1)
                        begin
                            state_next = s_bin2bcd;
                            fib_bcd3_next = 0;
                            fib_bcd2_next = 0;
                            fib_bcd1_next = 0;
                            fib_bcd0_next = 0;
                            n_next        = 4'b1101;
                            p2s_next      = t1_reg;
                        end
                    else
                        begin
                            t1_next = t1_reg + t0_reg;
                            t0_next = t1_reg;
                            n_next  = n_reg - 1;
                        end
                end
            s_bin2bcd:
                begin
                    p2s_next = p2s_reg << 1;
                    fib_bcd0_next = {bcd0_tmp[2:0], p2s_reg[12]};
                    fib_bcd1_next = {bcd1_tmp[2:0], bcd0_tmp[3]};
                    fib_bcd2_next = {bcd2_tmp[2:0], bcd1_tmp[3]};
                    fib_bcd3_next = {bcd3_tmp[2:0], bcd2_tmp[3]};
                    n_next = n_reg - 1;
                    if (n_next == 0)
                        state_next = s_idle;
                end
        endcase
    end

    // data path function units for bin2bcd
    assign bcd0_tmp = (fib_bcd0_reg > 4) ? fib_bcd0_reg + 3 : fib_bcd0_reg;
    assign bcd1_tmp = (fib_bcd1_reg > 4) ? fib_bcd1_reg + 3 : fib_bcd1_reg;
    assign bcd2_tmp = (fib_bcd2_reg > 4) ? fib_bcd2_reg + 3 : fib_bcd2_reg;
    assign bcd3_tmp = (fib_bcd3_reg > 4) ? fib_bcd3_reg + 3 : fib_bcd3_reg;

    // output with overflow detection
    always @*
        // input > 31 truncated or fib result > 9999
        if (|bcd2b_reg[6:5] || |t1_reg[19:13])
            begin
                out_bcd3 = 4'b1001;
                out_bcd2 = 4'b1001;
                out_bcd1 = 4'b1001;
                out_bcd0 = 4'b1001;
            end
        else
            begin
                out_bcd3 = fib_bcd3_reg;
                out_bcd2 = fib_bcd2_reg;
                out_bcd1 = fib_bcd1_reg;
                out_bcd0 = fib_bcd0_reg;
            end

endmodule
