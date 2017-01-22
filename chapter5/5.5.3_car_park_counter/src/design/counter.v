// Synchronous 8-bit increment and decrement counter

module counter
    (
     input  wire      clk, reset,
     input  wire      inc, dec,
     output wire[7:0] val
    );

    // signal declaration
    reg[7:0] q_state, q_next;

    // body
    // state register
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            q_state <= 0;
        else
            q_state <= q_next;
    end

    // next-state logic
    always @*
    begin
        q_next = q_state; // default: the same
        if (inc && q_state != 8'b1111_1111) // overflow check
            q_next = q_state + 1;
        else if (dec && q_state != 8'b0000_0000) // underflow check
            q_next = q_state - 1;
    end

    // output assignment
    assign val = q_state;

endmodule
