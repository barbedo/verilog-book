// Parking lot occupancy sensor

module car_park_sensor
    (
     input  wire clk, reset,
     input  wire a, b,  // 1 if led blocked
     output reg  enter, exit
    );

    // symbolic state declaration
    localparam[3:0]
            waiting   = 4'b0000,
            entering1 = 4'b0001,
            entering2 = 4'b0010,
            entering3 = 4'b0011,
            entered   = 4'b0100,
            exiting1  = 4'b0101,
            exiting2  = 4'b0110,
            exiting3  = 4'b0111,
            exited    = 4'b1000;

    // signal declaration
    reg[3:0] state_reg = 0, state_next = 0;


    // body

    //============================
    // Sensor FSM
    //============================
    //state register
    always @(posedge clk, posedge reset)
        if (reset)
            state_reg <= waiting;
        else
            state_reg <= state_next;

    // next-state and output logic
    always @*
    begin
        state_next = state_reg; // default state: the same
        enter = 1'b0;           // default outputs: 0
        exit  = 1'b0;
        case (state_reg)
            waiting:   // ~a & ~b
                if (a & ~b)       state_next = entering1;
                else if (~a & b)  state_next = exiting1;
            entering1: // a & ~b
                if (a & b)        state_next = entering2;
                else if (~a & ~b) state_next = waiting;   // pedestrian or gave up
            entering2: // a & b
                if (~a & b)       state_next = entering3;
                else if (a & ~b)  state_next = entering1; // backing off towards the outside
            entering3: // ~a & b
                if (~a & ~b)       state_next = entered;
                else if (a & b)   state_next = entering2; // backing off towards the outside
            entered:
                begin
                    enter = 1'b1;
                    state_next = waiting;
                end
            exiting1: // ~a & b
                if (a & b)        state_next = exiting2;
                else if (~a & ~b) state_next = waiting;  // pedestrian or gave up
            exiting2: // a & b
                if (a & ~b)       state_next = exiting3;
                else if (~a & b)  state_next = exiting1; // backing off towards the inside
            exiting3: // a & ~b
                if (~a & ~b)      state_next = exited;
                else if (a & b)   state_next = exiting2; // backing off towars the inside
            exited:
                begin
                    exit = 1'b1;
                    state_next = waiting;
                end
            default:
                state_next = waiting;
        endcase
    end
endmodule
