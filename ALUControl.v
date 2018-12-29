module ALUControl(input [31:0] instruction,input [1:0] ALUOp, output reg [3:0] ALUctrl);

	always @(ALUOp) begin
	$display("\t Opcode:%b",instruction[31:21]);
	case(ALUOp)
	2'b00: begin //D-type

		$display("\tRt:%d , Rn:%d , addres:%d",instruction[4:0],instruction[9:5],instruction[20:12]);
		if(instruction[22:21]==2'b00) $display("\tSTUR r%d, [r%d, #%d]",instruction[4:0],instruction[9:5],instruction[20:12]);//STUR
		else if(instruction[22:21]==2'b10) $display("\tLDUR r%d, [r%d, #%d]",instruction[4:0],instruction[9:5],instruction[20:12]);//STUR
		ALUctrl = 4'b0010;
	end
	2'b01: begin //CBZ
		$display("\tRt:%d , addres:%d",instruction[4:0],instruction[23:5]);
		$display("\tCBZ r%d, #%d",instruction[4:0],instruction[23:5]);
		ALUctrl = 4'b0111;
	end
	2'b10: begin//R-type
			$display("\tRd:%d , Rn:%d , Rm:%d",instruction[4:0],instruction[9:5],instruction[20:16]);
			case(instruction[27:25])
			3'b000:begin
				$display("\tADD r%d, r%d, r%d",instruction[4:0],instruction[9:5],instruction[20:16]);
				ALUctrl = 4'b0010; //ADD
				end
			3'b010:
			begin
				$display("\tSUB r%d, r%d, r%d",instruction[4:0],instruction[9:5],instruction[20:16]);
				ALUctrl = 4'b0110; //SUB
			end
			3'b100:
			begin
				$display("\tAND r%d, r%d, r%d",instruction[4:0],instruction[9:5],instruction[20:16]);
				ALUctrl = 4'b0000; //AND
			end
			3'b101:begin
				$display("\tORR r%d, r%d, r%d",instruction[4:0],instruction[9:5],instruction[20:16]);
				ALUctrl = 4'b0001; //ORR	
			end
			endcase
		end
	endcase
	end
endmodule
