// 4-bit greater-than circuit testbench

`timescale 1 ns / 10 ps

module greater_than_4b_tb;

    // signal declaration
    // 1-bit more than necessary on inputs to avoid overflow on for loops
    reg[5:0] test_in1, test_in0;
    wire     test_out;

    // instance of circuit
    greater_than_4b uut(.i1(test_in1), .i0(test_in0), .gt(test_out));

    // test vector
    initial
    begin
        for (test_in1 = 0; test_in1 < 5'b10000; test_in1 = test_in1 + 1) begin
            for (test_in0 = 0; test_in0 < 5'b10000; test_in0 = test_in0 + 1) begin
                # 2;
            end
        end
        $stop;
    end

endmodule
