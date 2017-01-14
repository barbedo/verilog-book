// Rotating LED banner circuit

module led_banner
    (
    input wire       clk, reset,
    input wire       en, dir,   // dir==1 is left, 0 is right
    output wire[3:0] an,
    output wire[7:0] seg
    );

    // declarations
    localparam N = 12_500_000;   // 10ns per period, count to 1/8 of a second
    wire[3:0]  num[9:0];
    reg[3:0]   led[3:0];
    reg[26:0]  counter_reg;
    wire[26:0] counter_next;
    reg[3:0]   pos_reg, pos_next;   
    // instance of display mux
    disp_hex_mux disp_unit
        (.clk(clk), .reset(1'b0), .hex0(led[0]), .hex1(led[1]),
         .hex2(led[2]), .hex3(led[3]), .dp_in(4'b1111), .an(an), .sseg(seg));
    // populate with digits 0 to 9
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : assign_num
            assign num[9-i] = i;
        end
    endgenerate

    // body
    // registers
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            begin
                counter_reg <= 0;
                pos_reg     <= 0;
            end
        else if (en)
            begin
                counter_reg <= counter_next;
                pos_reg     <= pos_next;
            end
    end

    // next state logic
    assign counter_next = (counter_reg == N-1) ? 0 : counter_reg + 1;

    // adjust position
    always @*
    begin
        if (counter_reg == N-1)
            pos_next = (pos_reg == 9 && ~dir) ? 0 :     // dont go to 0x/a/
                       (pos_reg == 0 && dir)  ? 9 :     // dont loop to 0xf
                       (dir)                  ? pos_reg - 1 : pos_reg + 1;
        else
            pos_next = pos_reg;
    end


    always @*
    begin
        case (pos_reg)
            4'd0:
                begin
                    led[3] = num[9];
                    led[2] = num[8];
                    led[1] = num[7];
                    led[0] = num[6];
                end
            4'd1:
                begin
                    led[3] = num[8];
                    led[2] = num[7];
                    led[1] = num[6];
                    led[0] = num[5];
                end
            4'd2:
                begin
                    led[3] = num[7];
                    led[2] = num[6];
                    led[1] = num[5];
                    led[0] = num[4];
                end
            4'd3:
                begin
                    led[3] = num[6];
                    led[2] = num[5];
                    led[1] = num[4];
                    led[0] = num[3];
                end
            4'd4:
                begin
                    led[3] = num[5];
                    led[2] = num[4];
                    led[1] = num[3];
                    led[0] = num[2];
                end
            4'd5:
                begin
                    led[3] = num[4];
                    led[2] = num[3];
                    led[1] = num[2];
                    led[0] = num[1];
                end
            4'd6:
                begin
                    led[3] = num[3];
                    led[2] = num[2];
                    led[1] = num[1];
                    led[0] = num[0];
                end
            4'd7:
                begin
                    led[3] = num[2];
                    led[2] = num[1];
                    led[1] = num[0];
                    led[0] = num[9];
                end
            4'd8:
                begin
                    led[3] = num[1];
                    led[2] = num[0];
                    led[1] = num[9];
                    led[0] = num[8];
                end
            4'd9:
                begin
                    led[3] = num[0];
                    led[2] = num[9];
                    led[1] = num[8];
                    led[0] = num[7];
                end
            default:  // we shouldn't be here
                begin
                    led[3] = 4'b1111;
                    led[2] = 4'b1111;
                    led[1] = 4'b1111;
                    led[0] = 4'b1111;
                end
        endcase
    end
endmodule
