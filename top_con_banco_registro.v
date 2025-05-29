// ALU integrada con Banco de Registros

`include "top_module.v"

module top_con_banco_registro (
    input clk,
    input rst,
    input init,
    input RegWrite,
    input [1:0] selector,       // 00=suma, 01=resta, 10=multiplicación, 11=AND
    input [3:0] addrRa,         // Dirección del operando A
    input [3:0] addrRb,         // Dirección del operando B
    input [3:0] addrW,          // Dirección donde guardar el resultado
    output [6:0] segU,          // Display unidades
    output [6:0] segD,          // Display decenas
    output [6:0] segC,          // Display centenas
    output negative             // Indicador de resultado negativo (solo para resta)
);

    wire [7:0] result;
    wire done;
    wire [3:0] unidades, decenas, centenas;
    wire [7:0] datOutRa, datOutRb;

    // Banco de registros
    BancoRegistro #(4, 8) banco (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite && done),  // Escribimos solo cuando ALU termina
        .addrRa(addrRa),
        .addrRb(addrRb),
        .addrW(addrW),
        .datW(result),
        .datOutRa(datOutRa),
        .datOutRb(datOutRb)
    );

    // ALU instanciada usando datos del banco de registros
    ALU alu_inst (
        .clk(clk),
        .init(init),
        .selector(selector),
        .A(datOutRa[3:0]),     // Solo 4 bits menos significativos
        .B(datOutRb[3:0]),
        .done(done),
        .result(result),
        .negative(negative)
    );

    // Módulo para dividir en centenas, decenas y unidades
    mux_7seg mux_inst (
        .sumtotal(result),
        .done(done),
        .negative(negative),
        .unidades(unidades),
        .decenas(decenas),
        .centenas(centenas)
    );

    // Decodificadores para display de 7 segmentos
    wire [6:0] segU_base, segD_base, segC_base;
    reg [6:0] segC_mod;

    decodificador_7seg decU (.digit(unidades), .seg(segU_base));
    decodificador_7seg decD (.digit(decenas), .seg(segD_base));
    decodificador_7seg decC (.digit(centenas), .seg(segC_base));

    always @(*) begin
        if (negative) begin
            segC_mod = 7'b0111111; // Sólo segmento g encendido (signo negativo)
        end else begin
            segC_mod = segC_base;
        end
    end

    assign segU = segU_base;
    assign segD = segD_base;
    assign segC = segC_mod;

endmodule
