6.3.2 Division circuit
----------------------

### Page 157


#### Testing circuit operation

 - `sw[7:0]`: divisor
 - `sw[15:8]`: divident
 - `btnR`: start
 - `btnD`: reset
 - `led[0]`: ready
 - `led[1]`: done tick (too fast to see)

The two 7-seg LED to the left display the remainder and the two to the right display the quotient.

#### Bug on listing

Note that there is a bug on the listing of the book. The initial index is not `CIBT` as stated, but 
the width of the dividend plus one (`W+1`), otherwise the circuit will not use all the dividend bits 
and the result will be wrong.

So this line on the idle state:
```
n_next = CBIT;
```
Should be changed to:
```
n_next = W+1;
```
