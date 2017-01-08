// 2-to-4 binary decoder

module decoder_2to4
    (
    input  wire      en,
    input  wire[1:0] in,
    output wire[3:0] bcode
    );
    
    assign bcode[0] = en & ~in[1] & ~in[0];
    assign bcode[1] = en & ~in[1] & in[0];
    assign bcode[2] = en & in[1] & ~in[0];
    assign bcode[3] = en & in[1] & in[0];

endmodule