3.11.2 Dual-priority encoder
----------------------------

### Page 80

#### Test circuit structure
```
                    + in
                    |
                    |
           +--------v--------+
           |                 |
           |dual_prio_encoder|
           |                 |
           +--+-----------+--+
  first_prio  |           | second_prio
              |           |
+-------------v---+   +---v-------------+
|                 |   |                 |
|   hex_to_sseg   |   |   hex_to_sseg   |
|                 |   |                 |
+-------------+---+   +---+-------------+
              |           |
    sseg_led1 |           | sseg_led0
              |           |
            +-v-----------v-+
            |               |
 clk +------>   disp_mux    |
            |               |
            +----+-----+----+
                 |     |
                 |     |
                 v     v
                sseg   an
```
