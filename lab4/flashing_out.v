module flashing_out (input [1:0] state, output [2:0] out);
// Base = 00 (== state)
// L1   = 01
// L2   = 10
// L3   = 11
//
// Light layout: (left) s[0] s[1] s[2] (right)
assign out[0] = state[0] & state[1];
assign out[1] = out[0] | state[0];
assign out[2] = out[1] | state[1];
endmodule