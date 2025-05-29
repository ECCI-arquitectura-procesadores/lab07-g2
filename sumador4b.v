
module sumador4b(

	input [3:0]a,
	input [3:0]b,
	input ci,
	output co4, 
	output [3:0]e

	);
	
	wire co1, co2,co3;
	
	sumador_1bit sumador1(a[0], b[0], ci, co1, e[0]);
	sumador_1bit sumador2(a[1], b[1], co1, co2,e[1]);
	sumador_1bit sumador3(a[2], b[2], co2, co3,e[2]);
	sumador_1bit sumador4(a[3], b[3], co3, co4,e[3]);
	
	
endmodule