// FIFO buffer monitor

module fifo_monitor
  #(
    parameter B = 8,  // number of bits in a word
              W = 4   // number of address bits
  )
  (
    input wire        clk, reset,
    input wire        rd, wr,
    input wire[B-1:0] w_data,
    input wire        empty, full,
    input wire[B-1:0] r_data
  );

  reg[B-1:0] test_fifo [W**2-1:0];
  reg[W-1:0] head_ptr,      tail_ptr;
  reg[B-1:0] head_value,    tail_value;
  reg[B-1:0] expected_data;
  reg        expected_empty, expected_full;
  reg[39:0]  err_msg; // 5-letter message
  integer    i;

  initial
    $display("time  clk  reset  rd    wr  w_data  r_data  empty  full");

  always @(posedge clk, posedge reset)
  begin
    if (reset)
      begin
        for (i = 0; i < 2**W; i = i + 1) test_fifo[i] <= 0;
        tail_ptr <= 0;
        head_ptr <= 0;
      end

    else
      begin

        // get the expected read data
        expected_data = test_fifo[tail_ptr];

        // determine the expected values by updating the monitor fifo
        if (rd && ~empty)
          begin
            tail_ptr <= tail_ptr + 1;
          end
        else if (wr && ~full)
          begin
            head_ptr  <= head_ptr + 1;
            test_fifo[head_ptr] <= w_data;
          end
        else if (rd && wr)
          begin
            test_fifo[head_ptr] <= w_data;
            head_ptr  <= head_ptr + 1;
            tail_ptr <= tail_ptr + 1;
          end
        if (empty)
          expected_empty = 1'b1;
        else if (full)
          expected_full = 1'b1;
        else
          begin
            expected_empty = 1'b0;
            expected_full  = 1'b0;
          end

    if (~(r_data == expected_data
          && expected_empty == empty
          && expected_full  == full))
      err_msg = "ERROR";

    $display("%5d,  %b    %b    %b     %b      %d       %d      %b     %b     %s",
             $time, clk, reset, rd, wr, w_data, r_data, empty, full, err_msg);

      end
  end

endmodule