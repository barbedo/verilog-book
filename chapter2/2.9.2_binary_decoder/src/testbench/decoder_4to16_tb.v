// 4-to-16 binary decoder testbench

`timescale 1 ns / 10 ps

module decoder_4to16_tb;

    // signal declaration
    reg[4:0]   test_in;
    wire[15:0] out;

    // instance of decoder
    decoder_4to16 uut(.in(test_in), .bcode(out));

    // test vectors
    initial
    begin
        for (test_in = 0; test_in < 5'b10000; test_in = test_in + 1) begin
            # 5;
        end
        $stop;
    end

endmodule