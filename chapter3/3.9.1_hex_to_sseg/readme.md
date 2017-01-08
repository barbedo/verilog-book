3.9.1 Hexadecimal digit to seven-segment LED decoder
----------------------------------------------------

### Page 68

Here, we use a modified version of the `list_ch04_13_disp_mux.v` file to use it with the Basys3 board. 
The only difference is that we add one to the default parameter N to divide one more time the clk to have the same refreshing rate on the new board (100MHz vs 50MHz).