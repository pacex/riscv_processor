`timescale 1ns / 1ps

`include "instruction_formatting.vh"

module memory_interface(
    input CLK,
    input RES,
    input [31:0] INSTR,
    input SECONDARY_ACCESS,
    input [31:0] ADDR,
    output [31:0] READ,
    input [31:0] WRITE,
    input [31:0] DATA_READ,
    output [31:0] DATA_WRITE,
    output [3:0] DATA_BE,
    output [31:0] DATA_ADDR,
    input DATA_R_VALID
    );
    
    wire [31:0] DATA_READ_A;
    wire [31:0] DATA_READ_B;
    
    wire [31:0] DATA_WRITE_A;
    wire [31:0] DATA_WRITE_B;
    
    assign DATA_WRITE = (SECONDARY_ACCESS) ? DATA_WRITE_B : DATA_WRITE_A;
    
    wire [31:0] DATA_ADDR_A;
    wire [31:0] DATA_ADDR_B;
    
    assign DATA_ADDR_A = {ADDR[31:2], 2'b0};
    assign DATA_ADDR_B = DATA_ADDR_A + 4;
    assign DATA_ADDR = (SECONDARY_ACCESS) ? DATA_ADDR_B : DATA_ADDR_A;
    
    wire [3:0] DATA_BE_A;
    wire [3:0] DATA_BE_B;
    
    assign DATA_BE = (SECONDARY_ACCESS) ? DATA_BE_B : DATA_BE_A;
    
    wire [2:0] LUT_ROW_3;
    wire [4:0] LUT_ROW_5;
    
    assign LUT_ROW_3 = {
        (INSTR[`FUNCT3] == 3'b000) | (INSTR[`FUNCT3] == 3'b100),
        (INSTR[`FUNCT3] == 3'b001) | (INSTR[`FUNCT3] == 3'b101),
        INSTR[`FUNCT3] == 3'b010
    };
    assign LUT_ROW_5 = {
        INSTR[14] & ~INSTR[12],
        ~INSTR[14] & ~INSTR[13] & ~INSTR[12],
        INSTR[14] & INSTR[12],
        ~INSTR[14] & INSTR[12],
        INSTR[13]
    };
    
    REG_DRE_32 MEM_BUFFER_A(
        .CLK(CLK),
        .RES(RES),
        .ENABLE(DATA_R_VALID & (~SECONDARY_ACCESS)),
        .D(DATA_READ),
        .Q(DATA_READ_A)
        );
            
    REG_DRE_32 MEM_BUFFER_B(
        .CLK(CLK),
        .RES(RES),
        .ENABLE(DATA_R_VALID & SECONDARY_ACCESS),
        .D(DATA_READ),
        .Q(DATA_READ_B)
        );
        
    table3x4_sel DATA_BE_A_LUT(
        .col(ADDR[1:0]),
        .row(LUT_ROW_3),
        .in_0x0(32'b1111),
        .in_0x1(32'b1110),
        .in_0x2(32'b1100),
        .in_0x3(32'b1000),
        .in_1x0(32'b0011),
        .in_1x1(32'b0110),
        .in_1x2(32'b1100),
        .in_1x3(32'b1000),
        .in_2x0(32'b0001),
        .in_2x1(32'b0010),
        .in_2x2(32'b0100),
        .in_2x3(32'b1000),
        .selected(DATA_BE_A)
        );
        
    table3x4_sel DATA_BE_B_LUT(
        .col(ADDR[1:0]),
        .row(LUT_ROW_3),
        .in_0x0(32'b0000),
        .in_0x1(32'b0001),
        .in_0x2(32'b0011),
        .in_0x3(32'b0111),
        .in_1x0(32'b0000),
        .in_1x1(32'b0000),
        .in_1x2(32'b0000),
        .in_1x3(32'b0001),
        .in_2x0(32'b0000),
        .in_2x1(32'b0000),
        .in_2x2(32'b0000),
        .in_2x3(32'b0000),
        .selected(DATA_BE_B)
        );
        
    assign DATA_WRITE_A = WRITE << (ADDR[1:0] * 8);
    
    table3x4_sel DATA_WRITE_LUT_B(
        .col(ADDR[1:0]),
        .row(LUT_ROW_3),
        .in_0x0(32'b0),
        .in_0x1({24'b0, WRITE[31:24]}),
        .in_0x2({16'b0, WRITE[31:16]}),
        .in_0x3({8'b0, WRITE[31:8]}),
        .in_1x0(32'b0),
        .in_1x1(32'b0),
        .in_1x2(32'b0),
        .in_1x3({24'b0, WRITE[15:8]}),
        .in_2x0(32'b0),
        .in_2x1(32'b0),
        .in_2x2(32'b0),
        .in_2x3(32'b0),
        .selected(DATA_WRITE_B)
        );
        
    table5x4_sel DATA_READ_LUT(
        .col(ADDR[1:0]),
        .row(LUT_ROW_5),
        .in_0x0(DATA_READ_A[31:0]),
        .in_0x1({DATA_READ_B[7:0], DATA_READ_A[31:8]}),
        .in_0x2({DATA_READ_B[15:0], DATA_READ_A[31:16]}),
        .in_0x3({DATA_READ_B[23:0], DATA_READ_A[31:24]}),
        .in_1x0({{17{DATA_READ_A[15]}}, DATA_READ_A[14:0]}),
        .in_1x1({{17{DATA_READ_A[23]}}, DATA_READ_A[22:8]}),
        .in_1x2({{17{DATA_READ_A[31]}}, DATA_READ_A[30:16]}),
        .in_1x3({{17{DATA_READ_B[7]}}, DATA_READ_B[6:0], DATA_READ_A[31:24]}),
        .in_2x0({16'b0, DATA_READ_A[15:0]}),
        .in_2x1({16'b0, DATA_READ_A[23:8]}),
        .in_2x2({16'b0, DATA_READ_A[31:16]}),
        .in_2x3({16'b0, DATA_READ_B[7:0], DATA_READ_A[31:24]}),
        .in_3x0({{25{DATA_READ_A[7]}}, DATA_READ_A[6:0]}),
        .in_3x1({{25{DATA_READ_A[15]}}, DATA_READ_A[14:8]}),
        .in_3x2({{25{DATA_READ_A[23]}}, DATA_READ_A[22:16]}),
        .in_3x3({{25{DATA_READ_A[31]}}, DATA_READ_A[30:24]}),
        .in_4x0({24'b0, DATA_READ_A[7:0]}),
        .in_4x1({24'b0, DATA_READ_A[15:8]}),
        .in_4x2({24'b0, DATA_READ_A[23:16]}),
        .in_4x3({24'b0, DATA_READ_A[31:24]}),
        .selected(READ)
        );
    
endmodule
