`timescale 1ns / 1ps

module system_tb();
    
    reg CLK;
    reg RES;
    reg WRITE_ENABLE;
    
    //Clock signal
    initial begin
        CLK = 0;
        WRITE_ENABLE = 0;
        RES = 1;
        #40
        RES = 0;
    end
    always #20 CLK = ~CLK;
    
    wire [31:0] INSTR;
    wire [31:0] INSTR_ADR;
    wire INSTR_REQ;
    wire INSTR_GNT;
    wire INSTR_VALID;
    
    wire [31:0] DATA_READ, DATA_WRITE, DATA_ADR;
    wire DATA_REQ, DATA_WRITE_ENABLE, DATA_BE, DATA_GNT, DATA_VALID;
    
    proc processor(.CLK(CLK),
                    .RES(RES),
                    .INSTR_READ(INSTR),
                    .INSTR_ADR(INSTR_ADR),
                    .INSTR_REQ(INSTR_REQ),
                    .INSTR_GNT(INSTR_GNT),
                    .INSTR_R_VALID(INSTR_VALID),
                    .DATA_READ(DATA_READ),
                    .DATA_WRITE(DATA_WRITE),
                    .DATA_ADR(DATA_ADR),
                    .DATA_REQ(DATA_REQ),
                    .DATA_GNT(DATA_GNT),
                    .DATA_R_VALID(DATA_VALID),
                    .DATA_WRITE_ENABLE(DATA_WRITE_ENABLE),
                    .DATA_BE(DATA_BE));
    
    memory_sim instr_mem(.clk_i(CLK),
                    .data_read(INSTR),
                    .data_adr(INSTR_ADR),
                    .data_req(INSTR_REQ),
                    .data_gnt(INSTR_GNT),
                    .data_rvalid(INSTR_VALID),
                    .data_write_enable(WRITE_ENABLE));
                    
    memory_sim #(.BASE_ADDR(32'h0)) data_mem(.clk_i(CLK),
                    .data_read(DATA_READ),
                    .data_write(DATA_WRITE),
                    .data_adr(DATA_ADR),
                    .data_req(DATA_REQ),
                    .data_gnt(DATA_GNT),
                    .data_rvalid(DATA_VALID),
                    .data_write_enable(DATA_WRITE_ENABLE));
endmodule
