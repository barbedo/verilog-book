// Dual-edge detector - Moore design

module dual_edge_moore
    (
     input  wire clk, reset,
     input  wire level,
     output reg  tick
    );

    // symbolic state declaration
    localparam [1:0] zero = 2'b00,
                     edg  = 2'b01,
                     one  = 2'b10;

    // signal declaration
    reg[1:0] state_reg, state_next;

    // state register
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end

    // next-state logic and output logic
    always @*
    begin
        state_next = state_reg;   // default state: the same
        tick       = 1'b0;        // default output: 0
        case (state_reg)
            zero:
                if (level)
                    state_next = edg;
            edg:
                begin
                    tick = 1'b1;
                    if (level)
                        state_next = one;
                    else
                        state_next = zero;
                end
            one:
                if (~level)
                    state_next = edg;
            default:
                state_next = zero;
        endcase
    end

endmodule
