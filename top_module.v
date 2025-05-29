`include "decodificador_7seg.v"
`include "mux_7seg.v"
`include "multiplicador.v"
`include "sumador_1bit.v"
`include "sumador4b.v"
`include "sumador_restador.v"
`include "ALU.v"
`include "BancoRegistro.v"

module top_module (
    input clk,
    input rst,
    input init,                // Señal de inicio para la ALU
    input RegWrite,            // Control para escribir en banco de registros
    input [1:0] selector,      // Selector ALU: 00=suma, 01=resta, 10=mult, 11=AND
    input [3:0] addrRa,        // Dirección del operando A
    input [3:0] addrRb,        // Dirección del operando B
    input [3:0] addrW,         // Dirección donde escribir resultado
    output [6:0] segU,
    output [6:0] segD,
    output [6:0] segC,
    output negative
);

    wire [7:0] result;
    wire done;
    wire [3:0] unidades, decenas, centenas;
    wire [7:0] datOutRa, datOutRb;

    // Instanciar banco de registros
    BancoRegistro banco_registro_inst (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite && done), // Escribe cuando la ALU termina
        .addrRa(addrRa),
        .addrRb(addrRb),
        .addrW(addrW),
        .datW(result),
        .datOutRa(datOutRa),
        .datOutRb(datOutRb)
    );

    // ALU con entradas desde el banco de registros
    ALU alu_inst (
        .clk(clk),
        .init(init),
        .selector(selector),
        .A(datOutRa[3:0]), // Solo los 4 bits inferiores
        .B(datOutRb[3:0]),
        .done(done),
        .result(result),
        .negative(negative)
    );

    // División en unidades, decenas y centenas
    mux_7seg mux_inst (
        .sumtotal(result),
        .done(done),
        .negative(negative),
        .unidades(unidades),
        .decenas(decenas),
        .centenas(centenas)
    );

    // Decodificadores de 7 segmentos
    wire [6:0] segU_base, segD_base, segC_base;
    reg [6:0] segC_mod;

    decodificador_7seg decU (.digit(unidades), .seg(segU_base));
    decodificador_7seg decD (.digit(decenas), .seg(segD_base));
    decodificador_7seg decC (.digit(centenas), .seg(segC_base));

    always @(*) begin
        if (negative) begin
            segC_mod = 7'b0111111;  // Solo el segmento g encendido (signo -)
        end else begin
            segC_mod = segC_base;
        end
    end

    assign segU = segU_base;
    assign segD = segD_base;
    assign segC = segC_mod;

endmodule
