// Period counter testing circuit

module period_counter_test
    ( 
     input  wire      clk, reset,
     input  wire      btn,
     input  wire[2:0] sw,
     output wire[3:0] an,
     output wire[7:0] sseg,
     output wire      led
    );

    // signal declaration
    wire      start;
    reg       si; 
    wire      start_bcd;
    wire[9:0] bin_period;
    wire[3:0] bcd3, bcd2, bcd1, bcd0;
    wire      ready_pc, ready_bcd;
    assign led = ready_pc & ready_bcd;

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
            // 10 ms period
            3'b000:
                if (q_reg == 1_000_000)
                begin
                    si   = 1'b1;
                    q_next = 0;
                end
            // 100 ms period
            3'b001:
                if (q_reg == 10_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 150 ms period
            3'b010:
                if (q_reg == 15_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 200 ms period
            3'b011:
                if (q_reg == 20_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 400 ms period
            3'b100:
                if (q_reg == 40_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 750 ms period
            3'b101:
                if (q_reg == 75_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 900 ms period
            3'b110:
                if (q_reg == 90_000_000)
                begin
                    si = 1'b1;
                    q_next = 0;
                end
            // 1s period
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
    debounce db_unit
        (.clk(clk), .reset(reset), .sw(btn),
         .db_level(), .db_tick(start));

    // instance of period counter
    period_counter pc_unit
        (.clk(clk), .reset(reset), 
         .start(start), .si(si),
         .ready(ready_pc), .done_tick(start_bcd),
         .prd(bin_period));

    // instance of bin2bcd
    bin2bcd bcd_unit
        (.clk(clk), .reset(reset),
         .start(start_bcd), .done_tick(),
         .ready(ready_bcd), .bin({3'b0, bin_period}),
         .bcd3(bcd3), .bcd2(bcd2),
         .bcd1(bcd1), .bcd0(bcd0));

    // instance of display unit
    disp_hex_mux disp_unit
        (.clk(clk), .reset(reset),
         .dp_in(4'b0111),
         .hex3(bcd3), .hex2(bcd2), .hex1(bcd1), .hex0(bcd0),
         .an(an), .sseg(sseg));

endmodule
