module os#(parameter d=100)(output reg clk);	
	initial begin
		clk <= 0;
		forever #d clk = ~clk;
	end
endmodule
