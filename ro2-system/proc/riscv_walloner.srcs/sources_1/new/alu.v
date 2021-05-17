`timescale 1ns / 1ps

`include "alu_instructions.vh"

module alu(
    input [5:0] S,
    input [31:0] A,
    input [31:0] B,
    output reg CMP,
    output reg [31:0] Q
    );
    
    always @(S, A, B)
    begin
        CMP = 0;
        Q = 0;
        casez(S)
            `ALU_ADD: Q = $signed(A) + $signed(B);
            `ALU_ADDI: Q = $signed(A) + $signed(B);
            `ALU_SUB: Q = $signed(A) - $signed(B);
            `ALU_MUL: Q = $signed(A) * $signed(B);
            `ALU_AND: Q = A & B;
            `ALU_OR: Q = A | B;
            `ALU_XOR: Q = A ^ B;
            `ALU_SLL: Q = A << B;
            `ALU_SRL: Q = A >> B;
            `ALU_SRA: Q = $signed(A) >>> B;
            `ALU_SLT: Q = $signed(A) < $signed(B);
            `ALU_SLTU: Q = A < B;
            `ALU_BEQ: begin
                CMP = A == B;
                Q = A;
            end
            `ALU_BNE: begin
                CMP = A != B;
                Q = B;
            end
            `ALU_BLT: CMP = $signed(A) < $signed(B);
            `ALU_BLTU: CMP = A < B;
            `ALU_BGE: CMP = $signed(A) >= $signed(B);
            `ALU_BGEU: CMP = A >= B;
            default: begin
                CMP = 0;
                Q = 0;
            end
        endcase
    end
endmodule