module clk_div (input clk, output reg clk_out);
// Converts a 50MHz clock to ~0.67Hz
reg [23:0] clk_count;
//posedge defines a rising edge (transition from 0 to 1)
always @ (posedge clk) begin
clk_count <= clk_count + 1;
if (&clk_count) begin
clk_out <= ~clk_out;
end
end
endmodule