// 3-to-8 binary decoder

module decoder_3to8
    (
    input  wire[2:0] in,
    output wire[7:0] bcode
    );
    
    // internal signal declaration
    wire[3:0] bcode_lsb;
    wire[7:4] bcode_msb;
    
    // instance of 2-to-4 decoders
    decoder_2to4 dec_2to4_lsb (.en(~in[2]), .in(in[1:0]), .bcode(bcode_lsb));
    decoder_2to4 dec_2to4_msb (.en(in[2]), .in(in[1:0]), .bcode(bcode_msb));
    
    // body
    assign bcode[3:0] = bcode_lsb;
    assign bcode[7:4] = bcode_msb;

endmodule