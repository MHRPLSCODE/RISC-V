module signext(
    input  [31:0] instr,
    output [31:0] immext
);
    assign immext = {{20{instr[31]}}, instr[31:20]};
endmodule
