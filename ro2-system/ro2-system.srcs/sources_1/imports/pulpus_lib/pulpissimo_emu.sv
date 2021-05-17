// Copyright 2018 ETH Zurich and University of Bologna.
 //  pullup sda1_pullup_i (w_i2c1_sda);
 //  pullup scl1_pullup_i (w_i2c1_scl);

// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
 */
   // UART baud rate in bps


module pulpissimo_emu
(
  inout  wire		pad_spim_sdio0,
  inout  wire		pad_spim_sdio1,
  inout  wire		pad_spim_sdio2,
  inout  wire		pad_spim_sdio3,
  inout  wire		pad_spim_csn0,
  inout  wire		pad_spim_sck,

  input logic pad_xtal_in,
  inout  wire	      	pad_uart_tx,
  inout  wire	      	pad_uart_rx,

  inout  wire	      	pad_i2c0_sda, 
  inout  wire	      	pad_i2c0_scl,

  inout  wire	      	pad_reset_n,
/*
  inout  wire        pad_jtag_tck,
  inout  wire        pad_jtag_tdi,
  inout  wire        pad_jtag_tdo,
  inout  wire        pad_jtag_tms,
  inout  wire        pad_jtag_trst,
*/
  //input  wire   [3:1]	SW,
  output wire	[3:0]	LED,
  input wire resn,
  output wire VGA_HS_O,
  output wire VGA_VS_O,
  output wire [3:0] VGA_R,
  output wire [3:0] VGA_B,
  output wire [3:0] VGA_G,
  
  /*
  CORE
  */
   output  logic        c_clk_i,
   output logic        c_rst_ni,
 
   output  logic        c_clock_en_i,    // enable clock, otherwise it is gated
   output  logic        c_test_en_i,     // enable all clock gates for testing
 
   // Core ID, Cluster ID and boot address are considered more or less static
   output  logic [ 3:0] c_core_id_i,
   output  logic [ 5:0] c_cluster_id_i,
   output  logic [31:0] c_boot_addr_i,
 
   // Instruction memory interface
   input logic                         c_instr_req_o,
   output  logic                         c_instr_gnt_i,
   output  logic                         c_instr_rvalid_i,
   input logic                  [31:0] c_instr_addr_o,
   output  logic                  [31:0] c_instr_rdata_i,
 
   // Data memory interface
   input logic        c_data_req_o,
   output  logic        c_data_gnt_i,
   output  logic        c_data_rvalid_i,
   input logic        c_data_we_o,
   input logic [3:0]  c_data_be_o,
   input logic [31:0] c_data_addr_o,
   input logic [31:0] c_data_wdata_o,
   output  logic [31:0] c_data_rdata_i,
   output  logic        c_data_err_i,
 
   // Interrupt inputs
   output  logic        c_irq_i,                 // level sensitive IR lines
   output  logic [4:0]  c_irq_id_i,
   input logic        c_irq_ack_o,             // irq ack
   input logic [4:0]  c_irq_id_o,
 
   // Debug Interface
   output  logic        c_debug_req_i,
   input logic        c_debug_gnt_o,
   input logic        c_debug_rvalid_o,
   output  logic [14:0] c_debug_addr_i,
   output  logic        c_debug_we_i,
   output  logic [31:0] c_debug_wdata_i,
   input logic [31:0] c_debug_rdata_o,
   input logic        c_debug_halted_o,
   output  logic        c_debug_halt_i,
   output  logic        c_debug_resume_i,
 
   // CPU Control Signals
   output  logic        c_fetch_enable_i,
 
   output  logic c_ext_perf_counters_i,
   
   input [3:0] BTN,
   input [3:0] SW
);
/*parameter  BAUDRATE = 625000;

  //UART receiver 
 
uart_tb_rx #(
 .BAUD_RATE ( BAUDRATE   ),
 .PARITY_EN ( 0          )
) i_rx_mod (
 .rx        ( pad_uart_tx      ),
 .rx_en     ( 1'b1 ),
 .word_done (               )
);*/
   //assign LED[3:1]=SW[3:1];
   //assign LED[0]=resn;
   wire [3:0] led_s;
   assign LED=led_s;
   
   // Choose your core: 0 for RISCY, 1 for ZERORISCY
   parameter CORE_TYPE            = 1;
   // if RISCY is instantiated (CORE_TYPE == 0), RISCY_FPU enables the FPU
   parameter RISCY_FPU            = 0;

   // for PULPissimo, 1 core
   parameter NB_CORES = 1;


   logic jtag_enable;
   /* system wires */
   // the w_/s_ prefixes are used to mean wire/tri-type and logic-type (respectively)

   wire w_spi_master_sdio0;
   wire                   w_spi_master_sdio1;
   wire                   w_spi_master_sdio2;
   wire                   w_spi_master_sdio3;
   wire                   w_spi_master_csn0;
   wire                   w_spi_master_csn1;
   wire                   w_spi_master_sck;

   wire                   w_i2c1_scl;
   wire                   w_i2c1_sda;

   wire                  w_cam_pclk;
   wire [7:0]            w_cam_data;
   wire                  w_cam_hsync;
   wire                  w_cam_vsync;

   // I2S 0
   wire                  w_i2s0_sck;
   wire                  w_i2s0_ws;
   wire                  w_i2s0_sdi;
   // I2S 1
   wire                  w_i2s1_sdi;

   wire                  w_i2s_sck;
   wire                  w_i2s_ws;
   wire           [7:0]  w_i2s_data;

   wire                  w_trstn;
   wire                  w_tck;
   wire                  w_tdi;
   wire                  w_tms;
   wire                  w_tdo;

   wire w_bootsel;

   assign w_bootsel = 1'b0;
