// Rotating square circuit

module rot_square
    (
    input  wire      clk, reset,
    input  wire      en,   // enable
    input  wire      cw,   // direction
    output wire[3:0] an,
    output wire[7:0] seg
    );

    // declarations
    localparam N = 12_500_000;   // 10ns per period, count to 1/8 of a second
    reg[7:0]   led3, led2, led1, led0;
    reg[26:0]  time_counter_reg; 
    reg[26:0] time_counter_next;
    reg[2:0]   pos_reg, pos_next;
    // instance of display mux
    disp_mux disp_unit
        (.clk(clk), .reset(1'b0), .in0(led0), .in1(led1),
         .in2(led2), .in3(led3), .an(an), .sseg(seg));

    // body
    // register
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            begin
                time_counter_reg <= 0;
                pos_reg          <= 0;
            end
        else
            begin
                time_counter_reg <= time_counter_next;
                pos_reg          <= pos_next;
            end
    end

    // next state logic
    always @*
    begin
        if (en)
            begin
                if (time_counter_reg == N-1)
                    time_counter_next = 0;
                else
                    time_counter_next = time_counter_reg + 1;
            end
        else
            time_counter_next = 0;
    end
    
    always @*
    begin
        if (time_counter_reg == N-1 && en)
            begin
                if (cw)
                    // 8 positions, so it will loop when over or undeflow
                    pos_next = pos_reg + 3'b001;
                else
                    pos_next = pos_reg - 3'b001;
            end
        else pos_next = pos_reg;
    end
    
    always @*
    begin
       case (pos_reg)
           3'b000:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1001_1100;
               end
           3'b001:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1001_1100;
                   led3 = 8'b1111_1111;
               end
           3'b010:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1001_1100;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b011:
               begin
                   led0 = 8'b1001_1100;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b100:
               begin
                   led0 = 8'b1110_0010;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b101:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1110_0010;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1111_1111;
               end
           3'b110:
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1110_0010;
                   led3 = 8'b1111_1111;
               end
           default:  // 3'b111
               begin
                   led0 = 8'b1111_1111;
                   led1 = 8'b1111_1111;
                   led2 = 8'b1111_1111;
                   led3 = 8'b1110_0010;
               end
       endcase
    end
endmodule
