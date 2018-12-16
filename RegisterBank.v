module RegisterBank(
		input write, clk,
		input [4:0] a,b,c,
		input [63:0] dataC,
		output [63:0] dataA, dataB 
	);

	reg [63:0] R[31:0];
	assign	dataA = R[a];
	assign	dataB = R[b];

	
	
	always @(posedge clk)
	begin			

			if (write == 1)
			begin
				R[c] = dataC;
			end
	end
endmodule
	