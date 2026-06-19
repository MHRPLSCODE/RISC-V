`timescale 1ns / 1ps
module tb_top;
    reg clk, reset;

    // instantiate CPU
    top cpu(
        .clk(clk),
        .reset(reset)
    );

    // clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // initialize reset
        reset = 1;
        #12;
        reset = 0;

        // pre-load registers: x1=5, x2=3
        cpu.rf.rf[1] = 32'd5;
        cpu.rf.rf[2] = 32'd3;
        cpu.rf.rf[5] = 32'd0; 


        // wait for instructions to execute
        #200;

        // check results
        $display("===== TEST RESULTS =====");
        $display("x3  = %0d (expected: 8)",  cpu.rf.rf[3]);
        $display("x4  = %0d (expected: 8)",  cpu.rf.rf[4]);
        $display("x5  = %0d (expected: 0)",  cpu.rf.rf[5]);
        $display("x6  = %0d (expected: 5)",  cpu.rf.rf[6]);
        $display("mem[0] = %0d (expected: 8)", cpu.dmem.RAM[0]);

        // pass/fail check
        if (cpu.rf.rf[3] === 32'd8 &&
            cpu.rf.rf[4] === 32'd8 &&
            cpu.rf.rf[5] === 32'd0 &&
            cpu.rf.rf[6] === 32'd5 &&
            cpu.dmem.RAM[0] === 32'd8)
            $display(">>> ALL TESTS PASSED <<<");
        else
            $display(">>> SOME TESTS FAILED <<<");

        $finish;
    end

    // optional: monitor PC each cycle
    initial begin
        $monitor("Time=%0t PC=%h Instr=%h", $time, cpu.pcreg.PC, cpu.imem.instr);           
    end
endmodule
