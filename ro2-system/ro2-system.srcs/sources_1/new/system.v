`timescale 1ns / 1ps

module system(
    input BOARD_CLK,
    input BOARD_RESN,
    output [3:0] BOARD_LED,
    output [2:0] BOARD_LED_RGB0,
    output [2:0] BOARD_LED_RGB1,
    input [3:0] BOARD_BUTTON,
    input [3:0] BOARD_SWITCH,
    output BOARD_VGA_HSYNC,
    output BOARD_VGA_VSYNC,
    output [3:0] BOARD_VGA_R,
    output [3:0] BOARD_VGA_G,
    output [3:0] BOARD_VGA_B,
    input BOARD_UART_RX,
    output BOARD_UART_TX
    );
    
    wire CPU_CLK;
    wire CPU_RES;
    wire CACHE_RES;
    
    //Instruction wires to memory module
    wire [31:0] INSTR_READ;
    wire [31:0] INSTR_ADR;
    wire INSTR_REQ;
    wire INSTR_GNT;
    wire INSTR_R_VALID;
    
    //Instruction wires proc0
    wire [31:0] INSTR_READ0;
    wire [31:0] INSTR_ADR0;
    wire INSTR_REQ0;
    wire INSTR_GNT0;
    wire INSTR_R_VALID0;
    
    wire [31:0] CACHED_INSTR_READ0;
    wire [31:0] CACHED_INSTR_ADR0;
    wire CACHED_INSTR_REQ0;
    wire CACHED_INSTR_GNT0;
    wire CACHED_INSTR_R_VALID0;
    
    //Instruction wires proc1
    wire [31:0] INSTR_READ1;
    wire [31:0] INSTR_ADR1;
    wire INSTR_REQ1;
    wire INSTR_GNT1;
    wire INSTR_R_VALID1;
    
    wire [31:0] CACHED_INSTR_READ1;
    wire [31:0] CACHED_INSTR_ADR1;
    wire CACHED_INSTR_REQ1;
    wire CACHED_INSTR_GNT1;
    wire CACHED_INSTR_R_VALID1;
    
    //Data wires to memory module
    wire [31:0] DATA_READ;
    wire [31:0] DATA_WRITE;
    wire [31:0] DATA_ADR;
    wire DATA_REQ;
    wire DATA_GNT;
    wire DATA_R_VALID;
    wire DATA_WRITE_ENABLE;
    wire [3:0] DATA_BE;
    
    //Data wires proc0
    wire [31:0] DATA_READ0;
    wire [31:0] DATA_WRITE0;
    wire [31:0] DATA_ADR0;
    wire DATA_REQ0;
    wire DATA_GNT0;
    wire DATA_R_VALID0;
    wire DATA_WRITE_ENABLE0;
    wire [3:0] DATA_BE0;
    
    //Data wires proc1
    wire [31:0] DATA_READ1;
    wire [31:0] DATA_WRITE1;
    wire [31:0] DATA_ADR1;
    wire DATA_REQ1;
    wire DATA_GNT1;
    wire DATA_R_VALID1;
    wire DATA_WRITE_ENABLE1;
    wire [3:0] DATA_BE1;
    
    wire IRQ;
    wire [4:0] IRQ_ID;
    wire IRQ_ACK;
    wire [4:0] IRQ_ACK_ID;
    
    reg clk;
    
    /*  ==============
        ====PROC 0====
        ==============
    */
    
    proc #(.CLK_CYCLE(40),.HARTID(0)) proc0(
        .CLK(CPU_CLK),
        .RES(CPU_RES),
        .INSTR_READ(CACHED_INSTR_READ0),
        .INSTR_ADR(CACHED_INSTR_ADR0),
        .INSTR_REQ(CACHED_INSTR_REQ0),
        .INSTR_GNT(CACHED_INSTR_GNT0),
        .INSTR_R_VALID(CACHED_INSTR_R_VALID0),
        .DATA_READ(DATA_READ0),
        .DATA_WRITE(DATA_WRITE0),
        .DATA_ADR(DATA_ADR0),
        .DATA_REQ(DATA_REQ0),
        .DATA_GNT(DATA_GNT0),
        .DATA_R_VALID(DATA_R_VALID0),
        .DATA_WRITE_ENABLE(DATA_WRITE_ENABLE0),
        .DATA_BE(DATA_BE0),
        .IRQ(IRQ),
        .IRQ_ID(IRQ_ID),
        .IRQ_ACK(IRQ_ACK),
        .IRQ_ACK_ID(IRQ_ACK_ID));
        
    instr_cache instruction_cache0(
        .clk(CPU_CLK),
        .res(CACHE_RES),
        .cached_instr_req(CACHED_INSTR_REQ0),
        .cached_instr_adr(CACHED_INSTR_ADR0),
        .cached_instr_gnt(CACHED_INSTR_GNT0),
        .cached_instr_rvalid(CACHED_INSTR_R_VALID0),
        .cached_instr_read(CACHED_INSTR_READ0),
        .instr_req(INSTR_REQ0),
        .instr_adr(INSTR_ADR0),
        .instr_gnt(INSTR_GNT0),
        .instr_rvalid(INSTR_R_VALID0),
        .instr_read(INSTR_READ0)
    );
    
    /*  ==============
        ====PROC 1====
        ==============
    */
    
    proc #(.CLK_CYCLE(40),.HARTID(1)) proc1(
        .CLK(CPU_CLK),
        .RES(CPU_RES),
        .INSTR_READ(CACHED_INSTR_READ1),
        .INSTR_ADR(CACHED_INSTR_ADR1),
        .INSTR_REQ(CACHED_INSTR_REQ1),
        .INSTR_GNT(CACHED_INSTR_GNT1),
        .INSTR_R_VALID(CACHED_INSTR_R_VALID1),
        .DATA_READ(DATA_READ1),
        .DATA_WRITE(DATA_WRITE1),
        .DATA_ADR(DATA_ADR1),
        .DATA_REQ(DATA_REQ1),
        .DATA_GNT(DATA_GNT1),
        .DATA_R_VALID(DATA_R_VALID1),
        .DATA_WRITE_ENABLE(DATA_WRITE_ENABLE1),
        .DATA_BE(DATA_BE1),
        .IRQ(1'b0),
        .IRQ_ID(5'b0),
        .IRQ_ACK(),
        .IRQ_ACK_ID());
        
    instr_cache instruction_cache1(
        .clk(CPU_CLK),
        .res(CACHE_RES),
        .cached_instr_req(CACHED_INSTR_REQ1),
        .cached_instr_adr(CACHED_INSTR_ADR1),
        .cached_instr_gnt(CACHED_INSTR_GNT1),
        .cached_instr_rvalid(CACHED_INSTR_R_VALID1),
        .cached_instr_read(CACHED_INSTR_READ1),
        .instr_req(INSTR_REQ1),
        .instr_adr(INSTR_ADR1),
        .instr_gnt(INSTR_GNT1),
        .instr_rvalid(INSTR_R_VALID1),
        .instr_read(INSTR_READ1)
    );
    
    //DATA MEM CTRL
    mem_access_ctrl data_mem_ctrl(
        .CLK(CPU_CLK),
        .RES(CPU_RES),
        
        .data_read(DATA_READ),
        .data_write(DATA_WRITE),
        .data_adr(DATA_ADR),
        .data_req(DATA_REQ),
        .data_gnt(DATA_GNT),
        .data_r_valid(DATA_R_VALID),
        .data_write_enable(DATA_WRITE_ENABLE),
        .data_be(DATA_BE),
        
        .proc0_read(DATA_READ0),
        .proc0_write(DATA_WRITE0),
        .proc0_adr(DATA_ADR0),
        .proc0_req(DATA_REQ0),
        .proc0_gnt(DATA_GNT0),
        .proc0_r_valid(DATA_R_VALID0),
        .proc0_write_enable(DATA_WRITE_ENABLE0),
        .proc0_be(DATA_BE0),
        
        .proc1_read(DATA_READ1),
        .proc1_write(DATA_WRITE1),
        .proc1_adr(DATA_ADR1),
        .proc1_req(DATA_REQ1),
        .proc1_gnt(DATA_GNT1),
        .proc1_r_valid(DATA_R_VALID1),
        .proc1_write_enable(DATA_WRITE_ENABLE1),
        .proc1_be(DATA_BE1));
    
    //INSTR MEM CTRL
    mem_access_ctrl instr_mem_ctrl(
        .CLK(CPU_CLK),
        .RES(CPU_RES),
        
        .data_read(INSTR_READ),
        .data_write(),
        .data_adr(INSTR_ADR),
        .data_req(INSTR_REQ),
        .data_gnt(INSTR_GNT),
        .data_r_valid(INSTR_R_VALID),
        .data_write_enable(),
        .data_be(),
        
        .proc0_read(INSTR_READ0),
        .proc0_write(32'b0),
        .proc0_adr(INSTR_ADR0),
        .proc0_req(INSTR_REQ0),
        .proc0_gnt(INSTR_GNT0),
        .proc0_r_valid(INSTR_R_VALID0),
        .proc0_write_enable(1'b0),
        .proc0_be(4'b0),
        
        .proc1_read(INSTR_READ1),
        .proc1_write(32'b0),
        .proc1_adr(INSTR_ADR1),
        .proc1_req(INSTR_REQ1),
        .proc1_gnt(INSTR_GNT1),
        .proc1_r_valid(INSTR_R_VALID1),
        .proc1_write_enable(1'b0),
        .proc1_be(4'b0));
    
        
    pulpus pulpus_system(
        .BOARD_CLK(clk),
        .BOARD_RESN(BOARD_RESN),
        .BOARD_LED(BOARD_LED),
        .BOARD_LED_RGB0(BOARD_LED_RGB0),
        .BOARD_LED_RGB1(BOARD_LED_RGB1),
        .BOARD_BUTTON(BOARD_BUTTON),
        .BOARD_SWITCH(BOARD_SWITCH),
        .BOARD_VGA_HSYNC(BOARD_VGA_HSYNC),
        .BOARD_VGA_VSYNC(BOARD_VGA_VSYNC),
        .BOARD_VGA_R(BOARD_VGA_R),
        .BOARD_VGA_G(BOARD_VGA_G),
        .BOARD_VGA_B(BOARD_VGA_B),
        .BOARD_UART_RX(BOARD_UART_RX),
        .BOARD_UART_TX(BOARD_UART_TX),
        .CPU_CLK(CPU_CLK),
        .CPU_RES(CPU_RES),
        .CACHE_RES(CACHE_RES),
        .INSTR_REQ(INSTR_REQ),
        .INSTR_GNT(INSTR_GNT),
        .INSTR_RVALID(INSTR_R_VALID),
        .INSTR_ADDR(INSTR_ADR),
        .INSTR_RDATA(INSTR_READ),
        .DATA_REQ(DATA_REQ),
        .DATA_GNT(DATA_GNT),
        .DATA_RVALID(DATA_R_VALID),
        .DATA_WE(DATA_WRITE_ENABLE),
        .DATA_BE(DATA_BE),
        .DATA_ADDR(DATA_ADR),
        .DATA_WDATA(DATA_WRITE),
        .DATA_RDATA(DATA_READ),
        .IRQ(IRQ),
        .IRQ_ID(IRQ_ID),
        .IRQ_ACK(IRQ_ACK),
        .IRQ_ACK_ID(IRQ_ACK_ID));
        
    `ifdef XILINX_SIMULATOR
        initial
        begin
            clk = 0;
        end
        always
            #5 clk = ~clk;
    `else
        always @(BOARD_CLK)
            clk = BOARD_CLK;
    `endif
endmodule
