module ALU (
    input clk,
    input init,
    input [1:0] selector,  // 00: suma, 01: resta, 10: multiplicación, 11: AND
    input [3:0] A,
    input [3:0] B,
    output done,
    output [7:0] result,
    output reg negative  // Indicador de número negativo solo para la resta
);

    wire [3:0] suma_resta_e;
    wire co4;
    wire [7:0] mult_out;
    wire mult_done;

    reg [7:0] alu_result;
    reg alu_done;

    reg [3:0] resta_val_abs;

    // Instancia del sumador/restador. Selector[0]: 0 suma, 1 resta
    sumador_restador sr_inst (
        .a(A),
        .b(B),
        .Selector(selector[0]),
        .co4(co4),
        .e(suma_resta_e)
    );

    // Instancia del multiplicador
    multiplicador mult_inst (
        .clk(clk),
        .init(init && (selector == 2'b10)),
        .MR(B),
        .MD(A),
        .done(mult_done),
        .pp(mult_out)
    );

    always @(*) begin
        negative = 1'b0;
        alu_done = 1'b0;
        alu_result = 8'b0;

        case(selector)
            2'b00: begin // Suma
                alu_result = {4'b0000, co4, suma_resta_e}; // usar acarreo como bit 4
                alu_done = 1'b1;
                negative = 1'b0;
            end
            2'b01: begin // Resta
                // 'suma_resta_e' = A - B (resultado raw 4 bits)
                // Detectar si A < B o A = B
                if (B < A) begin    
                    // Calcular complemento a dos para valor absoluto de la resta
                    resta_val_abs = (suma_resta_e);
                    alu_result = (resta_val_abs);            
                    negative = 1;
                end else if (A == B) begin
                    alu_result = 8'b00000000; // Resultado cero
                    negative = 1'b0; // No negativo
                end else begin
                    alu_result = {4'b0000, ~suma_resta_e + co4} + 1;  // 8 bits
                end
                alu_done = 1'b1; // Indicar que la operación está completa
            end
            2'b10: begin  // Multiplicación
                alu_result = mult_out;
                alu_done = mult_done;
            end
            2'b11: begin  // AND
                alu_result = {4'b0000, A & B}; // Realiza la operación AND
                alu_done = 1'b1; // Indicar que la operación está completa
                negative = 1'b0; // La operación AND no produce un resultado negativo
            end
            default: begin
                alu_result = 8'b0;
                alu_done = 1'b0;
            end
        endcase
    end

    assign result = alu_result;
    assign done = alu_done;

endmodule