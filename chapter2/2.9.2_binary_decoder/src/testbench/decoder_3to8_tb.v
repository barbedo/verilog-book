// 3-to-8 binary decoder testbench

`timescale 1 ns / 10 ps

module decoder_3to8_tb;

    // signal declaration
    reg[3:0]  test_in;
    wire[7:0] out;
    
    // instance of decoder
    decoder_3to8 uut(.in(test_in), .bcode(out));
    
    // test vectors
    initial
    begin
        for (test_in = 0; test_in < 4'b1000; test_in = test_in + 1) begin
            # 5;
        end
        $stop;
    end
    
endmodule
