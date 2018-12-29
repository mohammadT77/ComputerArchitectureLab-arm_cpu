module Adder64#(parameter d=0)(input [63:0] in0,[63:0] in1
	,output [63:0] out ,output C);
	ALU#(.d(d)) ALUADD(in0,in1,4'b0010,out,z,C);
endmodule