/*
   input [3:0] BTN,
input [3:0] SW
*/
assign w_cam_data={SW, BTN};

   /* PULPissimo chip */
   pulpissimo #(
      .CORE_TYPE ( CORE_TYPE ),
      .USE_FPU   ( RISCY_FPU )
   )
   pulpissimo_i (
      /*  .pad_spim_sdio0     (               w_spi_master_sdio0),
        .pad_spim_sdio1     (           w_spi_master_sdio1),
        .pad_spim_sdio2     (             w_spi_master_sdio2),
        .pad_spim_sdio3     (         w_spi_master_sdio3),
        .pad_spim_csn0      (      w_spi_master_csn0),
        .pad_spim_sck       ( w_spi_master_sck),                
*/
      .pad_spim_sdio0     ( pad_spim_sdio0     ),
      .pad_spim_sdio1     ( pad_spim_sdio1	),
      .pad_spim_sdio2     ( pad_spim_sdio2	),
      .pad_spim_sdio3     ( pad_spim_sdio3	),
      .pad_spim_csn0      ( pad_spim_csn0	),

      .pad_spim_csn1      (      w_spi_master_csn1),
      .pad_spim_sck       ( pad_spim_sck	),


      .pad_uart_rx        ( pad_uart_rx	       ),
      .pad_uart_tx        ( pad_uart_tx	       ),

      .pad_cam_pclk       ( w_cam_pclk         ),
      .pad_cam_hsync      ( w_cam_hsync        ),
      .pad_cam_data0      ( w_cam_data[0]      ),
      .pad_cam_data1      ( w_cam_data[1]      ),
      .pad_cam_data2      ( w_cam_data[2]      ),
      .pad_cam_data3      ( w_cam_data[3]      ),
      .pad_cam_data4      ( w_cam_data[4]      ),
      .pad_cam_data5      ( w_cam_data[5]      ),
      .pad_cam_data6      ( w_cam_data[6]      ),
      .pad_cam_data7      ( w_cam_data[7]      ),
      .pad_cam_vsync      ( w_cam_vsync        ),

      .pad_i2c0_sda       ( pad_i2c0_sda	),
      .pad_i2c0_scl       ( pad_i2c0_scl	),

      .pad_i2s0_sck       ( w_i2s0_sck         ),
      .pad_i2s0_ws        ( w_i2s0_ws          ),
      .pad_i2s0_sdi       ( w_i2s0_sdi         ),
      .pad_i2s1_sdi       ( w_i2s1_sdi         ),

      .pad_reset_n        ( pad_reset_n	       ),
      .pad_bootsel        ( w_bootsel          ),
/*
      .pad_jtag_tck       ( pad_jtag_tck	),
      .pad_jtag_tdi       ( pad_jtag_tdi       ),
      .pad_jtag_tdo       ( pad_jtag_tdo	),
      .pad_jtag_tms       ( pad_jtag_tms	),
      .pad_jtag_trst      ( pad_jtag_trst	),
*/
      .pad_xtal_in        ( pad_xtal_in		),
	.cluster_jtag_tck_i(),
	.cluster_jtag_tdi_i(),
	.cluster_jtag_tdo_o(),
	.cluster_jtag_tms_i(),
	.cluster_jtag_trst_ni(),
	.resetn(resn),
	.VGA_HS_O(VGA_HS_O),
    .VGA_VS_O(VGA_VS_O),
    .VGA_R(VGA_R),
    .VGA_B(VGA_B),
    .VGA_G(VGA_G),
    .c_clk_i(c_clk_i),                                                                  
    .c_rst_ni(c_rst_ni),                                                                  
    .c_clock_en_i(c_clock_en_i),       
    .c_test_en_i(c_test_en_i),
    .c_core_id_i(c_core_id_i),                                                              
    .c_cluster_id_i(c_cluster_id_i),                                                           
    .c_boot_addr_i(c_boot_addr_i),
    .c_instr_req_o(c_instr_req_o),                                             
    .c_instr_gnt_i(c_instr_gnt_i),                                           
    .c_instr_rvalid_i(c_instr_rvalid_i),                                        
    .c_instr_addr_o(c_instr_addr_o),                                            
    .c_instr_rdata_i(c_instr_rdata_i),  
    .c_data_req_o(c_data_req_o),                                                               
    .c_data_gnt_i(c_data_gnt_i),                                                             
    .c_data_rvalid_i(c_data_rvalid_i),                                                          
    .c_data_we_o(c_data_we_o),                                                                
    .c_data_be_o(c_data_be_o),                                                                
    .c_data_addr_o(c_data_addr_o),                                                              
    .c_data_wdata_o(c_data_wdata_o),                                                             
    .c_data_rdata_i(c_data_rdata_i),                                                           
    .c_data_err_i(c_data_err_i),       
    .c_irq_i(c_irq_i),                  
    .c_irq_id_i(c_irq_id_i),                                                               
    .c_irq_ack_o(c_irq_ack_o),                                    
    .c_irq_id_o(c_irq_id_o),                  
    .c_debug_req_i(c_debug_req_i),                                                            
    .c_debug_gnt_o(c_debug_gnt_o),                                                              
    .c_debug_rvalid_o(c_debug_rvalid_o),                                                           
    .c_debug_addr_i(c_debug_addr_i),                                                           
    .c_debug_we_i(c_debug_we_i),                                                             
    .c_debug_wdata_i(c_debug_wdata_i),                                                          
    .c_debug_rdata_o(c_debug_rdata_o),                                                            
    .c_debug_halted_o(c_debug_halted_o),                                                           
    .c_debug_halt_i(c_debug_halt_i),                                                           
    .c_debug_resume_i(c_debug_resume_i),            
    .c_fetch_enable_i(c_fetch_enable_i),
    .c_ext_perf_counters_i(c_ext_perf_counters_i),
    .led_o(led_s)
   );
   
   /*
   
       zeroriscy_core #(
       .N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ),
       .RV32E               ( ZERORISCY_RV32E     ),
       .RV32M               ( ZERORISCY_RV32M     )
   ) lFC_CORE (
       .clk_i                 ( clk_i             ),
       .rst_ni                ( rst_ni            ),
       .clock_en_i            ( core_clock_en     ),
       .test_en_i             ( test_en_i         ),
       .boot_addr_i           ( boot_addr_i       ),
       .core_id_i             ( core_id_int       ),
       .cluster_id_i          ( cluster_id_int    ),

       // Instruction Memory Interface:  Interface to Instruction Logaritmic interconnect: Req->grant handshake
       .instr_addr_o          ( core_instr_addr   ),
       .instr_req_o           ( core_instr_req    ),
       .instr_rdata_i         ( core_instr_rdata  ),
       .instr_gnt_i           ( core_instr_gnt    ),
       .instr_rvalid_i        ( core_instr_rvalid ),

       // Data memory interface:
       .data_addr_o           ( core_data_addr    ),
       .data_req_o            ( core_data_req     ),
       .data_be_o             ( core_data_be      ),
       .data_rdata_i          ( core_data_rdata   ),
       .data_we_o             ( core_data_we      ),
       .data_gnt_i            ( core_data_gnt     ),
       .data_wdata_o          ( core_data_wdata   ),
       .data_rvalid_i         ( core_data_rvalid  ),
       .data_err_i            ( core_data_err     ),

       .irq_i                 ( core_irq_req      ),
       .irq_id_i              ( core_irq_id       ),
       .irq_ack_o             ( core_irq_ack      ),
       .irq_id_o              ( core_irq_ack_id   ),

       .debug_req_i           ( debug_req         ),
       .debug_gnt_o           ( debug_gnt         ),
       .debug_rvalid_o        ( debug_rvalid      ),
       .debug_addr_i          ( debug_addr        ),
       .debug_we_i            ( debug_we          ),
       .debug_wdata_i         ( debug_wdata       ),
       .debug_rdata_o         ( debug_rdata       ),
       .debug_halted_o        (                   ),
       .debug_halt_i          ( 1'b0              ),
       .debug_resume_i        ( 1'b0              ),
       .fetch_enable_i        ( fetch_en_int      ),
       .ext_perf_counters_i   ( perf_counters_int )
   );
   
   */

endmodule // pulpissimo_emu
