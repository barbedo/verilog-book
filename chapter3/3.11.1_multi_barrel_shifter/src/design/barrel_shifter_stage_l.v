// Barrel shifter using multistage shifts

module barrel_shifter_stage_l
    (
    input  wire[7:0] a,
    input  wire[2:0] amt,
    output wire[7:0] y
    );

    // signal declaration
    wire[7:0] s0, s1;

    // body
    // stage 0, shift 0 or 1 bit
    assign s0 = amt[0] ? {a[6:0], a[7]} : a;
    // stage 1, shift 0 or 2 bits
    assign s1 = amt[1] ? {s0[5:0], s0[7:6]} : s0;
    // stage 2, shift 0 or 4 bits
    assign y = amt[2] ? {s1[3:0], s1[7:4]} : s1;

endmodule
