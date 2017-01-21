// FSM implementation of an alternative debouncing circuit

module alt_db_fsm
    (
     input  wire clk, reset,
     input  wire sw,
     output reg  db
    );

    // symbolic state declaration
    localparam[2:0]
        zero    = 3'b000,
        wait1_1 = 3'b001,
        wait1_2 = 3'b010,
        wait1_3 = 3'b011,
        one     = 3'b100,
        wait0_1 = 3'b101,
        wait0_2 = 3'b110,
        wait0_3 = 3'b111;

    // number of counter bits (2^N * 10 ns = 10 ms tick
    localparam N = 20;

    // signal declaration
    reg[N-1:0]  q_reg  = 0;
    wire[N-1:0] q_next;
    wire        m_tick;
    reg[2:0]    state_reg, state_next;

    // body

    //=================================
    // counter to generate 10 ms tick
    //=================================
    always @(posedge clk)
        q_reg <= q_next;
    // next state logic
    assign q_next = q_reg + 1;
    // output logic
    assign m_tick = (q_reg == 0) ? 1'b1 : 1'b0;

    //=================================
    // counter to generate 10 ms tick
    //=================================
    // state register
    always @(posedge clk, posedge reset)
        if (reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
    
    // next-state logic and output logic
    always @*
    begin
        state_next = state_reg;  // default state: the same
        db = 1'b0;               // default output: 0
        case (state_reg)
            zero:
                if (sw)
                    begin
                        db = 1'b1;  // output is set with first rising edge
                        state_next = wait1_1;
                    end
            wait1_1:
                begin
                    db = 1'b1;
                    if (m_tick) state_next = wait1_2;
                end
            wait1_2:
                begin
                    db = 1'b1;
                    if (m_tick) state_next = wait1_3;
                end
            wait1_3:
                begin
                    db = 1'b1;
                    // confirm press or go back to state zero
                    if (m_tick)
                        if (sw) state_next = one;
                        else    state_next = zero;
                end
            one:
                begin
                    db = 1'b1;
                    if (~sw)
                        begin
                            db = 1'b0;
                            state_next = wait0_1;
                        end
                end
            wait0_1:
                if (m_tick) state_next = wait0_2;
            wait0_2:
                if (m_tick) state_next = wait0_3;
            wait0_3:
                // confirm depress or go back to state one
                if (m_tick)
                    if (~sw) state_next = zero;
                    else     state_next = one;
       endcase
    end

endmodule
