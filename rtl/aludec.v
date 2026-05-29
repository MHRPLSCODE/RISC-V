module aludec(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7b5,        // instr[30]
    output reg [2:0] alucontrol
);
    always @(*) begin
        case(ALUOp)
            2'b00: alucontrol = 3'b010;   // lw/sw  -> ADD (compute address)
            2'b01: alucontrol = 3'b110;   // beq    -> SUB (for zero flag)
            2'b10: begin                  // R-type -> look at funct fields
                case(funct3)
                    3'b000: alucontrol = funct7b5 ? 3'b110 : 3'b010; // sub : add
                    3'b010: alucontrol = 3'b111; // slt
                    3'b110: alucontrol = 3'b001; // or
                    3'b111: alucontrol = 3'b000; // and
                    default: alucontrol = 3'b010;
                endcase
            end
            default: alucontrol = 3'b010;
        endcase
    end
endmodule
