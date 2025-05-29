`timescale 1ns/1ps
`include "top_con_banco_registro.v"

module top_con_banco_registro_tb;

    reg clk = 0;
    reg rst = 0;
    reg init = 0;
    reg RegWrite = 0;
    reg [1:0] selector;
    reg [3:0] addrRa, addrRb, addrW;
    wire [6:0] segU, segD, segC;
    wire negative;

    // Instancia del módulo a probar
    top_con_banco_registro dut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .RegWrite(RegWrite),
        .selector(selector),
        .addrRa(addrRa),
        .addrRb(addrRb),
        .addrW(addrW),
        .segU(segU),
        .segD(segD),
        .segC(segC),
        .negative(negative)
    );

    // Reloj
    always #5 clk = ~clk;

    // Procedimiento de prueba
    initial begin
        // Configurar el VCD
        $dumpfile("top_con_banco_registro.vcd");
        $dumpvars(0, top_con_banco_registro_tb);

        // Mostrar información por consola
        $monitor("Time=%0t | segC=%b segD=%b segU=%b | Negative=%b", 
                 $time, segC, segD, segU, negative);

        // Reset
        rst = 1;
        #10;
        rst = 0;

        // Inicializar banco de registros con valores de prueba
        // Por simplicidad, asumimos que el banco comienza con valores conocidos

        // Realizar una suma entre valores en addrRa y addrRb y almacenar en addrW
        addrRa = 4'd1;   // Dirección del operando A
        addrRb = 4'd2;   // Dirección del operando B
        addrW  = 4'd3;   // Dirección destino

        selector = 2'b00; // Suma
        init = 1;
        #10;
        init = 0;

        // Activar escritura al banco
        RegWrite = 1;
        #20;
        RegWrite = 0;

        // Esperar a que termine
        #50;

        // Terminar simulación
        $finish;
    end

endmodule