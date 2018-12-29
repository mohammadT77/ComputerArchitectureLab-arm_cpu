module PC(input clk,reset,write,
	 input  [63:0] newPC,
	 output reg [63:0] pc);
	
	always @(posedge clk)
	begin 
		if(reset)
		begin
			pc = 64'd0;
		end
		else if(write)
		begin
			pc <= newPC ;
		end
	end
endmodule
