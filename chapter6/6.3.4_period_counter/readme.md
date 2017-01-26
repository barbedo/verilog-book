6.3.4 Period counter
--------------------

### Page 164

#### Testing circuit operation

Set `sw[2:0]` according to the period of the free running tick generator that you want:


| `sw[2:0]` | period (*ms*) |
|:---------:|:-------------:|
|   3'b000  |       10      |
|   3'b001  |      100      |
|   3'b010  |      150      |
|   3'b011  |      200      |
|   3'b100  |      400      |
|   3'b101  |      750      |
|   3'b110  |      900      |
|   3'b111  |      1000     |

Then, press `btnL` and the display will show the detected period in *ms*.

`btnD` is reset.
