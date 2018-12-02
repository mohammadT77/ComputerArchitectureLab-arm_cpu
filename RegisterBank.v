module RegisterBank(
		input write, clk,
		input [4:0] a,b,c,
		input [63:0] dataC,
		output reg [63:0] dataA, dataB 
	);
	reg [63:0] R[31:0];
	always @(posedge clk,write)
	begin			
		dataA = R[a];
		dataB = R[b];
			if (write == 1)
			begin
				R[c] = dataC;
			end
	end
endmodule
	