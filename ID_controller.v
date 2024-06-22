 module ID_controller(
			inst,
			branch_taken,
			write_pc2reg,
			csr_wen,
			csr_rdata,
			dm_wen,
			wrtie_mem_result2reg,
			alu_b_src_sel_0,
			alu_a_src_sel_0,
			alu_op,
			rf_wen,
			rf_raddr0,
			rf_raddr1,
			rf_waddr,
			alu_imm,
			cur_inst_type, // use for debug only
			inst_illegal,
			halt
			);
							
input [15:0]inst;
input csr_rdata;

output branch_taken,
       write_pc2reg,
       csr_wen,
       dm_wen,
       wrtie_mem_result2reg,
       alu_b_src_sel_0,
       alu_a_src_sel_0,
       rf_wen,
       inst_illegal,
       halt;
		 
output [3:0]alu_op,
	    rf_raddr0,
	    rf_raddr1,
	    rf_waddr;
				
output [15:0]alu_imm;
output [4:0]cur_inst_type;

reg [4:0]cur_inst_type;
reg [3:0]rf_raddr0, rf_raddr1, rf_waddr;
reg [15:0]alu_imm;

parameter ALU_OP_AND = 4'b0000,
	  ALU_OP_OR  = 4'b0001,
	  ALU_OP_XOR = 4'b0010,
	  ALU_OP_ADD = 4'b0011,
	  ALU_OP_SUB = 4'b0100,
	  ALU_OP_SLL = 4'b0101,
	  ALU_OP_SRA = 4'b0110,
	  ALU_OP_SRL = 4'b0111,
	  ALU_OP_NOT = 4'b1000,
	  ALU_OP_COM = 4'b1001,
	  ALU_OP_SLT = 4'b1010,
	  ALU_OP_SOE = 4'b1011;

parameter INST_AND  = 5'd0,
	  INST_OR   = 5'd1,
	  INST_XOR  = 5'd2,
	  INST_ADD  = 5'd3,
	  INST_SUB  = 5'd4,
	  INST_SLL  = 5'd5,
	  INST_SRA  = 5'd6,
	  INST_SRL  = 5'd7,
	  INST_NOT  = 5'd8,
	  INST_COM  = 5'd9,
	  INST_SLT  = 5'd10,
	  INST_SOE  = 5'd11,
	  INST_MVHL = 5'd12,
	  INST_MVLH = 5'd13,
	  INST_MVH  = 5'd14,
	  INST_LH   = 5'd15,
	  INST_LI   = 5'd16,
	  INST_SH   = 5'd17,
	  INST_BOZ  = 5'd18,
	  INST_BONZ = 5'd19,
	  INST_JAL  = 5'd20,
	  INST_JALR = 5'd21,
	  INST_HALT = 5'd30,
	  INST_ILLEGAL = 5'd31;
			 
//Decoder
always@(*)begin
	case(inst[15:13])
		3'b000:
			case(inst[12:10])
				3'b000: cur_inst_type = INST_AND;
				3'b001: cur_inst_type = INST_OR; 
				3'b010: cur_inst_type = INST_XOR;
				3'b011: cur_inst_type = INST_ADD;
				3'b100: cur_inst_type = INST_SUB;
				3'b101: cur_inst_type = INST_SLL;
				3'b110: cur_inst_type = INST_SRA;
				3'b111: cur_inst_type = INST_SRL;
			endcase
		3'b001:
			case(inst[12:10])
				3'b000:
					case(inst[8:6])
						3'b000: cur_inst_type = INST_NOT;
						3'b001: cur_inst_type = INST_COM;
						3'b010: cur_inst_type = (inst[9])? INST_MVLH : INST_MVHL;
						3'b011: cur_inst_type = INST_MVH;
						default: cur_inst_type = INST_ILLEGAL;
					endcase
				3'b001: cur_inst_type = INST_LH;
				3'b010: cur_inst_type = INST_SH;
				default: cur_inst_type = INST_ILLEGAL;
			endcase
		3'b010: cur_inst_type = INST_LI;
		3'b100:
			case(inst[12:10])
				3'b000: 
					case(inst[2:0])
						3'b000: cur_inst_type = INST_SLT;
						3'b001: cur_inst_type = INST_SOE;
					   default: cur_inst_type = INST_ILLEGAL;
					endcase
				3'b001: cur_inst_type = INST_BOZ;
				3'b010: cur_inst_type = INST_BONZ;
				3'b100: cur_inst_type = INST_JAL;
				3'b101: cur_inst_type = INST_JALR;
				default: cur_inst_type = INST_ILLEGAL;
			endcase
		3'b111: 	cur_inst_type = INST_HALT;
		default: cur_inst_type = INST_ILLEGAL;
	endcase
end

//Controller

assign branch_taken = ((cur_inst_type == INST_BOZ) && (!csr_rdata)) || 
		      ((cur_inst_type == INST_BONZ) && csr_rdata) || write_pc2reg;
	 
assign write_pc2reg = (cur_inst_type == INST_JAL) || (cur_inst_type == INST_JALR);
assign csr_wen = ((cur_inst_type == INST_SLT) || (cur_inst_type == INST_SOE)) && (!halt);
assign dm_wen = (cur_inst_type == INST_SH) && (!halt); 
assign wrtie_mem_result2reg = cur_inst_type == INST_LH; 
assign alu_b_src_sel_0 = branch_taken || 
			 write_pc2reg || 
			 (cur_inst_type == INST_LH) ||
			 (cur_inst_type == INST_LI) || 
			 (cur_inst_type == INST_SH);
	 
assign alu_a_src_sel_0 = branch_taken && (!(cur_inst_type == INST_JALR));
assign rf_wen = !(csr_wen || halt || (cur_inst_type == INST_SH) ||(cur_inst_type == INST_BOZ) || (cur_inst_type == INST_BONZ));
assign alu_op = (cur_inst_type[4])? ALU_OP_ADD : cur_inst_type[3:0];


always@(*)begin
	case (cur_inst_type)
			INST_LI:   rf_raddr0 = 4'd0;
			INST_MVHL: rf_raddr0 = {~inst[9], inst [5:3]};
			INST_MVLH: rf_raddr0 = {~inst[9], inst [5:3]};
			default: rf_raddr0 = {inst[9], inst [5:3]}; 
	endcase
end

always@(*)begin
	case (cur_inst_type)
			INST_MVLH: rf_raddr1 = 4'd0;
			INST_MVHL: rf_raddr1 = 4'd0;
			INST_MVH:   rf_raddr1 = 4'd0;
			default: rf_raddr1 = inst[9:6];
	endcase
end

always@(*)begin
	case (cur_inst_type)
			INST_JAL:  rf_waddr = 4'd15;
			INST_JALR: rf_waddr = 4'd15;
			default: rf_waddr = {inst[9], inst[2:0]};
	endcase
end

always@(*)begin
	case (cur_inst_type)
			INST_LH:    alu_imm = {{13{inst[8]}}, inst[8:6]};
			INST_LI:    alu_imm = {{7{inst[12]}}, inst[12:10], inst[8:3]};
			INST_SH:    alu_imm = {{13{inst[2]}}, inst[2:0]};
			INST_JALR:  alu_imm = {{10{inst[8]}}, inst[8:6], inst[2:0]};
			default:    alu_imm = {{6{inst[9]}}, inst[9:0]};
	endcase
end

assign inst_illegal = cur_inst_type == INST_ILLEGAL;
assign halt = cur_inst_type == INST_HALT;

endmodule
