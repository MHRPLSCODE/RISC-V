module imem(
    input [31:0] addr,
    output [31:0] instr
);
    reg [31:0] mem[0:63];
    
    initial $readmemh("Instructions.mem",mem);
    
    assign instr=mem[addr[31:2]];
    
endmodule
