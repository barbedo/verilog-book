// 12-bit dual-priority encoder

module dual_prio_encoder
    (
    input  wire[12:1] r,
    output reg[3:0]   first, second
    );

    always @*
    begin
        // default values
        first  = 0;
        second = 0;
        if (r[12])
            begin
                if (first == 4'b0000)       first  = 12;
                else if (second == 4'b0000) second = 12;
            end
        if (r[11])
            begin
                if (first == 4'b0000)       first  = 11;
                else if (second == 4'b0000) second = 11;
            end
        if (r[10])
            begin
                if (first == 4'b0000)       first  = 10;
                else if (second == 4'b0000) second = 10;
            end
        if (r[9])
            begin
                if (first == 4'b0000)       first  = 9;
                else if (second == 4'b0000) second = 9;
            end
        if (r[8])
            begin
                if (first == 4'b0000)       first  = 8;
                else if (second == 4'b0000) second = 8;
            end
        if (r[7])
            begin
                if (first == 4'b0000)       first  = 7;
                else if (second == 4'b0000) second = 7;
            end
        if (r[6])
            begin
                if (first == 4'b0000)       first  = 6;
                else if (second == 4'b0000) second = 6;
            end
        if (r[5])
            begin
                if (first == 4'b0000)       first  = 5;
                else if (second == 4'b0000) second = 5;
            end
        if (r[4])
            begin
                if (first == 4'b0000)       first  = 4;
                else if (second == 4'b0000) second = 4;
            end
        if (r[3])
            begin
                if (first == 4'b0000)       first  = 3;
                else if (second == 4'b0000) second = 3;
            end
        if (r[2])
            begin
                if (first == 4'b0000)       first  = 2;
                else if (second == 4'b0000) second = 2;
            end
        if (r[1])
            begin
                if (first == 4'b0000)       first  = 1;
                else if (second == 4'b0000) second = 1;
            end
    end
endmodule