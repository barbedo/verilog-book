// Low-frequency counter

module auto_low_freq_counter
    (
     input  wire      clk, reset,
     input  wire      start, si,
     output wire[3:0] bcd3, bcd2, bcd1, bcd0,
     output wire[1:0] decimal_counter
    );

    // symbolic state declaration
    localparam[2:0]
        idle  = 3'b000,
        count = 3'b001,
        frq   = 3'b010,
        b2b   = 3'b011,
        adj   = 3'b100;

    // signal declaration
    reg[2:0]   state_reg, state_next;
    wire[19:0] prd;
    wire[29:0] dvsr, dvnd, quo;
    reg        prd_start, div_start, b2b_start, adj_start;
    wire       prd_done_tick, div_done_tick, b2b_done_tick, adj_done_tick;
    wire[3:0]  bcd_tmp6, bcd_tmp5, bcd_tmp4, 
               bcd_tmp3, bcd_tmp2, bcd_tmp1, bcd_tmp0;

    //==========================================
    // component instantiation
    //==========================================
    // instantiate period counter
    period_counter prd_count_unit
        (.clk(clk), .reset(reset), .start(prd_start), .si(si),
         .ready(), .done_tick(prd_done_tick), .prd(prd));
    // instantiate division circuit
    div #(.W(30), .CBIT(5)) div_unit
        (.clk(clk), .reset(reset), .start(div_start),
         .dvsr(dvsr), .dvnd(dvnd), .quo(quo), .rmd(),
         .ready(), .done_tick(div_done_tick));
    // instantiate binary-to-BCD converter
    bin2bcd b2b_unit
        (.clk(clk), .reset(reset), .start(b2b_start),
         .bin(quo[24:0]), .ready(), .done_tick(b2b_done_tick),
         .bcd6(bcd_tmp6), .bcd5(bcd_tmp5), .bcd4(bcd_tmp4),
         .bcd3(bcd_tmp3), .bcd2(bcd_tmp2), 
         .bcd1(bcd_tmp1), .bcd0(bcd_tmp0));
    // instance of bcd adjust circuit
    bcd_adjust adj_unit
        (.clk(clk), .reset(reset), .start(adj_start),
         .bcd6(bcd_tmp6), .bcd5(bcd_tmp5), .bcd4(bcd_tmp4),
         .bcd3(bcd_tmp3), .bcd2(bcd_tmp2), 
         .bcd1(bcd_tmp1), .bcd0(bcd_tmp0),
         .bcd_out3(bcd3), .bcd_out2(bcd2),
         .bcd_out1(bcd1), .bcd_out0(bcd0),
         .decimal_counter(decimal_counter),
         .done_tick(adj_done_tick), .ready());
    // signal width extension
    assign dvnd = 30'd1_000_000_000;
    assign dvsr = {10'b0, prd};

    //==========================================
    // master FSM
    //==========================================
    always @(posedge clk, posedge reset)
        if (reset)
            state_reg <= idle;
        else
            state_reg <= state_next;

    always @*
    begin
        state_next = state_reg;
        prd_start  = 1'b0;
        div_start  = 1'b0;
        b2b_start  = 1'b0;
        adj_start  = 1'b0;
        case (state_reg)
            idle:
                if (start)
                    begin
                        prd_start  = 1'b1;
                        state_next = count;
                    end
            count:
                if (prd_done_tick)
                    begin
                        div_start  = 1'b1;
                        state_next = frq;
                    end
            frq:
                if (div_done_tick)
                    begin
                        b2b_start  = 1'b1;
                        state_next = b2b;
                    end
            b2b:
                if (b2b_done_tick)
                    begin
                        adj_start  = 1'b1;
                        state_next = adj;
                    end
            adj:
                if (adj_done_tick)
                    state_next = idle;
        endcase
    end

endmodule
