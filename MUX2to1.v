module MUX2to1(input [63:0] in0,in1, input S, output [63:0] out);
	assign out = (S)?in1:in0;
endmodule
