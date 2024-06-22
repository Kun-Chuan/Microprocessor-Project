module DM (clk, rst, addr, wen, rdata, wdata);
input clk, rst, wen;
input [15:0]addr, wdata;
output [15:0]rdata;

parameter DM_depth = 256;
reg [15:0]DM_memory[DM_depth - 1 : 0];

always@(posedge clk or negedge rst)begin
	if (!rst)begin
		DM_memory[8'h0] <= 16'd100;
		DM_memory[8'h2] <= 16'd43;
		DM_memory[8'h4] <= 16'd6;
		DM_memory[8'h6] <= 16'd58;
		DM_memory[8'h8] <= 16'd77;
	end
	else if (wen)
		DM_memory[addr[7:0]] <= wdata;
end

assign rdata = DM_memory[addr[7:0]];

endmodule