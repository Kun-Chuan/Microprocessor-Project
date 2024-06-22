// Finsih all component, process to evening event => verification  2:18:28, modifying IM => third checking
module KUN16_core (clk, 
						 rst, 
						 pc_out, 
						 alu_s, 
						 cur_inst_type,
						 rf_wdata,
						 rf_rdata0,
						 rf_rdata1,
						 rf_wen,
						 dm_wen,
						 dm_rdata,
						 dm_wdata,
						 csr_wen, // Check CSR for checking if the bug is from branch since the current insruction type are correct, but it did not enter branch 
						 csr_rdata,
						 csr_wdata,
						 inst_illegal,
						 halt
						 );
input clk, rst;
output [15:0]pc_out, alu_s;
output [4:0]cur_inst_type;
output rf_wen;
output [15:0]rf_wdata, rf_rdata0, rf_rdata1;
output [15:0] dm_rdata, dm_wdata;
output dm_wen;
output csr_wen, csr_rdata, csr_wdata;
output inst_illegal, halt;

wire[15:0] alu_a, alu_b, alu_s, alu_imm;
wire[15:0] pc_seq, pc_in;
wire [15:0]inst;
wire[15:0] rf_wdata, rf_rdata0, rf_rdata1;
wire [15:0] wb_data;
wire [15:0] dm_rdata, dm_wdata; 

wire branch_taken, write_pc2reg, dm_wen, wrtie_mem_result2reg;
wire alu_b_src_sel_0, alu_a_src_sel_0, rf_wen;
wire csr_wen, csr_rdata, csr_wdata;
wire inst_illegal, halt;

wire [3:0] alu_op;
wire [3:0] rf_raddr0, rf_raddr1, rf_waddr;

assign pc_in = (branch_taken)? alu_s : pc_seq;
assign pc_seq = pc_out + 16'd2;
assign rf_wdata = (write_pc2reg)? pc_seq : wb_data;
assign wb_data = (wrtie_mem_result2reg)? dm_rdata : alu_s;
assign alu_a = (alu_a_src_sel_0)? pc_out : rf_rdata0;
assign alu_b = (alu_b_src_sel_0)? alu_imm : rf_rdata1;

assign dm_wdata = rf_rdata1;


PC PC0 (.clk(clk), 
		  .rst(rst), 
		  .inst_illegal(inst_illegal),
		  .halt(halt),
		  .pc_in(pc_in), 
		  .pc_out(pc_out));
		  
IM IM0(.clk(clk), 
		 .rst(rst), 
		 .pc(pc_out), 
		 .inst(inst));
		 
ID_controller ID0(   .inst(inst),
							.branch_taken(branch_taken),
							.write_pc2reg(write_pc2reg),
							.csr_wen(csr_wen),
							.csr_rdata(csr_rdata),
							.dm_wen(dm_wen),
							.wrtie_mem_result2reg(wrtie_mem_result2reg),
							.alu_b_src_sel_0(alu_b_src_sel_0),
							.alu_a_src_sel_0(alu_a_src_sel_0),
							.alu_op(alu_op),
							.rf_wen(rf_wen),
							.rf_raddr0(rf_raddr0),
							.rf_raddr1(rf_raddr1),
							.rf_waddr(rf_waddr),
							.alu_imm(alu_imm),
							.cur_inst_type(cur_inst_type),// use for debug only
							.inst_illegal(inst_illegal),
							.halt(halt)
							);
							
RF RF0(.clk(clk), 
		 .rst(rst), 
		 .raddr0(rf_raddr0), 
		 .raddr1(rf_raddr1), 
		 .waddr(rf_waddr), 
		 .wen(rf_wen), 
		 .wdata(rf_wdata), 
		 .rdata0(rf_rdata0), 
		 .rdata1(rf_rdata1));
							
ALU ALU0(.A(alu_a), 
			.B(alu_b), 
			.op(alu_op), 
			.S(alu_s), 
			.coms(csr_wdata));
			
DM DM0(.clk(clk), 
		 .rst(rst), 
		 .addr(alu_s), 
		 .wen(dm_wen), 
		 .rdata(dm_rdata), 
		 .wdata(dm_wdata));

CSR CSR0(.clk(clk), 
			.rst(rst), 
			.wen(csr_wen), 
			.rdata(csr_rdata), 
			.wdata(csr_wdata));		 
							
endmodule
