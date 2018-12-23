module Control(input [10:0] opcode,
	output reg Reg2Loc,Branch,MemRead,MemWrite,MemtoReg,RegWrite,ALUSrc,
	output reg [1:0] ALUOp
);
	
	always @(*)
	begin
		case (opcode[10:8])
		3'b001: begin // R-Type
				$display("R-Type");
				Reg2Loc = 0;
				Branch = 0;
				MemRead = 0;
				MemWrite = 0;
				MemtoReg = 0;
				RegWrite = 1;
				ALUSrc = 0;
				ALUOp = 2'b10;
			end
		3'b010: begin // D-Type (Unscaled offset)
				$display("D-Type");
				Reg2Loc = 1;
				Branch = 0;
				ALUSrc = 1;
				ALUOp = 2'b00;			
				if(opcode[1:0]==2'b00) begin //STUR
					$display("/STUR");
					MemRead = 0;
					MemWrite = 1;
					MemtoReg = 0;
					RegWrite = 0;
				end
				else if(opcode[1:0]==2'b10) begin //LDUR
					$display("/LDUR");
					MemRead = 1;
					MemWrite = 0;
					MemtoReg = 1;
					RegWrite = 1;
				end
			end	
		3'b100: begin // CB-Type	
			$display("CB-Type");
			if(opcode[7:3]==5'b0) //CBZ instruction
			begin
				$display("/CBZ");
				Reg2Loc = 1;
				Branch = 1;
				MemRead = 0;
				MemWrite = 0;
				MemtoReg = 0;
				RegWrite = 0;
				ALUSrc = 0;
				ALUOp = 2'b01;
			end
		end
		
	endcase
	end
endmodule