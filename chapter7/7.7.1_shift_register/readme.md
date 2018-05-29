7.7.1 Shift register with blocking and nonblocking assignments
--------------------------------------------------------------

### Page 211

#### Module

```verilog
module exp1
  (
    input wire  clk,
    input wire  x0, y0, z0,
    output reg  x3, y3, z3
  );
  ...
  reg x1, x2, y1, y2, z1, z2;
  ...
endmodule
```

#### Attempt 1

```verilog
always @(posedge clk)
begin        // x1_entry = x1; x2_entry = x2; x3_entry = x3;
  x1 <= x0;  // x1_exit = x0
  x2 <= x1;  // x2_exit = x1
  x3 <= x2;  // x3_exit = x2
end          // x1 = x1_exit; x2 = x2_exit; x3 = x3_exit
```

All of the assignments in this attempt are nonblocking. The equivalent blocking
assingments are displayed as comments.

This attempt infers a shift register, since `x1_exit == x0`, `x2_exit == x1` and
`x3_exit == x2` by the end of the `always` block.

#### Attempt 2

```verilog
always @(posedge clk)
begin
  y1 = y0;
  y2 = y1; // y2 = y0
  y3 = y2; // y3 = y0
end
```

All of the assignments in this attempt are blocking. Since each one is executed
after the other and each of them depends on the last one, all of the `y` 
variables are going to have the value of `y0` by the end of the `always` block.

This attempt does not infer a shift register, since `y3 == y2 == y1 == y0`.

#### Attempt 3

```verilog
always @(posedge clk)
begin
  z1 = z0;
  z3 = z2;  // z3 = z2_old
  z2 = z1;  // z2 = z0
end
```

All of the assignments in this attempt are blocking. This time, `z3` depends on
`z2`, which was defined on the previous execution of the `always` block.

This attempt does not infer a a shift register, since by the end of the `always`
block, `z1` wil hold `z0`, `z3` wil hold `z2_old` and `z2` will hold `z0`.