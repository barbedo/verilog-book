// 4-bit greater-than circuit
// true when i1 > i0

module greater_than_4b
    (
    input  wire[3:0] i1, i0,
    output wire      gt
    );
    
    // signal declaration
    wire[1:0] i1_msb, i0_msb;  // upper 2 bits of input
    wire[1:0] i1_lsb, i0_lsb;  // lower 2 bits of input
    assign i1_lsb = i1[1:0];
    assign i1_msb = i1[3:2];
    assign i0_lsb = i0[1:0];
    assign i0_msb = i0[3:2];
    
    wire gt_lsb;  // true when i1_lsb > i0_lsb
    wire gt_msb;  // true when i1_msb > i0_msb
    wire eq_msb;  // truen when i1_msb == i0_msb
    
    // 2 2-bit greater-than circuit instances
    greater_than_2b gt_lsb_unit (.i1(i1_lsb), .i0(i0_lsb), .gt(gt_lsb));
    greater_than_2b gt_msb_unit (.i1(i1_msb), .i0(i0_msb), .gt(gt_msb));
    
    // 1 2-bit equal circuit
    eq2 eq2_unit (.a(i1_msb), .b(i0_msb), .aeqb(eq_msb));

    // if i1_msb > i0_msb, then i1 > i0
    // if i1_msb == i0_msb and if i1_lsb > i0_lsb, then i1 > i0
    assign gt = gt_msb | (eq_msb & gt_lsb);
    
endmodule
