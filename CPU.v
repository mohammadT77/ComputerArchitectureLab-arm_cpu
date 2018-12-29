module CPU;
	wire clk;
	reg pcWrite,pcReset;
	wire [63:0] pcWire0,pcWire1;
	wire [63:0] pc,oldPC;
	wire [31:0] ins;
	wire [10:0] opcode = ins[31:21];
	wire C_Reg2Loc
		,C_Branch
		,C_MemRead
		,C_MemWrite
		,C_MemtoReg
		,C_RegWrite
		,C_ALUSrc ;
	wire [1:0] C_ALUOp;
	wire [4:0] reg1in,reg2in,regwrite;
	wire [63:0] dataC,dataB,dataA;
	wire [3:0] ALUctrl;
	wire [63:0] ALURes;
	wire ALU_Z;
	wire [63:0] aluDataB;
	wire [63:0] extendedImd,shiftedImd;
	wire [63:0] MemReadData;

	assign reg1in = ins[9:5];
	assign regwrite = ins[4:0];

	initial begin
			pcWrite = 0;
			pcReset = 1;
	end
	always @(pc) begin
		pcWrite = 1;
		pcReset = 0;
	end
	os os0(clk);
	PC PC0(clk,pcReset,pcWrite,oldPC,pc);
	InstructionMemory insMem0(pc,ins);
	Control#(.d(20)) control0(opcode,C_Reg2Loc,C_Branch,C_MemRead,C_MemWrite,C_MemtoReg,C_RegWrite,C_ALUSrc,C_ALUOp);
	ALUControl aluControl0(ins,C_ALUOp,ALUctrl);
	SignExtend32to64 signExtend0(ins,extendedImd);
	Shift shifter0(extendedImd,5'd2, 1'b0, shiftedImd);
	Adder64#(.d(10)) AdderPC(pc,64'd4,pcWire0,cpc);
	Adder64 AdderBranch(pc,shiftedImd,pcWire1,cbranch);
	

	MUX2to1 muxPC(pcWire0,pcWire1,C_Branch&ALU_Z,oldPC);
	MUX2to1#(.n(5)) muxIns(ins[20:16],regwrite,C_Reg2Loc,reg2in);
	RegisterBank RegisterBank0(C_RegWrite,clk,reg1in,reg2in,regwrite,dataC,dataA,dataB);
	MUX2to1 muxALU(dataB,extendedImd,C_ALUSrc,aluDataB);
	ALU ALU0(dataA,aluDataB,ALUctrl,ALURes,ALU_Z,C);
	DataMemory dataMemory0(clk, ALURes,dataB,C_MemRead,C_MemWrite,MemReadData);
	MUX2to1 muxMem(ALURes,MemReadData,C_MemtoReg,dataC);

endmodule
