module InstructionMemory(input reg [63:0] PC, output [31:0] instruction);
	wire [31:0] addr1 = PC[63:32],
		 addr2 = PC[31:0];
	reg [31:0] IM [0:31][0:31];
	reg [32:0] ins;
	initial begin
		for (ins=0;ins<=32'hfffffff;ins = ins + 1)
		begin
			IM[32'd0][ins[31:0]] = ins[31:0];
			IM[32'hffffffff][ins[31:0]] = ins[31:0];
		end
	end
	assign instruction = IM[addr1][addr2];
endmodule	