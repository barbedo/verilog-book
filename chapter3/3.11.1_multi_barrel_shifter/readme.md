3.11.1 Multifunction barrel shifter
-----------------------------------

### Page 80

#### First barrel shifter structure

```
lr
+      input  shift_amt          input  shift_amt
|        +        +                +        +
|        |        |                |        |
|        |        |                |        |
|        |        |                |        |
|    +---+--------+-------+    +---+--------+-------+
|    |                    |    |                    |
|    |  barrel_shifter_r  |    |  barrel_shifter_l  |
|    |                    |    |                    |
|    |                    |    |                    |
|    +---------+----------+    +-----------+--------+
|              |                           |
|              |                           |
|              |                           |
|              +----------+    +-----------+
|                         |    |
|                         |    |
|                     +---+----+-----+
|                     |              |
+---------------------+     sel      |
                      |              |
                      +------+-------+
                             |
                             + out

```

#### Cell usage report
```
Report Cell Usage: 
+------+-----+------+
|      |Cell |Count |
+------+-----+------+
|1     |LUT6 |    24|
|2     |IBUF |    12|
|3     |OBUF |     8|
+------+-----+------+
```

#### Barrel shifter with reverse circuit
```
lr    amt
 +     +     in
 |     |     +
 |     |     |
 |     |     |
 |     | +---v---+
 +------->  rev  |
 |     | +---+---+
 |     |     | shifter_in
 |     |     |
 |  +--v-----v---------+
 |  |                  |
 |  | barrel_shifter_r |
 |  |                  |
 |  +--------+---------+
 |           |  shifter_out
 |           |
 |       +---v---+
 +------->  rev  |
         +---+---+
             |
             v  out
```

#### Cell usage report with reverse circuit
```
+------+-----+------+
|      |Cell |Count |
+------+-----+------+
|1     |LUT6 |    24|
|2     |IBUF |    12|
|3     |OBUF |     8|
+------+-----+------+
``` 

#### Cell usage report with reverse circuit 16-bit
```
+------+-----+------+
|      |Cell |Count |
+------+-----+------+
|1     |LUT2 |     1|
|2     |LUT4 |     7|
|3     |LUT5 |    15|
|4     |LUT6 |     9|
|5     |IBUF |    12|
|6     |OBUF |     8|
+------+-----+------+
```


#### Cell usage report with reverse circuit 32-bit
```
+------+-----+------+
|      |Cell |Count |
+------+-----+------+
|1     |LUT2 |     1|
|2     |LUT4 |     7|
|3     |LUT5 |    15|
|4     |LUT6 |     9|
|5     |IBUF |    12|
|6     |OBUF |     8|
+------+-----+------+
```

#### Testing circuit operation
  - `sw[7:0]`: Input
  - `sw[10:8]`: Amount to shift
  - `sw[11]`: Left(1) or right(0)
  - `led[7:0]`: Output

The bit width can be selected by changing the top level parameters (N=32, 16 or 8 and M=5, 4 or 3) before synthesis/implementation. The inputs and outputs won't change on the board though, so higher value inputs or outputs are discarded.