module mux_7seg (
    input [7:0] sumtotal,
    input done,
    input negative,              // Nuevo input para signo negativo
    output [3:0] unidades,
    output [3:0] decenas,
    output [3:0] centenas
);

    assign unidades = done ? (sumtotal % 10) : 4'd0;
    assign decenas  = done ? ((sumtotal / 10) % 10) : 4'd0;
    assign centenas = done ? ((sumtotal / 100) % 10) : 4'd0;

    // Nota: No modificamos los valores para negative aquí, se manipulará en top_module para activar segmento g

endmodule