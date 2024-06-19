// Done ALU

module ALU(A, B, op, S, coms);
input [15:0]A, B;
input [3:0]op;
output coms;
output [15:0]S;

reg [15:0]S;
reg coms;
wire signed [15:0] SA = A;

parameter AND = 4'b0000,
			  OR = 4'b0001,
			 XOR = 4'b0010,
			 ADD = 4'b0011,
			 SUB = 4'b0100,
			 SLL = 4'b0101,
			 SRA = 4'b0110,
			 SRL = 4'b0111,
			 NOT = 4'b1000,
			 COM = 4'b1001,
			 SLT = 4'b1010,
			 SOE = 4'b1011;

always@(*)begin
	case(op)
		AND: S = A & B;//Overflow issue
		OR: S = A | B;
		XOR:	S = A ^ B;
		ADD: S = A + B;
		SUB: S = A - B;
		SLL: S = A << B;
		SRA: S = SA >>> B;  //(Arithmetic) shift rihgt with adding the sign bit 
		SRL: S = A >> B; // (Logic)
		NOT: S = !A; // only one bit true or fulse
		COM: S = ~A; //補數
		default: S = A + B;
	endcase
end

always@(*)begin
	case(op)
		SLT: coms = A < B;
		SOE: coms = A == B;
		default: coms = 1'b0;
	endcase
end


	
		

endmodule