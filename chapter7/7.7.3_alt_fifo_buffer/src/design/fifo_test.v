// Testing circuit for a FIFO buffer

module fifo_test
    (
    input  wire      clk, reset,
    input  wire      btnL, btnR,
    input  wire[2:0] sw,
    output wire[7:0] led
    );

    // signal declaration
    wire[1:0] db_btn;

    // debounce circuits
    debounce btn_db_unit0
        (.clk(clk), .reset(reset), .sw(btnR),
         .db_level(), .db_tick(db_btn[0]));
    debounce btn_db_unit1
        (.clk(clk), .reset(reset), .sw(btnL),
         .db_level(), .db_tick(db_btn[1]));

    // instantiate a 2^2-by-3 fifo
    fifo #(.B(3), .W(2)) fifo_unit
        (.clk(clk), .reset(reset),
         .rd(db_btn[0]), .wr(db_btn[1]), .w_data(sw),
         .r_data(led[2:0]), .full(led[7]), .empty(led[6]));
    // disable unused leds
    assign led[5:3] = 3'b000;

endmodule
