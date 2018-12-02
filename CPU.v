module CPU;
	wire clk;
	wire write;
	wire [4:0] a,b,c;
	wire [63:0] dataC,dataB,dataA;
	os os0(clk);
	tb tb0(clk,write,a,b,c,dataC);
	RegisterBank RegisterBank0(write,clk,a,b,c,dataC,dataA,dataB);

endmodule
