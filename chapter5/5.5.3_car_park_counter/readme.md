5.5.3 Parking lot occupancy counter
-----------------------------------

### Page 136

#### Assumptions

There are three assumptions being made for the circuit to work properly:

  - Only one car or pedestrian is able to pass through the passage with the sensors.
  - Cars are always big enough to be able to block the two sensors when entering or exiting for at least some clock cycles.
  - Pedestrians are not big enough to be able to block two sensors at once.

The circuit should be able to deal with cars that start to enter or to leave, but back off before passing through the last sensor.

When pedestrians pass through the entrance, they do not modify the counter. 

#### State diagram

```
+-----------------------+       +-----------------------+
|                       |       |                       |
|                     +-v-------v-+                     |
|              ab'    |           |   a'b               |
|            +--------+  waiting  +--------+            |
|            |        |           |        |            |
|            |        +-^-------^-+        |            |
|            |          |       |          |            |
|            |          |       |          |            |
|            |          |       |          |            |
|      +-----v-----+    |       |    +-----v-----+      |
|    +->           +----+       +----+           <-+    |
| ab'| | entering1 | a'b'        a'b'| exiting1  | |a'b |
|    +-+           |   (gave up or   |           +-+    |
|      +-----+--^--+    pedestrian)  +--^--+-----+      |
|            |  |                       |  |            |
|         ab |  | ab' (backed off)  a'b |  | ab         |
|            |  |                       |  |            |
|      +-----v--+--+                 +--+--v-----+      |
|    +->           |                 |           <-+    |
|  ab| | entering2 |                 | exiting2  | |ab  |
|    +-+           |                 |           +-+    |
|      +-----+--^--+                 +-^---+-----+      |
|            |  |                      |   |            |
|        a'b |  | ab  (backed off) ab  |   | ab'        |
|            |  |                      |   |            |
|      +-----v--+--+                 +-+---v-----+      |
|    +->           |                 |           <-+    |
| a'b| | entering3 |                 | exiting3  | |ab' |
|    +-+           |                 |           +-+    |
|      +-----+-----+                 +-----+-----+      |
|            |                             |            |
|            | a'b'                        | a'b'       |
|            |                             |            |
|      +-----v-----+                 +-----v-----+      |
|      |  entered  |                 |   exited  |      |
+------+           |                 |           +------+
       |  enter=1  |                 |   exit=1  |
       +-----------+                 +-----------+
```

#### Testing circuit operation

The testing circuit tries to simulate the car coming through the entrance. `btnU` is the outer side sensor and `btnD` is the inner side sensor.

```
               +---------+   +-+
               |         |   |-|
               |         |  +---+
               |   car   |    |
               |         |   +-+
    +----->    |         |   + +  <-----+  outer sensor
               |         |
               +---------+

                   +
    +----->        |              <-----+  inner sensor
                   | entering
                   |
                   v
```

So when one car pass through the entrance, the sequence is:
  - `btnU` press
  - `btnD` press
  - `btnU` depress
  - `brnD` depress

And the counter will be incremented. With the reverse movement, the counter will be decremented.

Pedestrians entering can be simulated by:
  - `btnU` press
  - `btnU` depress
  - `btnD` press
  - `btnD` depress

And the counter shall not be modified. Pedestrians leaving can be simulated with the reverse movement and will not modify the counter.
