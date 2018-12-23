module InstructionMemory(input reg [63:0] PC, output [31:0] instruction);
	wire [31:0] addr1 = PC[63:32],
		 addr2 = PC[31:0];
	reg [31:0] IM [0:31][0:31];
	reg [32:0] ins;
	initial begin
		IM[0][32'd0] = 32'h8b1f03e5; 
		IM[0][32'd1] = 32'hf84000a4; 
		IM[0][32'd2] = 32'h8b040086; 
		IM[0][32'd2] = 32'hf80010a6; 
		//IM[0][32'd3] = 32'h48400000; //LDUR x0,[x0,#0]
		//IM[0][32'd4] = 32'h48000000; //STUR x0,[x0,#0]
		//IM[0][32'd5] = 32'h80000000; //CBZ x0,#0
		//for (ins=0;ins<=32'hfffffff;ins = ins + 1)
		//begin
		//	IM[32'd0][ins[31:0]] = ins[31:0];
		//	IM[32'hffffffff][ins[31:0]] = ins[31:0];
		//end
	end
	assign instruction = IM[addr1][addr2];
endmodule	