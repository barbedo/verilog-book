7.7.2 Alternate coding style for BCD counter
--------------------------------------------

### Page 211

This project reimplements the same circuit as the `4.5.2_stopwatch`,
but using the compact style presented in section 7.2.


**The same detail applies:**

#### Clock frequency difference between Spartan-3 and Basys 3

The Basys 3 board has a oscillator of 100MHz vs. 50MHz of the Basys 3, so the counters upper limit (`DVSR`) must go up to 10M for a 0.1s tick. The register to hold it (`ms_reg` and  `ms_next`) must be at least 24-bit wide (`reg[23:0]`).
