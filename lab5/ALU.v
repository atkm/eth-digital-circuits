module ALU(input [31:0] a, b, input[3:0] opcode, output [31:0] out, output zero);
wire carry;
wire opcode_3, opcode_2, opcode_1, opcode_0;
assign {opcode_3, opcode_2, opcode_1, opcode_0} = opcode;

wire [31:0] arith_out; // output for adder and slt
wire [31:0] adder_out; // output for adder
wire [31:0] arith_in; // second argument for the adder
wire [31:0] logic_out;

// Logic unit
// 00: and, 01: or, 10: xor, 11: nor
assign logic_out = opcode_1 ? (opcode_0 ? ~(a|b) : a^b) : (opcode_0 ? a|b : a&b);

// Arithmetic unit
// if opcode_1 sub else add
assign arith_in = opcode_1 ? (~b + 1) : b;
assign adder_out = a + arith_in;
//Adder add(.a(a), .b(arith_in), .s(adder_out), .c_out(carry)); // Adder is buggy.
// if opcode_3 slt else sub or add
assign arith_out = opcode_3 ? {31'b0, adder_out[31]} : adder_out;

// if opcode_2 logic else arithmetic
assign out = opcode_2 ? logic_out : arith_out;
assign zero = !(|out);
endmodule