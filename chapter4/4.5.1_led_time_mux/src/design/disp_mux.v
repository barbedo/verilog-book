// Led time-multiplexing circuit with LED patterns
module disp_mux
    (
    input  wire      clk, reset,
    input  wire[7:0] in3, in2, in1, in0,
    output reg[3:0]  an,
    output reg[7:0]  sseg
    );

    // constant declaration
    // refreshing rate aroung 800 Hz (100 MHz / 2^17)
    localparam N = 19;

    // signal declaration
    reg[N-1:0]  q_reg;
    wire[N-1:0] q_next;

    // N-bit counter
    // register
    always @(posedge clk, posedge reset)
        if (reset)
            q_reg <= 0;
        else
            q_reg <= q_next;

    // next-state logic
    assign q_next = q_reg + 1;

    // 2 MSBs of counter to control 4-to-1 mux
    // and to generate active-low enable signal
    always @*
        case (q_reg[N-1:N-2])
            2'b00:
                begin
                    an   = 4'b1110;
                    sseg = in0;
                end
            2'b01:
                begin
                    an   = 4'b1101;
                    sseg = in1;
                end
            2'b10:
                begin
                    an   = 4'b1011;
                    sseg = in2;
                end
            default:
                begin
                    an   = 4'b0111;
                    sseg = in3;
                end
        endcase

endmodule
