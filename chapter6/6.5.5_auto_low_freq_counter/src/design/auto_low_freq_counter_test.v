// Low-frequency counter test

module auto_low_freq_counter_test
    (
     input  wire      clk, reset,
     input  wire      btn,
     input  wire[2:0] sw,
     output wire[3:0] an,
     output wire[7:0] sseg
    );

    // signal declaration
    wire      start;
    reg       si;
    wire[3:0] bcd3, bcd2, bcd1, bcd0;
    wire[1:0] decimal_counter;
    reg[3:0]  dp_in;

    //=============================================
    // generate a tick with variable period
    //=============================================
    localparam N = 27;  // number of counter bits to fit 1s
    reg[N-1:0] q_next = 0, q_reg = 0;
    
    always @(posedge clk)
        q_reg <= q_next;
        
    always @*
    begin
        q_next = q_reg + 1;
        si   = 1'b0;
        case (sw)
            // 0.11 ms period => 9090.91 Hz
            // 1 ms period
            3'b000:
                if (q_reg == 11_000)
                begin
                    si   = 1'b1;
                    q_next = 0;
                end
            // 0.2 ms period => 5000 Hz
            3'b001:
                if (q_reg == 20_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 1 ms period => 1000 Hz
            3'b010:
                if (q_reg == 100_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 3 ms period => 333.3333 Hz
            3'b011:
                if (q_reg == 300_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 60 ms period => 16.6666 Hz
            3'b100:
                if (q_reg == 6_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 170 ms period => 5.88235 Hz
            3'b101:
                if (q_reg == 17_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 760 ms period => 1.315789 Hz
            3'b110:
                if (q_reg == 76_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 1s period => 1 Hz
            3'b111:
                if (q_reg == 100_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
        endcase
    end

    //=============================================
    // Submodules
    //=============================================
    // instance of debouncer
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));

    // instance of low freq counter
    auto_low_freq_counter freq_counter_unit
        (.clk(clk), .reset(reset),
         .start(start), .si(si),
         .bcd3(bcd3), .bcd2(bcd2),
         .bcd1(bcd1), .bcd0(bcd0),
         .decimal_counter(decimal_counter));

    // instance of display unit
     disp_hex_mux disp_unit
         (.clk(clk), .reset(reset),
          .dp_in(dp_in),
          .hex3(bcd3), .hex2(bcd2), .hex1(bcd1), .hex0(bcd0),
          .an(an), .sseg(sseg));

    // decimal counter to dp in circuit
    always @*
    begin
        case (decimal_counter)
            0: dp_in = 4'b1111;
            1: dp_in = 4'b1101;
            2: dp_in = 4'b1011;
            default: dp_in = 4'b0111; // case 3
        endcase
    end

endmodule
