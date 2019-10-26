module lab4 (input [2:0] t, input clk, output [5:0] s);

// State transition and outputs.
reg [1:0] left_state; // There are four states: Base, L1, L2, L3.
wire [1:0] next_left; // Next state for the left lights.
// Assign the left half of the lights
wire [2:0] left_lights;
assign s[2:0] = left_lights;
flashing_out (.state(left_state), .out(left_lights) );
// The same setup for right lights.
reg [1:0] right_state;
wire [1:0] next_right;
wire [2:0] right_lights;
// The lights are reversed
assign s[5] = right_lights[0];
assign s[4] = right_lights[1];
assign s[3] = right_lights[2]; 
flashing_out (.state(right_state), .out(right_lights) );

// Inputs.
// t[0] = left
// t[1] = reset
// t[2] = right
//
wire c_left, c_right, c_noop;
// TODO: c_reset is not used.
decode (.t_left(t[0]), .t_reset(t[1]), .t_right(t[2]), .command({c_noop, c_right, c_left}) );

// The state_transition module is written for left lights.
// Feed the right command to use it for right lights.
state_transition (.now(left_state), .c_left(c_left), .c_noop(c_noop), .next(next_left) );
state_transition (.now(right_state), .c_left(c_right), .c_noop(c_noop),	.next(next_right) );


// Set up clock
wire fire;
clk_div (.clk(clk), .clk_out(fire) );

always @(posedge fire)
begin
	left_state <= next_left;
	right_state <= next_right;
end
endmodule