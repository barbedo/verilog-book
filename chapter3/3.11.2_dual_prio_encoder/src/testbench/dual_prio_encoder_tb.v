// 12-bit dual-priority encoder testbench

`timescale 1 ns / 10 ps

module dual_prio_encoder_tb;

    // signal declaration
    reg[12+1:1] test_r;
    wire[3:0] out_first, out_second;

    // instance of uut
    dual_prio_encoder uut
        (.r(test_r), .first(out_first), .second(out_second));

    // test vector
    initial
    begin
        for (test_r = 0; test_r < 13'b1_0000_0000_0000; test_r = test_r + 1) begin
            #1;
        end
        $stop;
    end
endmodule
