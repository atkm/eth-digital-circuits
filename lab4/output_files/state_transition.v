module state_transition (input [0:1] now, input c_left, input c_noop, output [0:1] next);
//
// 00 -(left)-> 01 -(left or noop)-> 10 -(left or noop)-> 11 --> 00 (== next[0] next[1])
// Goes to 00 otherwise.
//
assign next[0] = (c_left | c_noop) & (now[0] ^ now[1]);
// (c_left & ~now[1]) || (c_noop & now[0] & ~now[1]) simplifies to this.
assign next[1] = ~now[1] & (c_left | (c_noop & now[0]));
endmodule