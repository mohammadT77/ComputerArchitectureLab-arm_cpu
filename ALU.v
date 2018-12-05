module ALU(input [63:0] dataA,dataB,
	input [3:0] ALUctrl,
	output [63:0] ALUres,
	output Z
);
	reg [64:0] res_temp;
	always @(*)
	begin
		case(ALUctrl)
		4'b0000: res_temp = dataA & dataB;
		4'b0001: res_temp = dataA | dataB;
		4'b0010: res_temp = dataA + dataB;
		4'b0110: res_temp = dataA - dataB;
		4'b0111: res_temp = dataB;
		4'b1100: res_temp = ~(dataA | dataB);
		endcase
	end
	assign ALUres = res_temp[63:0];
	assign Z = res_temp[64];
endmodule
