// 2-bit greater-than circuit
// true when i1 > i0

module greater_than_2b
    // IO declaration
    (
    input  wire[1:0] i1, i0, 
    output wire      gt
    );
    
    // signal declaration
    // sum-of-products terms
    wire p2, p1, p0;
    
    // body
    // sum of three product terms
    assign gt = p2 + p1 + p0;
    // product terms
    assign p2 = ~i1[1] & i1[0] & ~i0[1] & ~i0[0];
    assign p1 = i1[1] & ~i0[1];
    assign p0 = i1[1] & i1[0] & i0[1] & ~i0[0];
    
endmodule
