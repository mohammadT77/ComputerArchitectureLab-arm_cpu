module ALUControl(input [31:0] instruction,input [1:0] ALUOp, output reg [3:0] ALUctrl);

	always @(instruction,ALUOp) begin
	case(ALUOp)
	2'b00: ALUctrl = 4'b0010;
	2'b01: ALUctrl = 4'b0111;
	2'b10: begin
			case(instruction[27:25])
			3'b000:ALUctrl = 4'b0010; //ADD
			3'b010:ALUctrl = 4'b0110; //SUB
			3'b100:ALUctrl = 4'b0000; //AND
			3'b101:ALUctrl = 4'b0001; //ORR
			endcase
		end
	endcase
	end
endmodule
