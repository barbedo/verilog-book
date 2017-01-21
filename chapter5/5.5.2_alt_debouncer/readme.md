5.5.2 Alternative debouncing circuit
------------------------------------

### Page 135

#### Principle

This circuit uses the same free-running 10 *ms* clock as the one in the debouncing circuit example. The main difference is that it reacts instantly to the rising/falling edge of the switch. Then it sets/clears the output and waits something between 20 *ms* and 30 *ms* to finally confirm the press and move to the one/zero state.

The waiting states are sensible only to the 10 *ms* tick, so the output is locked by them until the press or depress is confirmed.

#### State diagram
```


              sw'                         sw
           +-------+                   +-------+
           |       |                   |       |
           |       |                   |       |
          ++-------v+                 ++-------v+
          |         |                 |         |
          |   zero  <-------+         |   one   <---------+
       +-->         |       |      +-->         |         |
       |  |         |       |      |  |  db=1   |         |
       |  +----+----+       |      |  +----+----+         |
       |       |            |      |       |              |
       |       | sw/db=1    |      |       | sw/db=0      |
       |       |            |      |       |              |
       |  +----v----+       |      |  +----v----+         |
       |  |         |       |      |  |         |         |
       |  | wait1_1 |       |      |  | wait0_1 |         |
       |  |         |       |      |  |         |         |
       |  |  db=1   |       |      |  |         |         |
       |  +----+----+       |      |  +----+----+         |
       |       |            |      |       |              |
       |       | m_tick     |      |       | m_tick       |
       |       |            |      |       |              |
       |  +----v----+       |      |  +----v----+         |
       |  |         |       |      |  |         |         |
       |  | wait1_2 |       |      |  | wait0_2 |         |
       |  |         |       |      |  |         |         |
       |  |  db=1   |       |      |  |         |         |
       |  +----+----+       |      |  +----+----+         |
       |       |            |      |       |              |
       |       | m_tick     |      |       | m_tick       |
       |       |            |      |       |              |
       |  +----v----+       |      |  +----v----+         |
    sw'|  |         |       |   sw |  |         |         |
       +--+ wait1_3 |       |      +--+ wait0_3 |         |
          |         |       |         |         |         |
          |   db=1  |       |         |         |         |
          +-----+---+       |         +----+----+         |
                |           |              |              |
                |           +--------------+ sw'          |
                |                                         |
                +-----------------------------------------+
                 sw
```