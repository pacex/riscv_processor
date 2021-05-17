//Belegungen des ALU Steuersignals bei verschiedenen Befehlen
//note that ADD and ADDI are specified seperatly. Otherwise SUB couldn't be dist
`define ALU_ADD     6'b000001
`define ALU_MUL     6'b000010
`define ALU_ADDI    6'b?00000
`define ALU_SUB     6'b100001
`define ALU_AND     6'b?1110?
`define ALU_OR      6'b?1100?
`define ALU_XOR     6'b?1000?
`define ALU_SLL     6'b00010?
`define ALU_SRL     6'b01010?
`define ALU_SRA     6'b11010?
`define ALU_SLT     6'b?0100?
`define ALU_SLTU    6'b?0110?
`define ALU_BEQ     6'b?00011
`define ALU_BNE     6'b?00111
`define ALU_BLT     6'b?10011
`define ALU_BLTU    6'b?11011
`define ALU_BGE     6'b?10111
`define ALU_BGEU    6'b?11111