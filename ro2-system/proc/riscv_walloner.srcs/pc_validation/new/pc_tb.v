`timescale 1ns / 1ps

module pc_tb();
    reg [31:0] D;
    reg MODE;
    reg ENABLE;
    reg RES;
    reg CLK;
    wire [31:0] PC_OUT;
    reg [31:0] PC_OUT_soll;
    
    pc dut(.D(D),
        .MODE(MODE),
        .ENABLE(ENABLE),
        .RES(RES),
        .CLK(CLK),
        .PC_OUT(PC_OUT)
        );
    
    initial CLK = 0;
    always #5 CLK = ~CLK;
    
    initial begin
    
        //Testmuster 1: Load PC = 8
        D=32'h8; MODE=1'b1; ENABLE=1'b1; RES=1'b0; PC_OUT_soll=32'h8; #10;
        if (PC_OUT != PC_OUT_soll) $finish;
        
        //Testmuster 2: Do not load PC if enable 0
        D=32'hA; MODE=1'b1; ENABLE=1'b0; RES=1'b0; PC_OUT_soll=32'h8; #10;
        if (PC_OUT != PC_OUT_soll) $finish;
        
        //Testmuster 3: Reset PC
        D=32'hFF; MODE=1'b0; ENABLE=1'b0; RES=1'b1; PC_OUT_soll=32'h1A000000; #10;
        if (PC_OUT != PC_OUT_soll) $finish;
        
        //Testmuster 4: Increment PC by 4
        D=32'h0; MODE=1'b0; ENABLE=1'b1; RES=1'b0; PC_OUT_soll=32'h1A000004; #10;
        if (PC_OUT != PC_OUT_soll) $finish;
        
        //Testmuster 5: Do not increment on enable false
        D=32'h0; MODE=1'b0; ENABLE=1'b0; RES=1'b0; PC_OUT_soll=32'h1A000004; #10;
        if (PC_OUT != PC_OUT_soll) $finish;
        
        
        $display("PC Test erfolgreich!");
        $finish; 
         
    end
endmodule