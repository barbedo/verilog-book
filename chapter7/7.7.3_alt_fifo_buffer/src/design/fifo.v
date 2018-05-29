// FIFO buffer

module fifo
  #(
      parameter  B = 8,  // number of bits in a word
                 W = 4   // number of address bits
  )
  (
      input  wire        clk, reset,
      input  wire        rd, wr,
      input  wire[B-1:0] w_data,
      output reg         empty, full,
      output wire[B-1:0] r_data
  );

  // signal declaration
  reg[B-1:0]  array[2**W-1:0];   // register array
  reg[W-1:0]  w_ptr, r_ptr;
  wire[W-1:0] w_ptr_succ, r_ptr_succ;
  wire        wr_en;

  // register file read operation
  assign r_data = array[r_ptr];
  // write enabled only when FIFO is not full
  assign wr_en = wr & ~full;

  // successive pointer values
  assign w_ptr_succ = w_ptr + 1;
  assign r_ptr_succ = r_ptr + 1;

  // merged register and next-state logic
  always @(posedge clk, posedge reset)
  begin

    // register file write operation
    if (wr_en)
      array[w_ptr] <= w_data;

    // reset values
    if (reset)
      begin
        w_ptr <= 0;
        r_ptr <= 0;
        full  <= 1'b0;
        empty <= 1'b1;
      end
    
    // next-state logic
    else
      case ({wr, rd})
        // 2'b00: no op
        2'b01: // read
          if (~empty)
            begin
              r_ptr <= r_ptr_succ;
              full  <= 1'b0;
              if (r_ptr_succ == w_ptr)
                empty <= 1'b1;
            end
        2'b10: // write
          if (~full)
            begin
              w_ptr <= w_ptr_succ;
              empty <= 1'b0;
              if (w_ptr_succ == r_ptr)
                full <= 1'b1; 
            end
        2'b11: // write and read
          begin
            w_ptr <= w_ptr_succ;
            r_ptr <= r_ptr_succ;
          end
      endcase

  end

endmodule
