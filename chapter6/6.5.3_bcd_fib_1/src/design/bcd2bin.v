// BCD-to-binary conversion circuit

module bcd2bin
    (
     input  wire      clk, reset,
     input  wire      start,
     input  wire[3:0] bcd1, bcd0,
     output reg       ready, done_tick,
     output wire[6:0] bin
    );

    // symbolic state declaration
    localparam[1:0]
        idle = 2'b00,
        op   = 2'b01,
        done = 2'b10;

    // signal declaration
    reg[1:0]  state_reg, state_next;
    reg[11:0] bcd2b_reg, bcd2b_next;
    reg[2:0]  n_reg, n_next;

    // body
    // FSMD state & data registers
    always @(posedge clk, posedge reset)
        if (reset)
            begin
                state_reg <= idle;
                bcd2b_reg <= 0;
                n_reg     <= 0;
            end
        else
            begin
                state_reg <= state_next;
                bcd2b_reg <= bcd2b_next;
                n_reg     <= n_next;
            end

    // FSMD next-state logic
    always @*
    begin
        // defaults
        state_next = state_reg;
        bcd2b_next = bcd2b_reg;
        n_next     = n_reg;
        ready      = 1'b0;
        done_tick  = 1'b0;
        
        case (state_reg)
            idle:
                begin
                    ready = 1'b1;
                    if (start)
                        begin
                            n_next     = 4;
                            state_next = op;
                            bcd2b_next = {bcd1, bcd0, 4'b0};
                        end
                end
            op:
                begin
                    // shift one right
                    bcd2b_next = bcd2b_reg >> 1;
                    if (bcd2b_reg[8])  // lsb of bcd1
                        // bcd0: shift then sum 5, eq. to sum 10 then shift
                        bcd2b_next[7:4] = {1'b0, bcd2b_reg[7:5]} + 4'b0101;
                        
                    n_next = n_reg - 1;
                    if (n_next == 0)
                        state_next = done;
                end
            done:
                begin
                    done_tick  = 1'b1;
                    state_next = idle;
                end
            default : state_next = idle;
        endcase
    end

    // output
    assign bin = bcd2b_reg[6:0];

endmodule
