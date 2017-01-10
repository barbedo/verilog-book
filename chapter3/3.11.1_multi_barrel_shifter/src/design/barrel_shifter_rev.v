// Multi-directional 8-bit barrel shifter with reversing circuit

module barrel_shifter_rev
   #(
    parameter N=8,
    parameter M=3
    )
    (
    input  wire[N-1:0] a,
    input  wire[M-1:0] amt,
    input  wire        lr,   // left is 1, right is 0
    output wire[N-1:0] y
    );
    
    // internal signal declaration
    wire[N-1:0] shifter_in, shifter_out;

    // instantiate shifters depending on bit width
    generate
        if (N == 8)
            barrel_shifter_stage_r shift_unit_left
                (.a(shifter_in), .amt(amt), .y(shifter_out));
        else if (N == 16)
            barrel_shifter_stage_r_16b shift_unit_left
                (.a(shifter_in), .amt(amt), .y(shifter_out));
        else if (N == 32)
            barrel_shifter_stage_r_32b shift_unit_left
                 (.a(shifter_in), .amt(amt), .y(shifter_out));
    endgenerate

    // instantiate reversers
    reverser #(.N(N)) rev_pre (.in(a), .en(lr), .out(shifter_in));
    reverser #(.N(N)) rev_pos (.in(shifter_out), .en(lr), .out(y));

endmodule
