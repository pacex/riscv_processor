// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
`include "fpga_defines.sv"

module soc_domain #(
    parameter CORE_TYPE            = 0,
    parameter USE_FPU              = 1,
    parameter USE_HWPE             = 1,
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_IN_WIDTH    = 64,
    parameter AXI_DATA_OUT_WIDTH   = 32,
    parameter AXI_ID_IN_WIDTH      = 4,
    parameter AXI_ID_INT_WIDTH     = 8,
    parameter AXI_ID_OUT_WIDTH     = 6,
    parameter AXI_USER_WIDTH       = 6,
    parameter AXI_STRB_IN_WIDTH    = AXI_DATA_IN_WIDTH/8,
    parameter AXI_STRB_OUT_WIDTH   = AXI_DATA_OUT_WIDTH/8,
    parameter BUFFER_WIDTH         = 8,
    parameter EVNT_WIDTH           = 8
)(

    input logic                              ref_clk_i,
    input logic                              slow_clk_i,
    input logic                              test_clk_i,

    input  logic                             rstn_glob_i,

    input  logic                             dft_test_mode_i,
    input  logic                             dft_cg_enable_i,

    input  logic                             mode_select_i,

    input  logic                             sel_fll_clk_i,

    input  logic [7:0]                       soc_jtag_reg_i,
    output logic [7:0]                       soc_jtag_reg_o,

    input logic                              boot_l2_i,

    input  logic                             jtag_tck_i,
    input  logic                             jtag_trst_ni,
    input  logic                             jtag_tms_i,
    input  logic                             jtag_td_i,
    input  logic                             jtag_axireg_tdi_i,
    output logic                             jtag_axireg_tdo_o,
    input  logic                             jtag_axireg_sel_i,
    input  logic                             jtag_shift_dr_i,
    input  logic                             jtag_update_dr_i,
    input  logic                             jtag_capture_dr_i,

    input  logic [31:0]                      gpio_in_i,
    output logic [31:0]                      gpio_out_o,
    output logic [31:0]                      gpio_dir_o,
    output logic [191:0]                     gpio_cfg_o,

    output logic [127:0]                     pad_mux_o,
    output logic [383:0]                     pad_cfg_o,

    output logic                             uart_tx_o,
    input  logic                             uart_rx_i,

    input  logic                             cam_clk_i,
    input  logic [7:0]                       cam_data_i,
    input  logic                             cam_hsync_i,
    input  logic                             cam_vsync_i,

    output logic [3:0]                       timer_ch0_o,
    output logic [3:0]                       timer_ch1_o,
    output logic [3:0]                       timer_ch2_o,
    output logic [3:0]                       timer_ch3_o,

    input  logic                             i2c0_scl_i,
    output logic                             i2c0_scl_o,
    output logic                             i2c0_scl_oe_o,
    input  logic                             i2c0_sda_i,
    output logic                             i2c0_sda_o,
    output logic                             i2c0_sda_oe_o,

    input  logic                             i2c1_scl_i,
    output logic                             i2c1_scl_o,
    output logic                             i2c1_scl_oe_o,
    input  logic                             i2c1_sda_i,
    output logic                             i2c1_sda_o,
    output logic                             i2c1_sda_oe_o,

    input  logic                             i2s_sd0_i,
    input  logic                             i2s_sd1_i,
    input  logic                             i2s_sck_i,
    input  logic                             i2s_ws_i,
    output logic                             i2s_sck0_o,
    output logic                             i2s_ws0_o,
    output logic [1:0]                       i2s_mode0_o,
    output logic                             i2s_sck1_o,
    output logic                             i2s_ws1_o,
    output logic [1:0]                       i2s_mode1_o,

    output logic                             spi_master0_clk_o,
    output logic                             spi_master0_csn0_o,
    output logic                             spi_master0_csn1_o,
    output logic [1:0]                       spi_master0_mode_o,
    output logic                             spi_master0_sdo0_o,
    output logic                             spi_master0_sdo1_o,
    output logic                             spi_master0_sdo2_o,
    output logic                             spi_master0_sdo3_o,
    input  logic                             spi_master0_sdi0_i,
    input  logic                             spi_master0_sdi1_i,
    input  logic                             spi_master0_sdi2_i,
    input  logic                             spi_master0_sdi3_i,

    output logic                             sdio_clk_o,
    output logic                             sdio_cmd_o,
    input  logic                             sdio_cmd_i,
    output logic                             sdio_cmd_oen_o,
    output logic                       [3:0] sdio_data_o,
    input  logic                       [3:0] sdio_data_i,
    output logic                       [3:0] sdio_data_oen_o

    ,
    // CLUSTER
    output logic                             cluster_clk_o,
    output logic                             cluster_rstn_o,
    input  logic                             cluster_busy_i,
    output logic                             cluster_irq_o,

    output logic                             cluster_rtc_o,
    output logic                             cluster_fetch_enable_o,
    output logic [63:0]                      cluster_boot_addr_o,
    output logic                             cluster_test_en_o,
    output logic                             cluster_pow_o,
    output logic                             cluster_byp_o,

    // EVENT BUS
    output logic [BUFFER_WIDTH-1:0]          cluster_events_wt_o,
    input  logic [BUFFER_WIDTH-1:0]          cluster_events_rp_i,
    output logic [EVNT_WIDTH-1:0]            cluster_events_da_o,

    output logic                             dma_pe_evt_ack_o,
    input  logic                             dma_pe_evt_valid_i,

    output logic                             dma_pe_irq_ack_o,
    input  logic                             dma_pe_irq_valid_i,

    output logic                             pf_evt_ack_o,
    input logic                              pf_evt_valid_i,

    // AXI4 SLAVE
    input  logic [7:0]                       data_slave_aw_writetoken_i,
    input  logic [AXI_ADDR_WIDTH-1:0]        data_slave_aw_addr_i,
    input  logic [2:0]                       data_slave_aw_prot_i,
    input  logic [3:0]                       data_slave_aw_region_i,
    input  logic [7:0]                       data_slave_aw_len_i,
    input  logic [2:0]                       data_slave_aw_size_i,
    input  logic [1:0]                       data_slave_aw_burst_i,
    input  logic                             data_slave_aw_lock_i,
    input  logic [3:0]                       data_slave_aw_cache_i,
    input  logic [3:0]                       data_slave_aw_qos_i,
    input  logic [AXI_ID_IN_WIDTH-1:0]       data_slave_aw_id_i,
    input  logic [AXI_USER_WIDTH-1:0]        data_slave_aw_user_i,
    output logic [7:0]                       data_slave_aw_readpointer_o,

    input  logic [7:0]                       data_slave_ar_writetoken_i,
    input  logic [AXI_ADDR_WIDTH-1:0]        data_slave_ar_addr_i,
    input  logic [2:0]                       data_slave_ar_prot_i,
    input  logic [3:0]                       data_slave_ar_region_i,
    input  logic [7:0]                       data_slave_ar_len_i,
    input  logic [2:0]                       data_slave_ar_size_i,
    input  logic [1:0]                       data_slave_ar_burst_i,
    input  logic                             data_slave_ar_lock_i,
    input  logic [3:0]                       data_slave_ar_cache_i,
    input  logic [3:0]                       data_slave_ar_qos_i,
    input  logic [AXI_ID_IN_WIDTH-1:0]       data_slave_ar_id_i,
    input  logic [AXI_USER_WIDTH-1:0]        data_slave_ar_user_i,
    output logic [7:0]                       data_slave_ar_readpointer_o,

    input  logic [7:0]                       data_slave_w_writetoken_i,
    input  logic [AXI_DATA_IN_WIDTH-1:0]     data_slave_w_data_i,
    input  logic [AXI_STRB_IN_WIDTH-1:0]     data_slave_w_strb_i,
    input  logic [AXI_USER_WIDTH-1:0]        data_slave_w_user_i,
    input  logic                             data_slave_w_last_i,
    output logic [7:0]                       data_slave_w_readpointer_o,

    output logic [7:0]                       data_slave_r_writetoken_o,
    output logic [AXI_DATA_IN_WIDTH-1:0]     data_slave_r_data_o,
    output logic [1:0]                       data_slave_r_resp_o,
    output logic                             data_slave_r_last_o,
    output logic [AXI_ID_IN_WIDTH-1:0]       data_slave_r_id_o,
    output logic [AXI_USER_WIDTH-1:0]        data_slave_r_user_o,
    input  logic [7:0]                       data_slave_r_readpointer_i,

    output logic [7:0]                       data_slave_b_writetoken_o,
    output logic [1:0]                       data_slave_b_resp_o,
    output logic [AXI_ID_IN_WIDTH-1:0]       data_slave_b_id_o,
    output logic [AXI_USER_WIDTH-1:0]        data_slave_b_user_o,
    input  logic [7:0]                       data_slave_b_readpointer_i,

    // AXI4 MASTER
    output logic [7:0]                       data_master_aw_writetoken_o,
    output logic [AXI_ADDR_WIDTH-1:0]        data_master_aw_addr_o,
    output logic [2:0]                       data_master_aw_prot_o,
    output logic [3:0]                       data_master_aw_region_o,
    output logic [7:0]                       data_master_aw_len_o,
    output logic [2:0]                       data_master_aw_size_o,
    output logic [1:0]                       data_master_aw_burst_o,
    output logic                             data_master_aw_lock_o,
    output logic [3:0]                       data_master_aw_cache_o,
    output logic [3:0]                       data_master_aw_qos_o,
    output logic [AXI_ID_OUT_WIDTH-1:0]      data_master_aw_id_o,
    output logic [AXI_USER_WIDTH-1:0]        data_master_aw_user_o,
    input  logic [7:0]                       data_master_aw_readpointer_i,

    output logic [7:0]                       data_master_ar_writetoken_o,
    output logic [AXI_ADDR_WIDTH-1:0]        data_master_ar_addr_o,
    output logic [2:0]                       data_master_ar_prot_o,
    output logic [3:0]                       data_master_ar_region_o,
    output logic [7:0]                       data_master_ar_len_o,
    output logic [2:0]                       data_master_ar_size_o,
    output logic [1:0]                       data_master_ar_burst_o,
    output logic                             data_master_ar_lock_o,
    output logic [3:0]                       data_master_ar_cache_o,
    output logic [3:0]                       data_master_ar_qos_o,
    output logic [AXI_ID_OUT_WIDTH-1:0]      data_master_ar_id_o,
    output logic [AXI_USER_WIDTH-1:0]        data_master_ar_user_o,
    input  logic [7:0]                       data_master_ar_readpointer_i,

    output logic [7:0]                       data_master_w_writetoken_o,
    output logic [AXI_DATA_OUT_WIDTH-1:0]    data_master_w_data_o,
    output logic [AXI_STRB_OUT_WIDTH-1:0]    data_master_w_strb_o,
    output logic [AXI_USER_WIDTH-1:0]        data_master_w_user_o,
    output logic                             data_master_w_last_o,
    input  logic [7:0]                       data_master_w_readpointer_i,

    input  logic [7:0]                       data_master_r_writetoken_i,
    input  logic [AXI_DATA_OUT_WIDTH-1:0]    data_master_r_data_i,
    input  logic [1:0]                       data_master_r_resp_i,
    input  logic                             data_master_r_last_i,
    input  logic [AXI_ID_OUT_WIDTH-1:0]      data_master_r_id_i,
    input  logic [AXI_USER_WIDTH-1:0]        data_master_r_user_i,
    output logic [7:0]                       data_master_r_readpointer_o,

    input  logic [7:0]                       data_master_b_writetoken_i,
    input  logic [1:0]                       data_master_b_resp_i,
    input  logic [AXI_ID_OUT_WIDTH-1:0]      data_master_b_id_i,
    input  logic [AXI_USER_WIDTH-1:0]        data_master_b_user_i,
    output logic [7:0]                      data_master_b_readpointer_o,
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
      output [3:0] led_o
    );

    pulp_soc
    #(
        .CORE_TYPE               ( CORE_TYPE          ),
        .USE_FPU                 ( USE_FPU            ),
        .USE_HWPE                ( USE_HWPE           ),
        .AXI_ADDR_WIDTH          ( AXI_ADDR_WIDTH     ),
        .AXI_DATA_IN_WIDTH       ( AXI_DATA_IN_WIDTH  ),
        .AXI_DATA_OUT_WIDTH      ( AXI_DATA_OUT_WIDTH ),
        .AXI_ID_IN_WIDTH         ( AXI_ID_IN_WIDTH    ),
        .AXI_ID_OUT_WIDTH        ( AXI_ID_OUT_WIDTH   ),
        .AXI_USER_WIDTH          ( AXI_USER_WIDTH     ),
        .EVNT_WIDTH              ( EVNT_WIDTH         ),
        .BUFFER_WIDTH            ( BUFFER_WIDTH       )       
   )
   pulp_soc_i
   (
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
   .led_o(led_o),
        .*
    );

endmodule
