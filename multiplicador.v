module multiplicador(
    input clk,
    input init,    
    input [3:0] MR,  // multiplicador
    input [3:0] MD,  // multiplicando
    output reg done,
    output reg [7:0] pp  // producto parcial
);

    reg sh;
    reg rst;
    reg add;
    reg [7:0] A;
    reg [3:0] B;
    wire z;

    reg [2:0] status;

    localparam START = 0, CHECK = 1, ADD = 2, SHIFT = 3, END1 = 4;

    initial begin
        status = START;
        rst = 1'b0;
        pp = 8'b0;
        A = 8'b0;
        B = 4'b0; 
        done = 1'b0;
    end

    always @(negedge clk) begin
        case (status)
            START: begin
                sh <= 1'b0;
                add <= 1'b0;
                if (init) begin
                    status <= CHECK;
                    done <= 1'b0;
                    rst <= 1'b1;
                end
            end
            CHECK: begin 
                done <= 1'b0;
                rst <= 1'b0;
                sh <= 1'b0;
                add <= 1'b0;
                status <= (B[0]==1)? ADD : SHIFT;
            end
            ADD: begin
                done <= 1'b0;
                rst <= 1'b0;
                sh <= 1'b0;
                add <= 1'b1;
                status <= SHIFT;
            end
            SHIFT: begin
                done <= 1'b0;
                rst <= 1'b0;
                sh <= 1'b1;
                add <= 1'b0;
                status <= (z==1)? END1 : CHECK;
            end
            END1: begin
                done <= 1'b1;
                rst <= 1'b0;
                sh <= 1'b0;
                add <= 1'b0;
                status <= START;
            end
            default: status <= START;
        endcase 
    end 

    // Registros de desplazamiento
    always @(posedge clk) begin
        if (rst) begin
            A <= {4'b0000, MD};
            B <= MR;
        end else if (sh) begin
            A <= A << 1;
            B <= B >> 1;
        end
    end 

    // Suma parcial
    always @(posedge clk) begin
        if (rst) begin
            pp <= 8'b0;
        end else if (add) begin
            pp <= pp + A;
        end
    end

    // Comparador
    assign z = (B == 0) ? 1'b1 : 1'b0;

endmodule
