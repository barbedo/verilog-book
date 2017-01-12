4.5.2 Stopwatch
-----------------------------------

### Page 107

#### Clock frequency difference between Spartan-3 and Basys 3

The Basys 3 board has a oscillator of 100MHz vs. 50MHz of the Basys 3, so the counters upper limit (`DVSR`) must go up to 10M for a 0.1s tick. The register to hold it (`ms_reg` and  `ms_next`) must be at least 24-bit wide (`reg[23:0]`).
