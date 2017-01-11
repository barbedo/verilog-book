// Signed integer to floating-point converter testbench

`timescale 1 ns / 10ps

module int_to_fp_tb;

    // signal declaration
    reg[7:0]   int;
    wire[12:0] out;
    
    reg[8:0]   count;
    
    // instance of uut
    int_to_fp uut(.int(int[7:0]), .fp(out));

    // test vector
    initial
    begin
        int = 0;
        for (count = 0; count < 9'b1_0000_0000; count = count + 1, int = int + 1)  #2;
        $stop;
    end

endmodule
