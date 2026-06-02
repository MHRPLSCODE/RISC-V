module top(
    input clk,
    input reset
);

    // internal wires
    wire [31:0] PC, PCNext, PCPlus4, PCTarget;
    wire [31:0] Instr;
    wire [31:0] RD1, RD2;
    wire [31:0] ImmExt;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] Result;
    wire [2:0]  ALUControl;
    wire [1:0]  ALUOp, ImmSrc;
    wire        RegWrite, MemWrite, MemtoReg, ALUSrc, Branch;
    wire        Zero, PCSrc;

    // ---- PCNext logic ----
    assign PCPlus4  = PC + 32'd4;
    assign PCTarget = PC + ImmExt;
    assign PCSrc    = Branch & Zero;
    assign PCNext   = PCSrc ? PCTarget : PCPlus4;

    // ---- Mux 1: ALUSrc ----
    assign SrcB = ALUSrc ? ImmExt : RD2;

    // ---- Mux 2: MemtoReg (Result mux) ----
    assign Result = MemtoReg ? ReadData : ALUResult;

    // ---- Module instantiations ----

    pc pcreg(
        .clk(clk),
        .reset(reset),
        .pcnext(PCNext),
        .pc(PC)
    );

    instr_mem imem(
        .addr(PC),
        .instr(Instr)
    );

    control ctrl(
        .op(Instr[6:0]),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .ImmSrc(ImmSrc)
    );

    regfile rf(
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),
        .a2(Instr[24:20]),
        .a3(Instr[11:7]),
        .wd3(Result),
        .rd1(RD1),
        .rd2(RD2)
    );

    signext se(
        .instr(Instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
    );

    aludec ad(
        .ALUOp(ALUOp),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .alucontrol(ALUControl)
    );

    alu alu_inst(
        .a(RD1),
        .b(SrcB),
        .alucontrol(ALUControl),
        .result(ALUResult),
        .zero(Zero)
    );

    datamem dmem(
        .clk(clk),
        .we(MemWrite),
        .addr(ALUResult),
        .wd(RD2),
        .rd(ReadData)
    );

endmodule
