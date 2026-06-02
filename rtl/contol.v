module control(
    input  [6:0] op,
    output reg       RegWrite,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       ALUSrc,
    output reg       Branch,
    output reg [1:0] ALUOp,
    output reg [1:0] ImmSrc
);
    always @(*) begin
        case(op)
            7'b0110011: begin // R-type
                RegWrite=1; MemWrite=0; MemtoReg=0;
                ALUSrc=0; Branch=0; ALUOp=2'b10; ImmSrc=2'bxx;
            end
            7'b0000011: begin // lw
                RegWrite=1; MemWrite=0; MemtoReg=1;
                ALUSrc=1; Branch=0; ALUOp=2'b00; ImmSrc=2'b00;
            end
            7'b0100011: begin // sw
                RegWrite=0; MemWrite=1; MemtoReg=0;
                ALUSrc=1; Branch=0; ALUOp=2'b00; ImmSrc=2'b01;
            end
            7'b1100011: begin // beq
                RegWrite=0; MemWrite=0; MemtoReg=0;
                ALUSrc=0; Branch=1; ALUOp=2'b01; ImmSrc=2'b10;
            end
            default: begin
                RegWrite=0; MemWrite=0; MemtoReg=0;
                ALUSrc=0; Branch=0; ALUOp=2'b00; ImmSrc=2'b00;
            end
        endcase
    end
endmodule
