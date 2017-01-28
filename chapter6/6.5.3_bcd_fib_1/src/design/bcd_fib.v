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
    wire[6:0]  bin_fib_in;
    wire[19:0] bin_fib_out;
    reg        bcd2bin_start, fib_start, bin2bcd_start;
    wire       bcd2bin_done_tick, fib_done_tick, bin2bcd_done_tick;
    wire[3:0]  fib_bcd3, fib_bcd2, fib_bcd1, fib_bcd0;

    //==============================
    // component instantiation
    //==============================
    // instance of bcd2bin
    bcd2bin bcd2bin_unit
        (.clk(clk), .reset(reset), .start(bcd2bin_start),
         .bcd1(bcd1), .bcd0(bcd0), .ready(),
         .done_tick(bcd2bin_done_tick), .bin(bin_fib_in));
    
    // instance of fib
    fib fib_unit
        (.clk(clk), .reset(reset), .start(fib_start),
         .i(bin_fib_in[4:0]), .ready(), .done_tick(fib_done_tick),
         .f(bin_fib_out));

    // instance of bin2bcd
    bin2bcd bin2bcd_unit
        (.clk(clk), .reset(reset), .start(bin2bcd_start),
         .bin(bin_fib_out[12:0]), .ready(), .done_tick(bin2bcd_done_tick),
         .bcd3(fib_bcd3), .bcd2(fib_bcd2), .bcd1(fib_bcd1), .bcd0(fib_bcd0));
    
    // output with overflow detection
    always @*
        if (|bin_fib_out[19:13])
            begin
                out_bcd3 = 4'b1001;
                out_bcd2 = 4'b1001;
                out_bcd1 = 4'b1001;
                out_bcd0 = 4'b1001;
            end
        else
            begin
                out_bcd3 = fib_bcd3;
                out_bcd2 = fib_bcd2;
                out_bcd1 = fib_bcd1;
                out_bcd0 = fib_bcd0;
            end

    //==============================
    // master FSM
    //==============================
    always @(posedge clk, posedge reset)
        if (reset)
            state_reg <= s_idle;
        else
            state_reg <= state_next;

    always @*
    begin
        // defaults
        state_next    = state_reg;
        bcd2bin_start = 1'b0;
        fib_start     = 1'b0;
        bin2bcd_start = 1'b0;
        
        case (state_reg)
            s_idle:
                if (start)
                    begin
                        bcd2bin_start = 1'b1;
                        state_next    = s_bcd2bin;
                    end
            s_bcd2bin:
                if (bcd2bin_done_tick)
                    begin
                        fib_start  = 1'b1;
                        state_next = s_fib;
                    end
            s_fib:
                if (fib_done_tick)
                    begin
                        bin2bcd_start = 1'b1;
                        state_next    = s_bin2bcd;
                    end
            s_bin2bcd:
                if (bin2bcd_done_tick)
                    state_next = s_idle;
            default: state_next = s_idle;
        endcase
    end
endmodule
