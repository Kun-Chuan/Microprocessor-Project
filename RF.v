//RF Done

module RF(clk, rst, raddr0, raddr1, waddr, wen, wdata, rdata0, rdata1);
input clk, rst, wen;
input [3:0]raddr0, raddr1, waddr;
input [15:0] wdata;
output [15:0]rdata0, rdata1;

reg [15:0]reg_file[15:0];

always@(posedge clk or negedge rst)begin
	if (!rst)begin
		reg_file[4'd0] <= 16'd0;
		reg_file[4'd1] <= 16'd0;
		reg_file[4'd2] <= 16'd0;
		reg_file[4'd3] <= 16'd0;
		reg_file[4'd4] <= 16'd0;
		reg_file[4'd5] <= 16'd0;
		reg_file[4'd6] <= 16'd0;
		reg_file[4'd7] <= 16'd0;
		reg_file[4'd8] <= 16'd0;
		reg_file[4'd9] <= 16'd0;
		reg_file[4'd10] <= 16'd0;
		reg_file[4'd11] <= 16'd0;
		reg_file[4'd12] <= 16'd0;
		reg_file[4'd13] <= 16'd0;
		reg_file[4'd14] <= 16'd0;
		reg_file[4'd15] <= 16'd0;
	end
	else if (wen && waddr != 4'd0)begin
		reg_file[waddr] <= wdata;
	end
end

assign rdata0 = reg_file[raddr0];
assign rdata1 = reg_file[raddr1];


endmodule 