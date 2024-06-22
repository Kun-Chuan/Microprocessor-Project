module IM (clk, rst, pc, inst);
input clk, rst;
input[15:0]pc;

output [15:0]inst;

parameter IM_depth = 256;
reg [15:0]inst_mem[IM_depth - 1 : 0];

always@(posedge clk or negedge rst)begin
	if (!rst)begin
		// Initial Test
		// Like Test Bench to verify if the CPU is correct
	 /*inst_mem[8'h0]  = 16'b010_000_0_001_010_001; //li a1, 10 checked
		inst_mem[8'h2]  = 16'b010_000_0_010_100_010; //li a2, 20
		inst_mem[8'h4]  = 16'b000_011_0_001_010_011; //add a3, a2, a1
		inst_mem[8'h6]  = 16'b010_000_0_001_000_100; //li a4, 8
		inst_mem[8'h8]  = 16'b001_010_0_011_100_100; //sh a3, a4(4) */
		
	 /*inst_mem[8'h0]  = 16'b001_001_0_000_000_001; //lh a1, 10 a0(0) => add loop program also test branch ,CSR and SOE
		inst_mem[8'h2]  = 16'b010_000_0_000_001_010; //li a2, 1
		inst_mem[8'h4]  = 16'b010_000_0_000_001_011; //li a3, 1
		inst_mem[8'h6]  = 16'b000_011_0_010_001_001; //add a1, a1, a2
		inst_mem[8'h8]  = 16'b000_011_0_011_010_010; //add a2, a2, a3
		inst_mem[8'ha]	 = 16'b010_000_0_010_101_101; //li a5, 21
		inst_mem[8'hc]	 = 16'b100_000_0_101_010_001; //soe a2, a5
		inst_mem[8'he]	 = 16'b100_001_1_111_111_000; //boz -8 
		inst_mem[8'h10] = 16'b001_000_1_010_000_000; //mvlh a0, a8
		inst_mem[8'h12] = 16'b001_010_0_001_000_010; //sh a1, a0(2)
		inst_mem[8'h14] = 16'b001_001_1_010_000_001; /*lh a9, a8(2) => a0(2)and a8(2) are point to same address so we store a4 
																							into memory then we load it to a9*/
																  
		inst_mem[8'h0]  <= 16'b001_001_0_000_000_001; //lh a1, 10 a0(0)
		inst_mem[8'h2]  <= 16'b010_000_0_000_001_010; //li a2, 1
		inst_mem[8'h4]  <= 16'b010_000_0_000_001_011; //li a3, 1
		inst_mem[8'h6]  <= 16'b000_011_0_010_001_001; //add a1, a1, a2
		inst_mem[8'h8]  <= 16'b000_011_0_011_010_010; //add a2, a2, a3
		inst_mem[8'ha]	 <= 16'b010_000_0_010_101_101; //li a5, 21
		inst_mem[8'hc]	 <= 16'b100_000_0_101_010_001; //soe a2, a5
		inst_mem[8'he]	 <= 16'b100_001_1_111_111_000; //boz -8 
		inst_mem[8'h10] <= 16'b001_000_1_010_000_000; //mvlh a1, a8 => a1 to a8
		inst_mem[8'h12] <= 16'b001_010_0_001_000_010; //sh a1, a0(2)
		inst_mem[8'h14] <= 16'b100_100_0_000_101_100; //JAL 0x2c => 2c + 14 = 40 
		inst_mem[8'h16] <= 16'b001_010_0_001_000_100; //sh a1, a0(4)
		inst_mem[8'h18] <= 16'b111_111_1_111_000_100; //halt
		inst_mem[8'h40] <= 16'b010_001_1_011_100_001; //li a9, 92 => 101_1100
		inst_mem[8'h42] <= 16'b010_000_1_010_101_000; //li a8, 21 => 001_0101 
		inst_mem[8'h44] <= 16'b000_000_1_000_001_010; //and a10, a8, a9 	// 001_0100
		inst_mem[8'h46] <= 16'b000_001_1_000_001_011; //or a11, a8, a9 		// 101_1101
		inst_mem[8'h48] <= 16'b000_010_1_000_001_100; //xor a12, a8, a9		// 100_1001
		inst_mem[8'h4a] <= 16'b000_100_1_000_001_101; //sub a13, a8, a9    // 0100_0111
		inst_mem[8'h4c] <= 16'b010_000_1_000_011_000; //li a8, 3
		inst_mem[8'h4e] <= 16'b010_110_1_011_100_001; //li a9, -100
		inst_mem[8'h50] <= 16'b000_101_1_000_001_010; //sll a10, a9, a8
		inst_mem[8'h52] <= 16'b000_110_1_000_001_011; //sra a11, a9, a8
		inst_mem[8'h54] <= 16'b000_111_1_000_001_100; //srl a11, a9, a8
		inst_mem[8'h56] <= 16'b001_000_1_000_011_101; //not a13, a11
		inst_mem[8'h58] <= 16'b001_000_1_001_010_110; //com a14, a10
		inst_mem[8'h5a] <= 16'b001_000_1_011_010_110; //mvh a14, a10
		inst_mem[8'h5c] <= 16'b001_000_0_010_110_001; //mvhl a1, a14
		inst_mem[8'h5e] <= 16'b100_101_1_000_111_000; //jalr a15, a0
		
	end
end

assign inst = inst_mem[pc[7:0]]; 

endmodule