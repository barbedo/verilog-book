// Heartbeat circuit

module heartbeat
    (
    input wire  clk, reset,
    output wire[3:0] an,
    output wire[7:0] seg
    );

    // declarations
    localparam N = 1388889; // N * 10 ns = 1 / 72
    reg[7:0]   led3, led2, led1, led0;
    reg[21:0]  counter_reg;
    wire[21:0] counter_next;
    reg[1:0]   pos_reg, pos_next;
    
    // instance of display mux
    disp_mux disp_unit
        (.clk(clk), .reset(1'b0), .in0(led0), .in1(led1),
         .in2(led2), .in3(led3), .an(an), .sseg(seg));

    // body
    // registers
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            begin
                counter_reg <= 0;
                pos_reg     <= 0;
            end
        else
            begin
                counter_reg <= counter_next;
                pos_reg     <= pos_next;
            end
    end

    // next state logic
    assign counter_next = (counter_reg == N-1) ? 0 : counter_reg + 1;

    always @*
    begin
        if (counter_reg == N-1)
            pos_next = (pos_reg == 2'b10) ? 2'b00 : pos_reg + 1;
        else
            pos_next = pos_reg;
    end
    
    always @*
    begin
        case (pos_reg)
            2'b00:
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1111_1001;
                    led2 = 8'b1100_1111;
                    led3 = 8'b1111_1111;
                end
            2'b01:
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1100_1111;
                    led2 = 8'b1111_1001;
                    led3 = 8'b1111_1111;
                end
            2'b10:
                begin
                    led0 = 8'b1100_1111;
                    led1 = 8'b1111_1111;
                    led2 = 8'b1111_1111;
                    led3 = 8'b1111_1001;
                end  
            default:  // we shouldn't be here
                begin
                    led0 = 8'b1111_1111;
                    led1 = 8'b1111_1111;
                    led2 = 8'b1111_1111;
                    led3 = 8'b1111_1111;
                end
       endcase
    end

endmodule
