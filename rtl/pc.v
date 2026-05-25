module pc(
        input clk,reset,
        input [31:0] Pnext,
        output reg[31:0] PC
);
    always @(posedge clk or posedge reset)
        if(reset) PC<=0;
        else    PC<=Pnext;
endmodule 
