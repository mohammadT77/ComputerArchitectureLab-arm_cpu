module InstructionMemory(input clk, input reg [63:0] PC, output reg [31:0] instruction);
	wire [31:0] addr1 = PC[63:32],
		 addr2 = PC[31:0];
	reg [31:0] IM [0:31][0:31];
	reg [31:0] ins;
	initial begin
		for (ins=0;ins<=32'hf;ins = ins + 1)
		begin
			IM[0][ins] = ins;
			IM[ins][0] = ins;
		end
	end
	always @(*)
	begin
		instruction = IM[addr1][addr2];
	end
endmodule	