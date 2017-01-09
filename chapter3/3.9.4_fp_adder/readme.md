3.9.2 Simplified floating-point adder
-------------------------------------

### Page 75

#### Operation of the testing circuit

###### Operand 1:
    - Sign: SW[15]
    - Exponential: Fixed to `4'b0010'
    - Fraction: MSb fixed to 1 (normalized), 3 bits controlled by SW[14:12] and LSbs fixed to 0

###### Operand 2:
    - Sign: SW[11]
    - Exponential: SW[10:7]
    - Fraction: MSb fixed to 1 (normalized), other bits controlled by SW[6:0]
