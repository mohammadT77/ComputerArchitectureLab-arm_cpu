module DataMemory#(parameter d=0)(input clk,
	input [63:0] address,
	input [63:0] writeData,
	input read,write,
	output reg [63:0] readData
);
	wire [31:0] addr2 = address[31:0],
		addr1 = address[63:32];
	reg [63:0] M [0:31][0:31];
	always @(posedge clk)
	begin
		readData = 0;
		if(read)
		begin
			#d readData = M[addr1][addr2];
		end		
		if(write)
		begin
			#d M[addr1][addr2] = writeData;
		end
	end
endmodule
		