module alu(
    input  [31:0] a, b,
    input  [2:0]  alucontrol,
    output reg [31:0] result,
    output zero
);
    always @(*) begin
        case(alucontrol)
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = 0;
        endcase
    end

    assign zero = (result == 0);
endmodule
