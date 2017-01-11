3.11.5 Floating-point and signed integer conversion circuit
-----------------------------------------------------------

### Page 81

#### Testing circuits

You need to change between the two constraints file (*fp* to *int* vs. *int* to *fp*) before synthesizing and implementing.


Inputs are the switches (`7:0` for *int* to *fp* and `12:0` for *fp* to *int*) and outputs are LEDs (`12:0` *int* to *fp* and `7:0` *fp* to *int*). For the *fp* to *int* circuit, overflow is `led[15]` and underflow is `led[14]`.