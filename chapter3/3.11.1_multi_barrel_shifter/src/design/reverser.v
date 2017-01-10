// Reverse bits

module reverser
   #(
    parameter N=8
    )
    (
    input  wire[N-1:0] in,
    input  wire        en,
    output reg[N-1:0]  out
    );
    
    // signal declaration
    wire[N-1:0] rev;
    
    // body
    always @*
    begin
        if (en == 1'b1)
            out = rev;
        else
            out = in;
    end
    
    // signal routing
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : reverse
            assign rev[i] = in[N-1-i];
        end
    endgenerate

endmodule
    