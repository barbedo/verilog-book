// BCD adjustment circuit

module bcd_adjust
    (
     input  wire       clk, reset,
     input  wire       start,
     input  wire[3:0]  bcd6, bcd5, bcd4, bcd3, bcd2, bcd1, bcd0,
     output wire[3:0]  bcd_out3, bcd_out2, bcd_out1, bcd_out0,
     output wire[1:0]  decimal_counter,
     output reg        ready, done_tick
    );

    // symbolic state declaration
    localparam[1:0]
        idle = 2'b00,
        op   = 2'b01,
        done = 2'b10;

    // signal declaration
    reg[1:0]  state_reg, state_next;
    reg[27:0] bcd_reg, bcd_next;
    reg[1:0]  c_reg, c_next;

    // body
    // FSMD state and data registers
    always @(posedge clk, posedge reset)
        if (reset)
            begin
                state_reg <= idle;
                bcd_reg   <= 0;
                c_reg     <= 0;
            end
        else
            begin
                state_reg <= state_next;
                bcd_reg   <= bcd_next;
                c_reg     <= c_next;
            end

    // FSMD next-state logic
    always @*
    begin
        // defaults
        state_next = state_reg;
        ready      = 1'b0;
        done_tick  = 1'b0;
        bcd_next   = bcd_reg;
        c_next     = c_reg;

        case (state_reg)
            idle:
                begin
                    ready = 1'b1;
                    if (start)
                        begin
                            state_next = op;
                            bcd_next   = {bcd6, bcd5, bcd4, bcd3, 
                                         bcd2, bcd1, bcd0};
                            c_next     = 0;
                        end
                end
            op:
                begin
                    if (bcd_reg[27:24] == 0 && c_reg < 3)
                        begin
                            c_next   = c_reg + 1;
                            bcd_next = bcd_reg << 4;
                        end
                    else
                        state_next = done;
                end
            done:
                begin
                    done_tick  = 1'b1;
                    state_next = idle;
                end
            default: state_next = idle;
        endcase
    end

    // output
    assign decimal_counter = c_reg;
    assign bcd_out3 = bcd_reg[27:24];
    assign bcd_out2 = bcd_reg[23:20];
    assign bcd_out1 = bcd_reg[19:16];
    assign bcd_out0 = bcd_reg[15:12];
 
endmodule