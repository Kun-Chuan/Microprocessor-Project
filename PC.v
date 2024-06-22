module PC (clk, rst, inst_illegal, halt, pc_in, pc_out);
input clk, rst, inst_illegal, halt;
input [15:0] pc_in;
output [15:0] pc_out;

reg [15:0] pc_out;

always@(posedge clk or negedge rst)begin
	if (!rst)
		pc_out <= 16'd0;
	else if (inst_illegal || halt)
		pc_out <= pc_out;
	else
		pc_out <= pc_in;
	end

endmodule