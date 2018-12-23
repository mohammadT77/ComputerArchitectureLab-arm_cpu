module Control(input [31:0] instruction,
	output reg Reg2Loc,Branch,MemRead,MemWrite,MemtoReg,RegWrite,ALUSrc,
	output reg [1:0] ALUOp
);
	wire [10:0] opcode = instruction[31:11];
	always @(instruction)
	begin
		$display("%s",opcode[10:9]);
		case (opcode[10:9])
		2'b1x: begin // R-Type
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
		2'b11: begin // D-Type (Unscaled offset)
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
		2'b01: begin // CB-Type	
			$display("CB-Type");
			if(opcode[8:0]==9'b010101xxx) //CBZ instruction
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
