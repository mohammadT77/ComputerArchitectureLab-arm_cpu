module CPU_pipline;
	wire clk;
	reg pcWrite,pcReset;
	wire [63:0] pcWire0,pcWire1;
	wire [63:0] pc,oldPC;
	wire [31:0] ins;
	wire [10:0] opcode = ins[31:21];
	wire C_Reg2Loc
		,C_RegWrite
		,C_Branch
		,C_MemRead
		,C_MemWrite
		,C_MemtoReg
		,C_ALUSrc ;
	wire [1:0] C_ALUOp;
	wire [4:0] reg1in,reg2in;
	wire [63:0] dataC,dataB,dataA;
	wire [3:0] ALUctrl;
	wire [63:0] ALURes;
	wire ALU_Z;
	wire [63:0] aluDataB;
	wire [63:0] extendedImd,shiftedImd;
	wire [63:0] MemReadData;


	parameter IFID_n = 96;
	parameter IDEX_n = 7+64+64+64+64+32+1;
	parameter EXMEM_n = 5+64+64+1+64+4+1;
	parameter MEMWB_n = 2+5+64+64;

	wire IFID_reset,IDEX_reset,EXMEM_reset,MEMWB_reset;
	assign IFID_reset = 0;
	assign IDEX_reset = 0;
	assign EXMEM_reset = 0;
	assign MEMWB_reset = 0;
	wire IFID_stall,IDEX_stall,EXMEM_stall,MEMWB_stall;
	assign IFID_stall = 0;
	assign IDEX_stall = 0;
	assign EXMEM_stall = 0;
	assign MEMWB_stall = 0;

	wire [IFID_n-1:0] IFID_out;
	wire [IDEX_n-1:0] IDEX_out;
	wire [EXMEM_n-1:0] EXMEM_out;
	wire [MEMWB_n-1:0] MEMWB_out;
	
	PC#(.n(IFID_n)) IFID(clk,IFID_reset,~IFID_stall,
		{pc,ins}
		,IFID_out);

	
	wire [31:0] IFID_ins;
	wire [63:0] IFID_pc;

	assign IFID_ins = IFID_out[31:0];
	assign IFID_pc = IFID_out[95:32];

	assign reg1in = IFID_ins[9:5];

	PC#(.n(IDEX_n)) IDEX(clk,IDEX_reset,~IDEX_stall,
		{ins
		,C_RegWrite
		,C_Branch
		,C_MemRead
		,C_MemWrite
		,C_MemtoReg
		,C_ALUSrc
		,C_ALUOp
		,pc
		,dataA,dataB,extendedImd}
		,IDEX_out);

	
	wire IDEX_C_Branch,
		IDEX_C_RegWrite,
		IDEX_C_MemRead,
		IDEX_C_MemWrite,
		IDEX_C_MemtoReg,
		IDEX_C_ALUSrc;
	wire [31:0] IDEX_ins;
	wire [1:0] IDEX_C_ALUOp;
	wire [63:0] IDEX_pc;
	wire [63:0] IDEX_dataA;
	wire [63:0] IDEX_dataB;
	wire [63:0] IDEX_extendedImd;


	assign IDEX_ins = IDEX_out[297:266];
	assign IDEX_C_RegWrite = IDEX_out[265];
	assign IDEX_C_Branch = IDEX_out[264];
	assign IDEX_C_MemRead = IDEX_out[263];
	assign IDEX_C_MemWrite = IDEX_out[262];
	assign IDEX_C_MemtoReg = IDEX_out[261];
	assign IDEX_C_ALUSrc= IDEX_out[260];
	assign IDEX_C_ALUOp = IDEX_out[259:258];
	assign IDEX_pc = IDEX_out[257:192];
	assign IDEX_dataA = IDEX_out[191:128];
	assign IDEX_dataB = IDEX_out[127:64];
	assign IDEX_extendedImd = IDEX_out[63:0];
	


	PC#(.n(EXMEM_n)) EXMEM(clk,EXMEM_reset,~EXMEM_stall,
		{IDEX_C_RegWrite
		,IDEX_C_Branch
		,IDEX_C_MemRead
		,IDEX_C_MemWrite
		,IDEX_C_MemtoReg
		,pcWire1
		,ALU_Z
		,ALURes
		,IDEX_dataB
		,ins[4:0]},EXMEM_out);

	wire EXMEM_C_RegWrite
		,EXMEM_C_Branch
		,EXMEM_C_MemRead
		,EXMEM_C_MemWrite
		,EXMEM_C_MemtoReg
		,EXMEM_ALU_Z;
	wire [63:0]EXMEM_pcWire;
	wire [63:0]EXMEM_ALURe;
	wire [63:0]EXMEM_IDEX_data;
	wire [4:0]EXMEM_ins4_0;

	assign EXMEM_C_RegWrite = EXMEM_out[202];
	assign EXMEM_C_Branch = EXMEM_out[201];
	assign EXMEM_C_MemRead = EXMEM_out[200];
	assign EXMEM_C_MemWrite = EXMEM_out[199];
	assign EXMEM_C_MemtoReg = EXMEM_out[198];
	assign EXMEM_pcWire1 = EXMEM_out[197:134];
	assign EXMEM_ALU_Z = EXMEM_out[133];
	assign EXMEM_ALURes = EXMEM_out[132:69];
	assign EXMEM_IDEX_dataB = EXMEM_out[68:5];
	assign EXMEM_ins4_0 = EXMEM_out[4:0];

	PC#(.n(MEMWB_n)) MEMWB(clk,MEMWB_reset,~MEMWB_stall,
		{EXMEM_C_RegWrite
		,EXMEM_C_MemtoReg
		,MemReadData
		,EXMEM_ALURes
		,EXMEM_ins4_0},MEMWB_out);

	wire MEMWB_C_RegWrite
		,MEMWB_C_MemtoReg;
	wire [63:0]MEMWB_MemReadDat;
	wire [63:0]MEMWB_ALURe;
	wire [4:0]MEMWB_ins4_0;
	
	assign  MEMWB_C_RegWrite = MEMWB_out[134];
	assign MEMWB_C_MemtoReg = MEMWB_out[133];
	assign MEMWB_MemReadData = MEMWB_out[132:69];
	assign MEMWB_ALURes = MEMWB_out[68:5];
	assign MEMWB_ins4_0 = MEMWB_out[4:0];

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
	Control control0(opcode,C_Reg2Loc,C_Branch,C_MemRead,C_MemWrite,C_MemtoReg,C_RegWrite,C_ALUSrc,C_ALUOp);
	ALUControl aluControl0(IDEX_ins,IDEX_C_ALUOp,ALUctrl);
	SignExtend32to64 signExtend0(ins,IDEX_extendedImd);
	Shift shifter0(IDEX_extendedImd,5'd2, 1'b0, shiftedImd);
	Adder64 AdderPC(pc,64'd4,pcWire0,cpc);
	Adder64 AdderBranch(IDEX_pc,shiftedImd,pcWire1,cbranch);
	

	MUX2to1 muxPC(pcWire0,EXMEM_pcWire1,EXMEM_C_Branch&EXMEM_ALU_Z,oldPC);
	MUX2to1 muxIns(IFID_ins[20:16],regwrite,C_Reg2Loc,reg2in);
	RegisterBank RegisterBank0(MEMWB_C_RegWrite,clk,reg1in,reg2in,MEMWB_ins4_0,dataC,dataA,dataB);
	MUX2to1 muxALU(IDEX_dataB,IDEX_extendedImd,IDEX_C_ALUSrc,aluDataB);
	ALU ALU0(IDEX_dataA,aluDataB,ALUctrl,ALURes,ALU_Z,C);
	DataMemory dataMemory0(clk, EXMEM_ALURes,EXMEM_IDEX_dataB,EXMEM_C_MemRead,EXMEM_C_MemWrite,MemReadData);
	MUX2to1 muxMem(MEMWB_ALURes,MEMWB_MemReadData,MEMWB_C_MemtoReg,dataC);

endmodule
