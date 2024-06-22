module CSR (clk, rst, wen, rdata, wdata);
input clk, rst, wen, wdata;
output rdata;

reg rdata;

always@(posedge clk or negedge rst)begin
	if (!rst)
		rdata <= 1'd0;
	else
		rdata <= (wen)? wdata : rdata;
	end

endmodule