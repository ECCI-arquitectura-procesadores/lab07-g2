module sumador_restador
(
	input [3:0]a,
	input [3:0]b,
	input Selector,
	output co4, 
	output [3:0]e
	
	);
	
	wire xor0,xor1,xor2,xor3;

    xor(xor0,b[0],Selector);
    xor(xor1,b[1],Selector);
    xor(xor2,b[2],Selector);
    xor(xor3,b[3],Selector);

    wire [3:0]xorB;
    assign xorB={xor3,xor2,xor1,xor0};	
sumador4b sumador_1bit(a, xorB, Selector, co4,e);

	
	
endmodule