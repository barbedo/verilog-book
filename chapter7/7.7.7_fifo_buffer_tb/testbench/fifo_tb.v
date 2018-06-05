// FIFO buffer testbench

`timescale 1ns / 10 ps

module fifo_tb();

  // declaration
  localparam T = 20; // clock period
  wire      clk, reset;
  wire      rd, wr;
  wire[2:0] w_data, r_data;
  wire      empty, full;

  // uut instantiation
  fifo #(.B(3), .W(2)) uut
    (.clk(clk), .reset(reset), .rd(rd), .wr(wr),
     .w_data(w_data), .r_data(r_data),
     .empty(empty), .full(full));

  // test vector generator
  fifo_gen #(.B(3)) gen_unit
    (.clk(clk), .reset(reset),
     .rd(rd), .wr(wr), .w_data(w_data));

  // monitor instantiation
  fifo_monitor #(.B(3), .W(2)) mon_unit
    (.clk(clk), .reset(reset), .rd(rd), .wr(wr),
     .w_data(w_data), .r_data(r_data),
     .empty(empty), .full(full));

endmodule