`timescale 1ns / 1ps

module regset_tb();
    reg [31:0] D;
    reg [4:0] A_D, A_Q0, A_Q1;
    reg write_enable, RES, CLK;
    wire [31:0] Q0, Q1;
    reg [31:0] Q0_soll, Q1_soll;
    
    regset dut(
        .D(D),
        .A_D(A_D),
        .A_Q0(A_Q0),
        .A_Q1(A_Q1),
        .write_enable(write_enable),
        .RES(RES),
        .CLK(CLK),
        .Q0(Q0),
        .Q1(Q1)
        );
        
    initial CLK = 0;
    always #5 CLK = ~CLK;
    
    integer i;
    initial begin
        $srandom(420);
        
        //Testmuster 1: Reset
        write_enable = 0;
        Q0_soll = 0; Q1_soll = 0;
        @(negedge CLK) RES = 1;
        @(negedge CLK) RES = 0;
        for(i = 0; i < 32; i = i + 1) begin
            A_Q0 = i; A_Q1 = i; #5;
            if(Q0 != Q0_soll || Q1 != Q1_soll) $finish;
        end
        
        //Testmuster 2: Reset mit zufälligem Inhalt
        @(negedge CLK) write_enable = 1;
        Q0_soll = 0; Q1_soll = 0;
        
        for(i = 0; i < 32; i = i + 1) begin
            A_D = i;
            D = $urandom;
            @(negedge CLK);
        end
        
        write_enable = 0;
        Q0_soll = 0; Q1_soll = 0;
        @(negedge CLK) RES = 1;
        @(negedge CLK) RES = 0;
        for(i = 0; i < 32; i = i + 1) begin
            A_Q0 = i; A_Q1 = i; #5;
            if(Q0 != Q0_soll || Q1 != Q1_soll) $finish;
        end
        
        //Testmuster 3: Zufälligen Inhalt schreiben und anschließend lesen
        @(negedge CLK) write_enable = 1;
        for(i = 1; i < 32; i = i + 1) begin
            A_D = i;
            A_Q0 = i; A_Q1 = i;
            D = $urandom;
            Q0_soll = D; Q1_soll = D;
            @(negedge CLK);
            if(Q0 != Q0_soll || Q1 != Q1_soll) $finish;
        end
        
        $finish;
    end
    
endmodule
