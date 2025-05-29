module BancoRegistro #(           
    parameter BIT_ADDR = 4,
    parameter BIT_DATO = 8
)(
    input clk,
    input rst,
    input RegWrite,
    input [BIT_ADDR-1:0] addrRa,
    input [BIT_ADDR-1:0] addrRb,
    input [BIT_ADDR-1:0] addrW,
    input [BIT_DATO-1:0] datW,
    output [BIT_DATO-1:0] datOutRa,
    output [BIT_DATO-1:0] datOutRb
);
    localparam NREG = 2 ** BIT_ADDR;
    reg [BIT_DATO-1:0] banco_registro [0:NREG-1];

    initial begin
        $readmemh("/Users/andre/github-classroom/ECCI-arquitectura-procesadores/lab07-g2/memoria.txt", banco_registro);
    end

    always @(posedge clk) begin
        if (rst == 0) begin
            $readmemh("/Users/andre/github-classroom/ECCI-arquitectura-procesadores/lab06-banco-registro-g2/memoria.txt", banco_registro);
        end else if (RegWrite) begin
            banco_registro[addrW] <= datW;
        end
    end

    assign datOutRa = banco_registro[addrRa];
    assign datOutRb = banco_registro[addrRb];
endmodule