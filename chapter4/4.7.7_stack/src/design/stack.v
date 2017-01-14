// Stack

module stack
    #(
     parameter B = 8,  // number of bits a word
               W = 4   // number of address bits
    )
    (
     input wire         clk, reset,
     input wire         push, pop,
     input wire[B-1:0]  w_data,
     output wire        empty, full,
     output wire[B-1:0] r_data
    );

    // signal declaration
    reg[B-1:0] array_reg[2**W-1:0];           // register array
    reg[W-1:0] stack_ptr_reg, stack_ptr_next;
    reg        full_reg, empty_reg, full_next, empty_next;
    wire       wr_en;

    // body
    // register file operation
    always @(posedge clk)
        if (wr_en)
            array_reg[stack_ptr_reg] <= w_data;
    // read operation (always points to top of the stack)
    assign r_data = array_reg[stack_ptr_reg];
    assign wr_en  = push & ~full_reg;

    // stack control logic
    // registers for pointer
    always @(posedge clk, posedge reset)
    if (reset)
        begin
            stack_ptr_reg <= 0;
            empty_reg     <= 1'b1;
            full_reg      <= 1'b0;
        end
    else
        begin
            stack_ptr_reg <= stack_ptr_next;
            empty_reg     <= empty_next;
            full_reg      <= full_next;
        end

     // next state logic
     always @*
     begin
        // default: keep old values
        stack_ptr_next = stack_ptr_reg;
        empty_next     = empty_reg;
        full_next      = full_reg;
        case ({push, pop})
            // 2'b00:           // no op
            2'b01:              // pop
                if (~empty_reg)
                    begin
                        stack_ptr_next = stack_ptr_reg - 1;
                        full_next = 1'b0;
                        if (stack_ptr_next==0)
                            empty_next = 1'b1;
                    end
             2'b10:             // push
                if (~full_reg)
                    begin
                        stack_ptr_next = stack_ptr_reg + 1;
                        empty_next = 1'b0;
                        if (stack_ptr_next==2**W-1)
                            full_next = 1'b1;
                    end
             // 2'b11:             // push and pop
                                   // do nothing, as pointer stays the same
        endcase
     end

    // output
    assign full  = full_reg;
    assign empty = empty_reg;

endmodule
