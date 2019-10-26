module decode (input t_left, input t_reset, input t_right, output [0:2] command);
//
// Commands.
// left  = 100 (== command[0:3])
// right = 010
// noop  = 001
//
// left  iff t_left
// right iff t_right
// noop  iff all inputs are off
// reset otherwise. Not used in this circuit.
//
assign command[0] = t_left & ~t_reset & ~t_right;
assign command[1] = ~t_left & ~t_reset & t_right;
assign command[2] = ~(t_left | t_reset | t_right);
endmodule