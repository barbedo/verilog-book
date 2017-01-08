3.9.2 Sign-magnitude adder
--------------------------

### Page 71

Here, we use a modified version of the `list_ch04_13_disp_mux.v` file to use it with the Basys3 board. 
The only difference is that we add one to the default parameter N to divide one more time the clk to have the same refreshing rate on the new board (100MHz vs 50MHz).

#### Operation of the testing circuit

By default, the number selected by the switches 3 to 0 are displayed on the 7-segment LED. The left pushbutton makes the number selected by the switches 7 to 4 be displayed and the right pushbutton makes the sum of the two selected numbers be displayed.