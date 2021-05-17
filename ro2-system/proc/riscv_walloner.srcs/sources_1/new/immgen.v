`timescale 1ns / 1ps

`include "v_lib/riscv_isa_defines.v"
`include "instruction_formatting.vh"

module immgen(
    input [31:0] INSTR,
    output reg [31:0] IMM
    );
    
    always @(INSTR) begin
        case(INSTR[`OPCODE]) //unterscheidung nach opcode
            `OPCODE_OPIMM: IMM = INSTR[13:12] == 2'b01 ? {{27{1'b0}}, INSTR[24:20]} : {{21{INSTR[31]}}, INSTR[30:20]};//unterscheidung nach shifts und anderen imm befehlen
            `OPCODE_STORE: IMM = {{21{INSTR[31]}}, INSTR[30:25], INSTR[11:7]};
            `OPCODE_LOAD: IMM = {{21{INSTR[31]}}, INSTR[30:20]};
            `OPCODE_BRANCH: IMM = {{20{INSTR[31]}}, INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0};
            `OPCODE_JALR: IMM = {{21{INSTR[31]}}, INSTR[30:20]};
            `OPCODE_JAL: IMM = {{12{INSTR[31]}}, INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0};
            `OPCODE_AUIPC: IMM = {INSTR[31:12], 12'b0};
            `OPCODE_LUI: IMM = {INSTR[31:12], 12'b0};
            `OPCODE_MRET_CSR: IMM = {20'b0, INSTR[31:20]};
            default: IMM = 0;
        endcase
    end
endmodule
