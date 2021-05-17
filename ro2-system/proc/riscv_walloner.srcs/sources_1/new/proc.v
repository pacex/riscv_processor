`timescale 1ns / 1ps

`include "instruction_formatting.vh"

module proc
    #(
    parameter HARTID = 0,
    parameter CLK_CYCLE = 40
    )(
    input CLK,
    input RES,
    
    input [31:0] INSTR_READ,
    output [31:0] INSTR_ADR,
    output INSTR_REQ,
    input INSTR_GNT,
    input INSTR_R_VALID,
    
    input [31:0] DATA_READ,
    output [31:0] DATA_WRITE,
    output [31:0] DATA_ADR,
    output DATA_REQ,
    input DATA_GNT,
    input DATA_R_VALID,
    output DATA_WRITE_ENABLE,
    output [3:0] DATA_BE,
    
    input IRQ,
    input [4:0] IRQ_ID,
    output IRQ_ACK,
    output [4:0] IRQ_ACK_ID
    
    );
    
    //Control signals
    wire REG_WR_PRIMARY;
    wire REG_WR_SECONDARY;
    wire PC_ENABLE;
    wire BACKUP_PC;
    wire RESTORE_PC;
    wire BRANCH;
    wire MUL_BUFFER_ENABLE;
    wire INSTRET;
    wire SECONDARY_MEM_ACCESS;
    
    wire CMP;
    
    wire MUX_CTRL_A;
    wire MUX_CTRL_B;
    wire [2:0] MUX_CTRL_REGDATA;
    wire [1:0] MUX_CTRL_PC;
    
    wire [5:0] ALU_CTRL;
    
    //Data lines
    wire [31:0] IMM;
    wire [31:0] REG_WRITE_DATA_PRIMARY;
    wire [31:0] REG_WRITE_DATA_SECONDARY;
    wire [31:0] Q0_PRIMARY;
    wire [31:0] Q1_PRIMARY;
    wire [31:0] Q0_SECONDARY;
    wire [31:0] Q1_SECONDARY;
    wire [31:0] A_PRIMARY;
    wire [31:0] B_PRIMARY;
    wire [31:0] A_SECONDARY;
    wire [31:0] B_SECONDARY;
    wire [31:0] ALU_RESULT_PRIMARY;
    wire [31:0] ALU_RESULT_SECONDARY;
    wire [31:0] MUL_BUFFER_PRIMARY;
    wire [31:0] MUL_BUFFER_SECONDARY;
    wire [31:0] CSR_DATA;
    
    //Instruction Bus
    wire [31:0] INSTR_BUS;
    
    //Memory Data Bus
    wire [31:0] MEM_BUS;
    
    //PC
    wire [31:0] PC_BUS;
    wire [31:0] PC_NEXT;
    wire [31:0] PC_JMP_REL;
    wire [31:0] PC_JMP_ABS;
    wire [31:0] PC_BACKUP;
    wire PC_MODE;
    
    assign PC_MODE = (BRANCH & (CMP | INSTR_BUS[2])) | RESTORE_PC;
    assign INSTR_ADR = PC_BUS;
    assign IRQ_ACK_ID = IRQ_ID;
    
    //Addierer zum berechnen der n�chsten Befehlsadresse (z.B. f�r JALR)
    ADDS_32 PC_NEXT_ADDER(
        .A(PC_BUS),
        .B(32'b100),
        .Q(PC_NEXT));
    
    //Addierer zur berechnung der Absoluten Sprungadresse
    ADDS_32 PC_JMP_ADDER(.A({{20{INSTR_BUS[31]}}, INSTR_BUS[7], INSTR_BUS[30:25], INSTR_BUS[11:8], 1'b0}),
                        .B(PC_BUS),
                        .Q(PC_JMP_REL));
    
    //Multiplexer zum Auswaehlen der Quelle der relativen Sprungadresse
    MUX_4x1_32 BRANCH_JMP_MUX(.I0(PC_JMP_REL),
                             .I1(ALU_RESULT_PRIMARY),
                             .I2((IRQ_ID << 2) + 32'h1C008000),
                             .I3(PC_BACKUP),
                             .S(MUX_CTRL_PC),
                             .Y(PC_JMP_ABS));
                        
    //Register zum Speichern des PC waehrend Interrupt-Behandlungen
    REG_DRE_32 PC_BACKUP_REG(
        .D(PC_BUS),
        .Q(PC_BACKUP),
        .CLK(CLK),
        .RES(RES),
        .ENABLE(BACKUP_PC));
    
    //Program Counter
    pc PC(.D(PC_JMP_ABS),
         .MODE(PC_MODE),
         .ENABLE(PC_ENABLE),
         .CLK(CLK),
         .RES(RES),
         .PC_OUT(PC_BUS));
    
    //Instruction Register
    REG_DRE_32 INSTR_REG(.D(INSTR_READ),
                        .Q(INSTR_BUS),
                        .CLK(CLK),
                        .RES(RES),
                        .ENABLE(INSTR_R_VALID));
    
    //Memory interface    
    memory_interface MEM_INTERFACE(
        .CLK(CLK),
        .RES(RES),
        .INSTR(INSTR_BUS),
        .SECONDARY_ACCESS(SECONDARY_MEM_ACCESS),
        .ADDR(ALU_RESULT_PRIMARY),
        .READ(MEM_BUS),
        .WRITE(Q1_PRIMARY),
        .DATA_READ(DATA_READ),
        .DATA_WRITE(DATA_WRITE),
        .DATA_BE(DATA_BE),
        .DATA_ADDR(DATA_ADR),
        .DATA_R_VALID(DATA_R_VALID)
        );
    
    //RegSet input MUX
    MUX_8x1_32 REG_MUX_PRIMARY(
        .I0(ALU_RESULT_PRIMARY),
        .I1(PC_NEXT),
        .I2(MEM_BUS),
        .I3(MUL_BUFFER_PRIMARY),
        .I4(CSR_DATA),
        .I5(Q0_SECONDARY),
        .S(MUX_CTRL_REGDATA),
        .Y(REG_WRITE_DATA_PRIMARY));
        
    MUX_8x1_32 REG_MUX_SECONDARY(
        .I0(ALU_RESULT_SECONDARY),
        .I1(PC_NEXT),
        .I2(MEM_BUS),
        .I3(MUL_BUFFER_SECONDARY),
        .I4(CSR_DATA),
        .I5(Q0_PRIMARY),
        .S(MUX_CTRL_REGDATA),
        .Y(REG_WRITE_DATA_SECONDARY));
    
    //RegSet
    regset REGSET_PRIMARY(.D(REG_WRITE_DATA_PRIMARY),
                 .A_D(INSTR_BUS[`RD]),
                 .A_Q0(INSTR_BUS[`RS1]),
                 .A_Q1(INSTR_BUS[`RS2]),
                 .write_enable(REG_WR_PRIMARY),
                 .RES(RES),
                 .CLK(CLK),
                 .Q0(Q0_PRIMARY),
                 .Q1(Q1_PRIMARY)
                 );
                 
    regset REGSET_SECONDARY(.D(REG_WRITE_DATA_SECONDARY),
                 .A_D(INSTR_BUS[`RD]),
                 .A_Q0(INSTR_BUS[`RS1]),
                 .A_Q1(INSTR_BUS[`RS2]),
                 .write_enable(REG_WR_SECONDARY),
                 .RES(RES),
                 .CLK(CLK),
                 .Q0(Q0_SECONDARY),
                 .Q1(Q1_SECONDARY)
                 );
    
    //ImmGen
    immgen IMMGEN(.INSTR(INSTR_BUS),
                 .IMM(IMM));
    
    //Data Mux A (Q0 <=> PC)
    MUX_2x1_32 DATA_MUX_A_PRIMARY(.I0(Q0_PRIMARY),
                         .I1(PC_BUS),
                         .S(MUX_CTRL_A),
                         .Y(A_PRIMARY));
                         
    MUX_2x1_32 DATA_MUX_A_SECONDARY(.I0(Q0_SECONDARY),
                         .I1(PC_BUS),
                         .S(MUX_CTRL_A),
                         .Y(A_SECONDARY));
    
    //Data Mux B (Q0 <=> IMM)
    MUX_2x1_32 DATA_MUX_B_PRIMARY(.I0(Q1_PRIMARY),
                         .I1(IMM),
                         .S(MUX_CTRL_B),
                         .Y(B_PRIMARY));
                          
    MUX_2x1_32 DATA_MUX_B_SECONDARY(.I0(Q1_SECONDARY),
                         .I1(IMM),
                         .S(MUX_CTRL_B),
                         .Y(B_SECONDARY));
    
    //ALU
    alu ALU_PRIMARY(.S(ALU_CTRL),
            .A(A_PRIMARY),
            .B(B_PRIMARY),
            .Q(ALU_RESULT_PRIMARY),
            .CMP(CMP));
            
    alu ALU_SECONDARY(.S(ALU_CTRL),
            .A(A_SECONDARY),
            .B(B_SECONDARY),
            .Q(ALU_RESULT_SECONDARY),
            .CMP());
    
    //MUL Buffer Reg
    REG_DRE_32 MUL_BUFFER_REG_PRIMARY(.D(ALU_RESULT_PRIMARY),
                            .Q(MUL_BUFFER_PRIMARY),
                            .CLK(CLK),
                            .RES(RES),
                            .ENABLE(MUL_BUFFER_ENABLE));
                            
    REG_DRE_32 MUL_BUFFER_REG_SECONDARY(.D(ALU_RESULT_SECONDARY),
                            .Q(MUL_BUFFER_SECONDARY),
                            .CLK(CLK),
                            .RES(RES),
                            .ENABLE(MUL_BUFFER_ENABLE));
    
    //control and status registers
    csr #(
        .HARTID(HARTID),
        .CLK_CYCLE(CLK_CYCLE)
    ) CSR (
        .CLK(CLK),
        .RES(RES),
        .INSTRET(INSTRET),
        .ADDR(IMM),
        .Q(CSR_DATA)
        );
    
    //Control
    ctrl CTRL(.INSTR(INSTR_BUS),
             .INSTR_GNT(INSTR_GNT),
             .INSTR_R_VALID(INSTR_R_VALID),
             .DATA_GNT(DATA_GNT),
             .DATA_R_VALID(DATA_R_VALID),
             .CLK(CLK),
             .RES(RES),
             .REG_WRITE_PRIMARY(REG_WR_PRIMARY),
             .REG_WRITE_SECONDARY(REG_WR_SECONDARY),
             .INSTR_REQ(INSTR_REQ),
             .DATA_REQ(DATA_REQ),
             .DATA_WRITE_ENABLE(DATA_WRITE_ENABLE),
             .PC_ENABLE(PC_ENABLE),
             .BACKUP_PC(BACKUP_PC),
             .RESTORE_PC(RESTORE_PC),
             .BRANCH(BRANCH),
             .MUL_BUFFER_ENABLE(MUL_BUFFER_ENABLE),
             .ALU_CTRL(ALU_CTRL),
             .ALU_MUX_CTRL_A(MUX_CTRL_A),
             .ALU_MUX_CTRL_B(MUX_CTRL_B),
             .REG_MUX_CTRL(MUX_CTRL_REGDATA),
             .PC_MUX_CTRL(MUX_CTRL_PC),
             .IRQ(IRQ),
             .IRQ_ACK(IRQ_ACK),
             .INSTRET(INSTRET),
             .SECONDARY_MEM_ACCESS(SECONDARY_MEM_ACCESS),
             .MEM_ADDR(ALU_RESULT_PRIMARY));
    
endmodule
