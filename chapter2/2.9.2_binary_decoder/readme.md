2.9.2 Gate-level binary decoder
--------------------------------

### Page 36

#### 2-to-4 binary decoder truth table

| en | in[1] | in[0] | bcode |
|:--:|:-----:|:-----:|:-----:|
|  0 |   -   |   -   |  0000 |
|  1 |   0   |   0   |  0001 |
|  1 |   0   |   1   |  0010 |
|  1 |   1   |   0   |  0100 |
|  1 |   1   |   1   |  1000 |

#### 2-to-4 binary decoder logical expressions

```
bcode[0] = en & ~in[1] & ~in[0]
bcode[1] = en & ~in[1] & in[0]
bcode[2] = en & in[1] & ~in[0]
bcode[3] = en & in[1] & in[0]
```