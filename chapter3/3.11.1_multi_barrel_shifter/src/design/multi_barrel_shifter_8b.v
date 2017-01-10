// Multi-directional 8-bit barrel shifter

module multi_dir_barrel_shifter_8b
    (
    input  wire[7:0] a,
    input  wire[2:0] amt,
    input  wire      lr,   // left is 1, right is 0
    output reg[7:0]  y
    );

    // signal declaration
    wire[7:0] out_l, out_r;

    // instantiate shifters
    barrel_shifter_stage_l shift_unit_left
        (.a(a), .amt(amt), .y(out_l));
    barrel_shifter_stage_r shift_unit_right
            (.a(a), .amt(amt), .y(out_r));

    // body
    always @*
    begin
        if (lr == 1'b0) 
            y = out_r;
        else 
            y = out_l;
    end

endmodule
