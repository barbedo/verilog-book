// Barrel shifter using multistage shifts

module barrel_shifter_stage_r_16b
    (
    input  wire[15:0] a,
    input  wire[3:0] amt,
    output wire[15:0] y
    );

    // signal declaration
    wire[15:0] s0, s1, s2;

    // body
    // stage 0, shift 0 or 1 bit
    assign s0 = amt[0] ? {a[0], a[15:1]} : a;
    // stage 1, shift 0 or 2 bits
    assign s1 = amt[1] ? {s0[1:0], s0[15:2]} : s0;
    // stage 2, shift 0 or 4 bits
    assign s2 = amt[2] ? {s1[3:0], s1[15:4]} : s1;
    // stage 3, shift 0 or 8 bits
    assign y = amt[3] ? {s2[7:0], s2[15:8]} : s2;
    
endmodule
