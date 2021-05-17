`timescale 1ns / 1ps

`include "v_lib/riscv_isa_defines.v"
`include "instruction_formatting.vh"
`include "alu_instructions.vh"

// Zustandskodierung
`define INSTR_REQ   5'b00000
`define INSTR_WAIT  5'b00001
`define EXEC        5'b00010
`define MUL_BUFFER  5'b00011
`define STORE_REQ   5'b00100
`define LOAD_REQ    5'b00101
`define LOAD_WAIT   5'b00110
`define STORE_REQ_2 5'b10100
`define LOAD_REQ_2  5'b10101
`define LOAD_WAIT_2 5'b10110
`define WB          5'b01000
`define WB_BRANCH   5'b01001
`define WB_JUMP     5'b01010
`define WB_STORE    5'b01011
`define WB_LOAD     5'b01100
`define WB_MRET     5'b01110
`define INTERR      5'b01111

module ctrl(
    input [31:0] INSTR,
    input INSTR_GNT,
    input INSTR_R_VALID,
    input DATA_GNT,
    input DATA_R_VALID,
    input IRQ,
    input CLK,
    input RES,
    input [31:0] MEM_ADDR,
    output REG_WRITE_PRIMARY,
    output REG_WRITE_SECONDARY,
    output INSTR_REQ,
    output DATA_REQ,
    output DATA_WRITE_ENABLE,
    output PC_ENABLE,
    output BACKUP_PC,
    output RESTORE_PC,
    output BRANCH,
    output MUL_BUFFER_ENABLE,
    output IRQ_ACK,
    output INSTRET,
    output SECONDARY_MEM_ACCESS,
    output reg [5:0] ALU_CTRL,
    output reg ALU_MUX_CTRL_A,
    output reg ALU_MUX_CTRL_B,
    output reg [2:0] REG_MUX_CTRL,
    output [1:0] PC_MUX_CTRL
    );
    
    reg [4:0] state;
    reg is_interr;
    
    reg SECONDARY_MEM_ACCESS_REQUIRED;
    always @(INSTR, MEM_ADDR) begin
        if(INSTR[13:12] == 2'b00) begin
            SECONDARY_MEM_ACCESS_REQUIRED = 0;
        end else if(INSTR[13:12] == 2'b01) begin
            SECONDARY_MEM_ACCESS_REQUIRED = (MEM_ADDR[1:0] == 2'b11) ? 1'b1 : 1'b0;
        end else begin
            SECONDARY_MEM_ACCESS_REQUIRED = (MEM_ADDR[1:0] == 2'b00) ? 1'b0 : 1'b1;
        end
    end
    
    // Zustandsuebergaenge
    always @(posedge RES, posedge CLK) begin
        if (RES == 1) begin
            state <= `INSTR_REQ;
            is_interr <= 0;
        end
        
        else case (state)
            `INSTR_REQ:
                state <= INSTR_GNT == 1 ? `INSTR_WAIT : `INSTR_REQ;
            `INSTR_WAIT:
                state <= INSTR_R_VALID == 1 ? `EXEC : `INSTR_WAIT;
            `EXEC:
                if (INSTR[`OPCODE] == `OPCODE_OP && INSTR[25] == 1) state <= `MUL_BUFFER;
                else if (INSTR[`OPCODE] == `OPCODE_BRANCH) state <= `WB_BRANCH;
                else if (INSTR[`OPCODE] == `OPCODE_JAL || INSTR[`OPCODE] == `OPCODE_JALR) state <= `WB_JUMP;
                else if (INSTR[`OPCODE] == `OPCODE_STORE) state <= `STORE_REQ;
                else if (INSTR[`OPCODE] == `OPCODE_LOAD) state <= `LOAD_REQ;
                else if (INSTR[`OPCODE] == `OPCODE_MRET_CSR && INSTR[`FUNCT3] == 3'b000) state <= `WB_MRET;
                else state <= `WB;
            `MUL_BUFFER:
                state <= `WB;
            `STORE_REQ:
                state <= DATA_GNT == 1 ? ((SECONDARY_MEM_ACCESS_REQUIRED) ? `STORE_REQ_2 : `WB_STORE) : `STORE_REQ;
            `LOAD_REQ:
                state <= DATA_GNT == 1 ? `LOAD_WAIT : `LOAD_REQ;
            `LOAD_WAIT:
                state <= DATA_R_VALID == 1 ? ((SECONDARY_MEM_ACCESS_REQUIRED) ? `LOAD_REQ_2 : `WB_LOAD) : `LOAD_WAIT;
            `STORE_REQ_2:
                state <= DATA_GNT == 1 ? `WB_STORE : `STORE_REQ_2;
            `LOAD_REQ_2:
                state <= DATA_GNT == 1 ? `LOAD_WAIT_2 : `LOAD_REQ_2;
            `LOAD_WAIT_2:
                state <= DATA_R_VALID == 1 ? `WB_LOAD : `LOAD_WAIT_2;
            `WB:
                state <= (IRQ == 1 && is_interr == 0) ? `INTERR : `INSTR_REQ;
            `WB_BRANCH:
                state <= (IRQ == 1 && is_interr == 0) ? `INTERR : `INSTR_REQ;
            `WB_JUMP:
                state <= (IRQ == 1 && is_interr == 0) ? `INTERR : `INSTR_REQ;
            `WB_STORE:
                state <= (IRQ == 1 && is_interr == 0) ? `INTERR : `INSTR_REQ;
            `WB_LOAD:
                state <= (IRQ == 1 && is_interr == 0) ? `INTERR : `INSTR_REQ;
            `WB_MRET: begin
                state <= (IRQ == 1) ? `INTERR : `INSTR_REQ;
                is_interr <= 0;
            end
            `INTERR: begin
                state <= `INSTR_REQ;
                is_interr <= 1;
            end
            default:
                state <= `INSTR_REQ;
        endcase
    end
    
    // Zustandsabhaengige Ausgangsbelegung
    assign PC_ENABLE = state[3];
    assign REG_WRITE_PRIMARY = (state == `WB & (~(INSTR[`OPCODE] == `OPCODE_TRANSFER) | INSTR[`FUNCT3] == 3'b000)) | (state == `WB_JUMP) | (state == `WB_LOAD);
    assign REG_WRITE_SECONDARY = (state == `WB & (~(INSTR[`OPCODE] == `OPCODE_TRANSFER) | INSTR[`FUNCT3] == 3'b001)) | (state == `WB_JUMP) | (state == `WB_LOAD);
    assign BRANCH = (state == `WB_BRANCH) | (state == `WB_JUMP);
    assign MUL_BUFFER_ENABLE = (state == `MUL_BUFFER) & (INSTR[`OPCODE] == `OPCODE_OP) & (INSTR[25] == 1);
    assign INSTR_REQ = state == `INSTR_REQ;
    assign DATA_REQ = (state == `STORE_REQ) | (state == `LOAD_REQ) | (state == `STORE_REQ_2) | (state == `LOAD_REQ_2);
    assign DATA_WRITE_ENABLE = (state == `STORE_REQ) | (state == `STORE_REQ_2);
    assign BACKUP_PC = state == `INTERR;
    assign RESTORE_PC = (state == `INTERR) | (state == `WB_MRET);
    assign IRQ_ACK = state == `INTERR;
    assign PC_MUX_CTRL = {state[2], ~(state[0])};
    assign INSTRET = (state == `WB) | (state == `WB_BRANCH) | (state == `WB_JUMP) | (state == `WB_STORE) | (state == `WB_LOAD) | (state == `WB_MRET);
    assign SECONDARY_MEM_ACCESS = state[4];
    
    // Kombinatorische generierung: ALU_CTRL
    always @(INSTR) begin
        case(INSTR[`OPCODE]) //unterscheidung nach opcode
            `OPCODE_JALR: ALU_CTRL = `ALU_ADD;
            `OPCODE_JAL: ALU_CTRL = `ALU_ADD;
            `OPCODE_AUIPC: ALU_CTRL = `ALU_ADD;
            `OPCODE_LUI: ALU_CTRL = `ALU_BNE;
            `OPCODE_LOAD: ALU_CTRL = `ALU_ADD;
            `OPCODE_STORE: ALU_CTRL = `ALU_ADD;
            default: ALU_CTRL = {INSTR[30], INSTR[14:12], INSTR[6:5]};
        endcase
        
        if (INSTR[`OPCODE] == `OPCODE_OP && INSTR[25] == 1) ALU_CTRL = `ALU_MUL;
    end
    
    // Kombinatorische generierung: MUX_CTRL
    always @(INSTR) begin
        //Default
        ALU_MUX_CTRL_A = 1'b0;
        ALU_MUX_CTRL_B = 1'b0;
        REG_MUX_CTRL = 3'b0;
        
        case(INSTR[`OPCODE]) //unterscheidung nach opcode
            `OPCODE_OP: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b0;
                if (INSTR[25] == 1) REG_MUX_CTRL = 3'd3;
                else REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_OPIMM: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_STORE: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_LOAD: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd2;
            end
            `OPCODE_BRANCH: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b0;
                REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_JALR: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd1;
            end
            `OPCODE_JAL: begin
                ALU_MUX_CTRL_A = 1'b1;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd1;
            end
            `OPCODE_AUIPC: begin
                ALU_MUX_CTRL_A = 1'b1;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_LUI: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b1;
                REG_MUX_CTRL = 3'd0;
            end
            `OPCODE_MRET_CSR: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b0;
                REG_MUX_CTRL = 3'd4;
            end
            `OPCODE_TRANSFER: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b0;
                REG_MUX_CTRL = 3'd5;
            end
            default: begin
                ALU_MUX_CTRL_A = 1'b0;
                ALU_MUX_CTRL_B = 1'b0;
                REG_MUX_CTRL = 3'd0;
            end
        endcase
    end
    
endmodule
