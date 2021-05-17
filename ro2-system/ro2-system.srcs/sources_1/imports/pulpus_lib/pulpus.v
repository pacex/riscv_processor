//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2018 15:18:14
// Design Name: 
// Module Name: pulpus
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: simple wrapper of pulpissimo for ro2
// 
//////////////////////////////////////////////////////////////////////////////////


module pulpus(
     /* BOARD SIGNALS */
     input         BOARD_CLK,
     input         BOARD_RESN,   
     
     output  [3:0] BOARD_LED,
     output  [2:0] BOARD_LED_RGB0,
     output  [2:0] BOARD_LED_RGB1,
     
     input   [3:0] BOARD_BUTTON,
     input   [3:0] BOARD_SWITCH,
     
     output        BOARD_VGA_HSYNC,
     output        BOARD_VGA_VSYNC,
     output  [3:0] BOARD_VGA_R,
     output  [3:0] BOARD_VGA_B,
     output  [3:0] BOARD_VGA_G,      
     inout         BOARD_UART_RX,
     inout         BOARD_UART_TX,  
     /* CORE SIGNALS */
     output        CPU_CLK,  
     output        CPU_RES,
     output        CACHE_RES, 
     // Instruction memory interface
     input         INSTR_REQ,
     output        INSTR_GNT,
     output        INSTR_RVALID,
     input  [31:0] INSTR_ADDR,
     output [31:0] INSTR_RDATA,
   
     // Data memory interface
     input         DATA_REQ,
     output        DATA_GNT,
     output        DATA_RVALID,
     input         DATA_WE,
     input   [3:0] DATA_BE,
     input  [31:0] DATA_ADDR,
     input  [31:0] DATA_WDATA,
     output [31:0] DATA_RDATA,
     // Interrupt outputs
     output        IRQ,                 // level sensitive IR lines
     output  [4:0] IRQ_ID,
     // Interrupt inputs
     input         IRQ_ACK,             // irq ack
     input   [4:0] IRQ_ACK_ID                  
  );    
  wire cpu_res_tmp;
  assign CPU_RES=~cpu_res_tmp;
  reg cache_res=1'b1;
  /*always @(posedge CPU_CLK)
  begin
    if(CPU_RES==1'b1)
      cache_res <= 1'b1;
      `ifndef XILINX_SIMULATOR
         else if(INSTR_ADDR==32'h1A0001d4) begin
           cache_res <= 1'b0;
         end
      `else
         else if(INSTR_ADDR==32'h1A000000) begin
           cache_res <= 1'b0;
         end
      `endif
  end*/
  assign CACHE_RES = CPU_RES;
      pulpissimo_emu soc
      (
        .pad_xtal_in(BOARD_CLK),
        .resn(BOARD_RESN),
        
        .LED(BOARD_LED),
        .BTN(BOARD_BUTTON),
        .SW(BOARD_SWITCH),
        
        .VGA_HS_O( BOARD_VGA_HSYNC ),
        .VGA_VS_O( BOARD_VGA_VSYNC ),
        .VGA_R( BOARD_VGA_R ),
        .VGA_B( BOARD_VGA_B ),
        .VGA_G( BOARD_VGA_G ),
        
        .pad_uart_tx(BOARD_UART_TX),
        .pad_uart_rx(BOARD_UART_RX),
        
        .c_clk_i(CPU_CLK),
        .c_rst_ni(cpu_res_tmp),
        .c_instr_req_o(INSTR_REQ),
        .c_instr_gnt_i(INSTR_GNT),
        .c_instr_rvalid_i(INSTR_RVALID),
        .c_instr_addr_o(INSTR_ADDR),
        .c_instr_rdata_i(INSTR_RDATA),
                
        .c_data_req_o   (DATA_REQ),
        .c_data_gnt_i   (DATA_GNT),
        .c_data_rvalid_i(DATA_RVALID),
        .c_data_we_o    (DATA_WE),
        .c_data_be_o    (DATA_BE),
        .c_data_addr_o  (DATA_ADDR),
        .c_data_wdata_o (DATA_WDATA),
        .c_data_rdata_i (DATA_RDATA),        
        //.c_data_err_i (DATA_RDATA),    
        
        .c_irq_i(IRQ),
        .c_irq_id_i(IRQ_ID),
        .c_irq_ack_o(IRQ_ACK),
        .c_irq_id_o(IRQ_ACK_ID)
      );  
  
endmodule
