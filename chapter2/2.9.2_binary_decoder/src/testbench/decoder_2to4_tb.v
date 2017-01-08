// 2-to-4 binary decoder

`timescale 1 ns / 10 ps

module decoder_2to4_tb;

    // signal declaration
    reg       test_en;
    reg[2:0]  test_in;
    wire[3:0] out;

    // instance of decoder
    decoder_2to4 uut(.en(test_en), .in(test_in), .bcode(out));

    // test vector
    initial
    begin

       // disabled block
       test_en = 0;
       for (test_in = 0; test_in < 3'b100; test_in = test_in + 1) begin
           # 5;
       end

       // enabled block
       test_en = 1;
       for (test_in = 0; test_in < 3'b100; test_in = test_in + 1) begin
           # 5;
       end
       
       $stop;
    end

endmodule