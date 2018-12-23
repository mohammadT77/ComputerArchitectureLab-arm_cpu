module CPU;
	wire clk;
	wire write;
	wire [4:0] a,b,c;
	wire [63:0] dataC,dataB,dataA;
	wire [31:0] ins;
	wire pcWrite,pcReset;
	wire oldPC;
	wire newPC;
	os os0(clk);
	PC PC0(clk,pcReset,pcWrite,oldPC,newPC);
	InstructionMemory insMem0(newPC,ins);
	Control control0(ins,Reg2Loc,Branch,MemRead,MemWrite,MemtoReg,RegWrite,ALUSrc,ALUOp);
	ALUControl aluControl0(ins,ALUOp,ALUctrl);
	SignExtend32to64 signExtend0(ins,extendedOut);
	Shift(extendedOut,4'd2, 0, shiftedOut);
	Adder64 AdderPC(newPC,64'd4,pcWire0,cpc);
	Adder64 AdderBranch(newPC,shiftedOut,pcWire1,cbranch);
	

	MUX2to1 muxPC(pcWire0,pcWire1,Branch&Z,oldPC);
	MUX2to1 muxIns(ins[20:16],ins[4:0],Reg2Loc,b);
	RegisterBank RegisterBank0(RegWrite,clk,ins[9:5],b,ins[4:0],dataC,dataA,dataB);
	MUX2to1 muxALU(dataB,extendedOut,ALUSrc,aluDataB);
	ALU ALU0(dataA,aluDataB,ALUCtrl,ALURes,Z,C);
	DataMemory dataMemory0(clk, ALURes,dataB,MemRead,MemWrite,readData);
	MUX2to1 muxMem(ALURes,readData,MemtoReg,dataC);

endmodule
