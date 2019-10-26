module lab4 (input [0:2] t, input clk, output [0:5] s);

// State transition and outputs.
reg [0:1] left_state; // There are four states: Base, L1, L2, L3.
wire next_left_0, next_left_1; // Next state for the left lights.
// Assign the left half of the lights
flashing_out (.state(left_state), .out({s[0], s[1], s[2]}) );
// The same setup for right lights. Note that the lights are mirrored.
reg [0:1] right_state;
wire next_right_0, next_right_1;
flashing_out (.state(right_state), .out({s[5], s[4], s[3]}) );

// Inputs.
// t[0] = left
// t[1] = reset
// t[2] = right
//
wire c_left, c_right, c_noop;
// TODO: c_reset is not used.
decode (.t_left(t[0]), .t_reset(t[1]), .t_right(t[2]), .command({c_left, c_right, c_noop}) );

// The state_transition module is written for left lights.
// Feed the right command to use it for right lights.
state_transition (.now(left_state), .c_left(c_left), .c_noop(c_noop), 
	.next({next_left_0, next_left_1}) );
state_transition (.now(right_state), .c_left(c_right), .c_noop(c_noop),
	.next({next_right_0, next_right_1}) );


// Set up clock
wire fire;
clk_div (.clk(clk), .clk_out(fire) );

always @(posedge fire)
begin
	left_state[0] <= next_left_0;
	left_state[1] <= next_left_1;
	right_state[0] <= next_right_0;
	right_state[1] <= next_right_1;
end
endmodule