// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
/*
	Parameter NB_BANKS bound to: 1 - type: integer 
Parameter NB_BANKS_PRI bound to: 2 - type: integer 
Parameter BANK_SIZE bound to: 29184 - type: integer 
Parameter MEM_ADDR_WIDTH bound to: 15 - type: integer 
Parameter MEM_ADDR_WIDTH_PRI bound to: 13 - type: integer 
Parameter BANK_SIZE_PRI1 bound to: 8192 - type: integer 
Parameter BANK_SIZE_PRI0_SRAM bound to: 6144 - type: integer 
Parameter BANK_SIZE_PRI0_SCM bound to: 2048 - type: integer 
Parameter BANK_SIZE_INTL_SRAM bound to: 28672 - type: integer 
Parameter BANK_SIZE_INTL_SCM bound to: 512 - type: integer 

*/
//`include "pulp_interfaces.sv"
`include "fpga_defines.sv"

module l2_ram_multi_bank #(
   parameter NB_BANKS                   = 4,
   parameter NB_BANKS_PRI               = 2,
   parameter BANK_SIZE                  = 29184,
   parameter MEM_ADDR_WIDTH             = 14,
   parameter MEM_ADDR_WIDTH_PRI         = 13
) (
   input logic             clk_i,
   input logic             rst_ni,
   input logic             init_ni,
   input logic             test_mode_i,
   UNICAD_MEM_BUS_32.Slave mem_slave[NB_BANKS-1:0],
   UNICAD_MEM_BUS_32.Slave mem_pri_slave[NB_BANKS_PRI-1:0],
   UNICAD_MEM_BUS_32.Slave scm_data_slave,
   UNICAD_MEM_BUS_32.Slave scm_instr_slave,
   output wire VGA_HS_O,
   output wire VGA_VS_O,
   output reg  [3:0] VGA_R,
   output reg [3:0] VGA_B,
   output reg [3:0] VGA_G,
   output l2_gnt_o,
   output reg l2_rvalid_o,
   input l2_req_i
);/*
localparam  NB_BANKS = 1; 
localparam  NB_BANKS_PRI = 2; 
localparam  BANK_SIZE = 29184; 
localparam  MEM_ADDR_WIDTH = 15; 
localparam  MEM_ADDR_WIDTH_PRI = 13; 
*/

   //Used in testbenches
   localparam  BANK_SIZE_PRI1       = 8192;
   localparam  BANK_SIZE_PRI0_SRAM  = 6144;
   localparam  BANK_SIZE_PRI0_SCM   = 2048;

   localparam  BANK_SIZE_INTL_SRAM  = 28672;
   localparam  BANK_SIZE_INTL_SCM   = 512;

`ifndef DISABLE_UNUSED_MEM
      localparam  DATA_R_WIDTH  = 8;
      localparam  DATA_W_WIDTH  = 32;
      localparam  PIXEL_ADDRESS_WIDTH   = 32;
      /*
      localparam  DATA_R_WIDTH  = 32;
      localparam  DATA_W_WIDTH  = 32;
      localparam  PIXEL_ADDRESS_WIDTH   = 16;
      */
      reg [DATA_R_WIDTH-1:0] pxl_color={DATA_R_WIDTH{1'b0}};
      wire [DATA_R_WIDTH-1:0] dataout;
      //reg [PIXEL_ADDRESS_WIDTH-1:0] pxl_adr={PIXEL_ADDRESS_WIDTH{1'b0}};
      wire [PIXEL_ADDRESS_WIDTH-1:0] pxl_adr;//={PIXEL_ADDRESS_WIDTH{1'b0}};
      
      genvar i,j;
      generate

         //INTERLEAVED
         for(i=0; i<NB_BANKS; i++)
         begin : CUTS
            /*
               This model the hybrid SRAM and SCM configuration
               that has been tape-out.
            */           
            
                  model_sdp_sram_65536x32 #(
                   .ADDR_W_WIDTH(MEM_ADDR_WIDTH),
                   .ADDR_R_WIDTH(PIXEL_ADDRESS_WIDTH),
                   .DATA_W_WIDTH(DATA_W_WIDTH),
                   .DATA_R_WIDTH(DATA_R_WIDTH),
                   .BE_WIDTH(4),
                   //.MEM_INIT_FILE("frame_buffer.mem"),
                   .MEM_INIT_FILE("none"),
                   //640px*480px *6bit/pxl=1843200
                   //640px*300px *8bit/px=1536000
                   .MEM_SIZE(1536000)
                  )
                  vga_ram (
                     .CLK   ( clk_i                                ),
		             .RSTN  ( rst_ni                               ),
                     .CEN   ( mem_slave[i].csn                     ),
                     .WEN   ( mem_slave[i].wen                     ),
                     .BEN   ( ~mem_slave[i].be                     ),
                     .D     ( mem_slave[i].wdata           ),
                     .AdrW  ( mem_slave[i].add[MEM_ADDR_WIDTH-1:0] ),
                     .AdrR  ( pxl_adr ),
                     .Q     ( dataout )                  
                  );
                 
         end
      endgenerate
      wire active_s;
      wire [9:0] x_s;
      wire [8:0] y_s;
     /* vga640x360 vga_controller(
      //.i_clk(clk_i),       
      .i_pix_stb(clk_i),   
      .i_rst(~rst_ni),       
      .o_hs(VGA_HS_O),        
      .o_vs(VGA_VS_O),        
      //.o_blanking(),  
      .o_active(active_s),    
      //.o_screenend(), 
      //.o_animate(),   
      .o_x(x_s),   
      .o_y(y_s),
      .pixl_adr_o(pxl_adr)
      );
      assign pxl_adr[31:18]=13'd0;
      localparam SCREEN_WIDTH = 640;
      //assign pxl_adr = y_s * SCREEN_WIDTH + x_s;
      */
     /* assign VGA_R = active_s==1'b1 ? {dataout[7:5],1'b0} : 4'd0;
      assign VGA_G = active_s==1'b1 ? {dataout[4:2],1'b0}  : 4'd0;
      assign VGA_B = active_s==1'b1 ? {dataout[1:0],2'b00} : 4'd0;     
      */
       /*  
      always @ (posedge clk_i)
          begin
              pxl_adr <= y_s * SCREEN_WIDTH + x_s;
          end     
     
      
              if (active_s)
                  //VGA_B <= {dataout[7:6],2'b00};
                  //VGA_G <= {dataout[5:3],1'b0};
                  //VGA_R <= {dataout[2:0],1'b0};
                  pxl_color <= dataout;
              else
                 // VGA_B <= {4'b0000};
                 //VGA_G <= {4'b0000};
                  //VGA_R <= {4'b0000};
                  pxl_color <= 8'b00000000;   
                                 
              VGA_R <= {pxl_color[7:5],1'b0};
              VGA_G <= {pxl_color[4:2],1'b0};
              VGA_B <= {pxl_color[1:0],2'b00};                            
          end*/
      
      vga_digilent vga_controller(            
                .pxl_clk(clk_i),
                .PXL_ADR_O(pxl_adr),
                .PIXEL_I(dataout),
                .VGA_HS_O(VGA_HS_O),
                .VGA_VS_O(VGA_VS_O),
                .VGA_R(VGA_R),
                .VGA_B(VGA_B),
                .VGA_G(VGA_G)
                );
                
      /*
      ctrl_vga vga_controller(
          .clk25MHz(clk_i),   
          .res(~rst_ni),
          .enable(1'b1),                  
          .data_in(dataout),
          .ready(1'b1)       ,              
          .vga_red(VGA_R) ,
          .vga_grn(VGA_G),
          .vga_blu(VGA_B),                  
          .hsync(VGA_HS_O),   
          .vsync(VGA_VS_O),                               
          .next_adr(pxl_adr)                  
         // .valid(1'b1)
      );*/
`endif
      /*
      As the PRI Banks are divided in SCM and SRAM,
      a demux from the interconnect is needed.
      The 8 KWord (32 KByte) Bank is
      divided in 4Kword + 2Kword + 2Kword (16 Kbyte + 8 Kbyte + 8 Kbyte)
      The first 2 Kword (address 0 to 2047) are for the SCM
      */

      // PRIVATE BANKS
      /*
         This model the hybrid SRAM and SCM configuration
         that has been tape-out.
      */
      //imitate ddr latency until one is integrated into the soc
      localparam mem_latency = 10;
      //reg [31:0] delay [mem_latency - 1:0];
      generic_memory #(
         .ADDR_WIDTH ( MEM_ADDR_WIDTH_PRI+2  ),
         .DATA_WIDTH ( 32                  ),
        `ifndef XILINX_SIMULATOR
	  .MEM_INIT_FILE ( "pri1.mem" ),
        `else
          .MEM_INIT_FILE ( "system_instr.mem"  ),
        `endif
         .LATENCY(mem_latency+1)
      ) bank_sram_pri1_i (
         .CLK   ( clk_i                      ),
         .INITN ( 1'b1                       ),
         .CEN   ( mem_pri_slave[1].csn       ),
         .BEN   ( ~mem_pri_slave[1].be       ),
         .WEN   ( mem_pri_slave[1].wen       ),         
         .A     ( {mem_pri_slave[1].add[MEM_ADDR_WIDTH_PRI-1:0],2'b00} ),
         .D     ( mem_pri_slave[1].wdata     ),
         .Q     ( mem_pri_slave[1].rdata    )
      );
      
      //assign l2_gnt_o=~mem_pri_slave[1].csn;
      reg [mem_latency - 1 : 0] gnt_delayed = {mem_latency{1'b0}};
      assign l2_gnt_o = gnt_delayed[mem_latency-1];
      assign l2_rvalid_o = gnt_delayed[mem_latency-1];
      /*always @(posedge clk_i, negedge rst_ni) begin
        if(rst_ni==1'b0) begin
          l2_rvalid_o<=1'b0;
          end
        else
        begin
          l2_rvalid_o<=gnt_delayed[mem_latency-1];          
        end
      end*/
      
  //reg[3:0] bits;
      
      always @ (posedge clk_i, negedge rst_ni)
      begin
        if(rst_ni==1'b0)
          gnt_delayed <= {mem_latency{1'b0}};
        else
          gnt_delayed <= {gnt_delayed[mem_latency - 2:0],  ~mem_pri_slave[1].csn & ~|gnt_delayed};
      end
      //assign l2_rvalid_o=l2_gnt_o;

      model_6144x32_2048x32scm  #(
        .MEM_INIT_FILE_SCM0 ("none"),
        .MEM_INIT_FILE_CUT0 ("./pri0_i-cut_0.mem" ),
        .MEM_INIT_FILE_CUT1 ("./pri0_i-cut_1.mem" )
      ) bank_sram24k_scm8k_pri0_i (
         .CLK      ( clk_i                      ),
         .RSTN     ( rst_ni                     ),
         .CEN      ( mem_pri_slave[0].csn       ),
         .CEN_scm0 ( scm_data_slave.csn         ),
         .CEN_scm1 ( scm_instr_slave.csn        ),

         .BEN      ( ~mem_pri_slave[0].be       ),
         .BEN_scm0 ( ~scm_data_slave.be         ),
         .WEN      ( mem_pri_slave[0].wen       ),
         .WEN_scm0 ( scm_data_slave.wen         ),
         .WEN_scm1 ( scm_instr_slave.wen        ),

         .A        ( mem_pri_slave[0].add[MEM_ADDR_WIDTH_PRI-1:0] ),
         .A_scm0   ( scm_data_slave.add[MEM_ADDR_WIDTH_PRI-1:2]   ),
         .A_scm1   ( scm_instr_slave.add[MEM_ADDR_WIDTH_PRI-1:2]  ),

         .D        ( mem_pri_slave[0].wdata     ),
         .D_scm0   ( scm_data_slave.wdata       ),

         .Q        ( mem_pri_slave[0].rdata     ),
         .Q_scm0   ( scm_data_slave.rdata       ),
         .Q_scm1   ( scm_instr_slave.rdata      )
      );

endmodule // l2_ram_multi_bank
