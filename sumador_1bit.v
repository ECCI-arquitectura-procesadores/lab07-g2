module sumador_1bit(

    input a, b, ci,
	output co, e

);
	wire abxor, aband, cixor;
	xor(abxor, a, b);
	xor(e, abxor, ci);
	and(cixor, abxor, ci);
	and(aband, a, b);
	or(co, cixor, aband);
	
endmodule