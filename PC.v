module PC(input clk,reset,write,
	 input  [63:0] oldPC,
	 output reg [63:0] newPC);
	
	always @(posedge clk)
	begin 
		if(reset)
		begin
			newPC = 64'd0;
		end
		else if(write)
		begin
			newPC = oldPC ;
		end
	end
endmodule
