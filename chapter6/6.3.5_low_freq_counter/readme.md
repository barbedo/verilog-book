6.3.5 Accurate low-frequency counter
------------------------------------

### Page 167

#### Testing circuit operation

This circuit works similarly to the 6.3.4 example.

Set the period with `sw[2:0]` acording to the table below.

| `sw[2:0]` | period (*ms*) | frequency (*Hz*) |
|:---------:|:-------------:|:----------------:|
|   3'b000  |      120      |      8.333*      |
|   3'b001  |      125      |       8.000      |
|   3'b010  |      150      |       6.666      |
|   3'b011  |      200      |       5.000      |
|   3'b100  |      400      |      2.5000      |
|   3'b101  |      750      |       1.333      |
|   3'b110  |      800      |       1.250      |
|   3'b111  |      1000     |       1.000      |


Press `btnL` and the display will show the frequency in *Hz*. Press `btnD` 
to reset.

(*) Note that from the way the circuit is built (with 1.000.000 as 
dividend to have 3 decimal places), any period smaller than 123 *ms* will have its 
correspondending frequency truncated on the highest bits (`1_000_000/122` has more than
13 bits, which is the width of the input of the `bin2bcd` block), so the display will show
gibberish.

We are also limited by periods greater than 1 *s*, because of the width of the output of the period
counter block. 
