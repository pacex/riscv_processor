`timescale 1ns / 1ps

module immgen_tb();
    reg [31:0] INSTR;
    wire [31:0] IMM;
    
    immgen dut(
        .INSTR(INSTR),
        .IMM(IMM)
        );
    
    initial begin
        
        //Testmuster 1: Ungültiger OPCODE
        INSTR = 32'b00110111101100001011111010000000;
        #10;
        if (IMM != 0) $finish;
        
        //Testmuster 2: LUI
        INSTR = 32'b10101010101010101010000000110111;
        #10;
        if (IMM != 32'hAAAAA000) $finish;
        
        //Testmuster 3: AUIPC
        INSTR = 32'b10101010101010101010000000010111;
        #10;
        if (IMM != 32'hAAAAA000) $finish;
        
        //Testmuster 4: JAL
        INSTR = 32'b11000001111010011001000001101111;
        #10;
        if (IMM != 32'b11111111111110011001010000011110) $finish;
        
        //Testmuster 5: JALR
        INSTR = 32'b11000001111000000000000001100111;
        #10;
        if (IMM != 32'b11111111111111111111110000011110) $finish;
        
        //Testmuster 6: Branch
        INSTR = 32'b11000000000000000000111111100011;
        #10;
        if (IMM != 32'b11111111111111111111110000011110) $finish;
        
        //Testmuster 7: Load
        INSTR = 32'b11000001111000000000000000000011;
        #10;
        if (IMM != 32'b11111111111111111111110000011110) $finish;
        
        //Testmuster 8: Store
        INSTR = 32'b11000000000000000000111100100011;
        #10;
        if (IMM != 32'b11111111111111111111110000011110) $finish;
        
        //Testmuster 9: Arithmetisch-Logisch
        INSTR = 32'b11010101010000000000000000010011;
        #10;
        if (IMM != 32'b11111111111111111111110101010100) $finish;
        
        //Testmuster 9: Shifts
        INSTR = 32'b01000001011100000101000000010011;
        #10;
        if (IMM != 32'b00000000000000000000000000010111) $finish;
                
        $finish;
    end
endmodule
