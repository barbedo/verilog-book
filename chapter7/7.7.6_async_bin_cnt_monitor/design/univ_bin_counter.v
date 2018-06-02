// Listing 4.10
module univ_bin_counter
   #(parameter N=8)
   (
    input wire clk, reset,
    input wire syn_clr, load, en, up,
    input wire [N-1:0] d,
    output wire max_tick, min_tick,
    output wire [N-1:0] q
   );

   //signal declaration
   reg [N-1:0] r_reg, r_next;

   // body
   // register
   always @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;  //
      else
         r_reg <= r_next;

   // next-state logic
   always @*
      if (syn_clr)
         r_next = 0;
      else if (load)
         r_next = d;
      else if (en & up)
         r_next = r_reg + 1;
      else if (en & ~up)
          r_next = r_reg - 1;
      else
          r_next = r_reg;

   // output logic
   assign q = r_reg;
   assign max_tick = (r_reg==2**N-1) ? 1'b1 : 1'b0;
   assign min_tick = (r_reg==0) ? 1'b1 : 1'b0;

endmodule