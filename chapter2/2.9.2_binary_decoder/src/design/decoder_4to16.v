// 4-to-16 binary decoder

module decoder_4to16
    (
    input  wire[3:0]  in,
    output wire[15:0] bcode
    );

    // internal signal declaration
    wire en_dec0, en_dec1, en_dec2, en_dec3;

    // instances of 2-to-4 decoders
    decoder_2to4 dec_2to4_0 (.en(en_dec0), .in(in[1:0]), .bcode(bcode[3:0]));
    decoder_2to4 dec_2to4_1 (.en(en_dec1), .in(in[1:0]), .bcode(bcode[7:4]));
    decoder_2to4 dec_2to4_2 (.en(en_dec2), .in(in[1:0]), .bcode(bcode[11:8]));
    decoder_2to4 dec_2to4_3 (.en(en_dec3), .in(in[1:0]), .bcode(bcode[15:12]));

    // body
    assign en_dec0 = ~in[3] & ~in[2];
    assign en_dec1 = ~in[3] & in[2];
    assign en_dec2 = in[3] & ~in[2];
    assign en_dec3 = in[3] & in[2];

endmodule