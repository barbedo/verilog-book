7.5.10 Example of a comprehensive testbench
-------------------------------------------

### Page 204

#### Some notes

`iverilog` linter was complaining about 
`task definition for "clr_counter_sync" has an empty port declaration list!`
because of the empty parenthesis on the definition. Removing them seems
to satisfy the linter:

```verilog
task clr_counter_sync();
to
task clr_counter_sync;
```

Vivado did not like the wire declaration inside the task input list. Changing
removing it seems to resolve the issue.

```verilog
task load_data(input wire [N-1:0] data_in);
to
task load_data(input [N-1:0] data_in);
```
