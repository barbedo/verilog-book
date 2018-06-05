// FIFO test vector generator

module fifo_gen
  #(
    parameter B = 8, // number of bits in a word
              T = 20 // clock cycle
  )
  ( 
    output reg        clk, reset,
    output reg        rd, wr,
    output reg[B-1:0] w_data
  );

  // clock generator
  always
  begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
  end

  // ----------------
  // task definitions
  // ----------------
  initial
  begin
    initialize();
    push(4);
    push(3);
    push(2);
    push(1);
    push(0);  // should be full at this point
    repeat(4)
    begin
      pop();  // make it empty
    end
    pop();    // should be empty
    push(7);
    push_n_pop(3);
    pop();
    $stop;
  end

  // system initialization
  task initialize;
  begin
    rd     = 0;
    wr     = 0;
    w_data = 0;
    reset_async();
  end
  endtask

  // push data
  task push(input [B-1:0] data_in);
  begin
    @(negedge clk);
    wr = 1'b1;
    w_data = data_in;
    @(negedge clk);
    wr = 1'b0;
  end
  endtask

  // pop data
  task pop;
  begin
    @(negedge clk);
    rd = 1'b1;
    @(negedge clk);
    rd = 1'b0;
  end
  endtask

  task push_n_pop(input [B-1:0] data_in);
  begin
    @(negedge clk);
    rd = 1'b1;
    wr = 1'b1;
    w_data = data_in;
    @(negedge clk);
    rd = 1'b0;
    wr  = 1'b0;
  end
  endtask

  task reset_async;
  begin
    @(negedge clk);
    reset = 1'b1;
    #(T/4);
    reset = 1'b0;
  end
  endtask

endmodule
