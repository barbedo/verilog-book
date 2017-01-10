// Multi-directional barrel shifter testbench

module barrel_shifter_tb;

    localparam N = 32;
    localparam M = 5;

    // signal declaration
    reg[N-1:0]  test_a;
    reg[M:0]    test_amt;
    reg         test_lr;
    wire[N-1:0] out;

    // instance of barrel shifter
    barrel_shifter_rev #(.N(N), .M(M)) uut
        (.a(test_a), .amt(test_amt), .lr(test_lr), .y(out));

    // test vector
    initial
    begin
        // fixed input and direction
        test_a = 8'b11110000;
        test_lr = 1'b0;
        for (test_amt = 0; test_amt < N; test_amt = test_amt + 1) begin
            # 5;
        end
        # 5;
        // now direction
        test_lr = 1'b1;
        for (test_amt = 0; test_amt < N; test_amt = test_amt + 1) begin
            # 5;
        end
        $stop;
    end

endmodule
