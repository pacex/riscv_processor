// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


module pad_frame
    (

        input logic [47:0][5:0] pad_cfg_i        ,

        // REF CLOCK
        output logic            ref_clk_o        ,
        // slow clock required for events
        output logic            slow_clk_o        ,

        // RESET SIGNALS
        output logic            rstn_o           ,
        input  logic            rstn_i           ,

        // JTAG SIGNALS
        output logic            jtag_tck_o       ,
        output logic            jtag_tdi_o       ,
        input  logic            jtag_tdo_i       ,
        output logic            jtag_tms_o       ,
        output logic            jtag_trst_o      ,

        input logic             oe_sdio_clk_i   ,
        input logic             oe_sdio_cmd_i    ,
        input logic             oe_sdio_data0_i   ,
        input logic             oe_sdio_data1_i   ,
        input logic             oe_sdio_data2_i   ,
        input logic             oe_sdio_data3_i   ,
        input logic             oe_spim_sdio0_i  ,
        input logic             oe_spim_sdio1_i  ,
        input logic             oe_spim_sdio2_i  ,
        input logic             oe_spim_sdio3_i  ,
        input logic             oe_spim_csn0_i   ,
        input logic             oe_spim_csn1_i   ,
        input logic             oe_spim_sck_i    ,
        input logic             oe_i2s0_sck_i    ,
        input logic             oe_i2s0_ws_i     ,
        input logic             oe_i2s0_sdi_i    ,
        input logic             oe_i2s1_sdi_i    ,
        input logic             oe_cam_pclk_i    ,
        input logic             oe_cam_hsync_i   ,
        input logic             oe_cam_data0_i   ,
        input logic             oe_cam_data1_i   ,
        input logic             oe_cam_data2_i   ,
        input logic             oe_cam_data3_i   ,
        input logic             oe_cam_data4_i   ,
        input logic             oe_cam_data5_i   ,
        input logic             oe_cam_data6_i   ,
        input logic             oe_cam_data7_i   ,
        input logic             oe_cam_vsync_i   ,
        input logic             oe_i2c0_sda_i    ,
        input logic             oe_i2c0_scl_i    ,
        input logic             oe_uart_rx_i     ,
        input logic             oe_uart_tx_i     ,

        // INPUTS SIGNALS TO THE PADS
        input logic             out_sdio_clk_i  ,
        input logic             out_sdio_cmd_i   ,
        input logic             out_sdio_data0_i  ,
        input logic             out_sdio_data1_i  ,
        input logic             out_sdio_data2_i  ,
        input logic             out_sdio_data3_i  ,
        input logic             out_spim_sdio0_i ,
        input logic             out_spim_sdio1_i ,
        input logic             out_spim_sdio2_i ,
        input logic             out_spim_sdio3_i ,
        input logic             out_spim_csn0_i  ,
        input logic             out_spim_csn1_i  ,
        input logic             out_spim_sck_i   ,
        input logic             out_i2s0_sck_i   ,
        input logic             out_i2s0_ws_i    ,
        input logic             out_i2s0_sdi_i   ,
        input logic             out_i2s1_sdi_i   ,
        input logic             out_cam_pclk_i   ,
        input logic             out_cam_hsync_i  ,
        input logic             out_cam_data0_i  ,
        input logic             out_cam_data1_i  ,
        input logic             out_cam_data2_i  ,
        input logic             out_cam_data3_i  ,
        input logic             out_cam_data4_i  ,
        input logic             out_cam_data5_i  ,
        input logic             out_cam_data6_i  ,
        input logic             out_cam_data7_i  ,
        input logic             out_cam_vsync_i  ,
        input logic             out_i2c0_sda_i   ,
        input logic             out_i2c0_scl_i   ,
        input logic             out_uart_rx_i    ,
        input logic             out_uart_tx_i    ,

        // OUTPUT SIGNALS FROM THE PADS
        output logic            in_sdio_clk_o   ,
        output logic            in_sdio_cmd_o    ,
        output logic            in_sdio_data0_o   ,
        output logic            in_sdio_data1_o   ,
        output logic            in_sdio_data2_o   ,
        output logic            in_sdio_data3_o   ,
        output logic            in_spim_sdio0_o  ,
        output logic            in_spim_sdio1_o  ,
        output logic            in_spim_sdio2_o  ,
        output logic            in_spim_sdio3_o  ,
        output logic            in_spim_csn0_o   ,
        output logic            in_spim_csn1_o   ,
        output logic            in_spim_sck_o    ,
        output logic            in_i2s0_sck_o    ,
        output logic            in_i2s0_ws_o     ,
        output logic            in_i2s0_sdi_o    ,
        output logic            in_i2s1_sdi_o    ,
        output logic            in_cam_pclk_o    ,
        output logic            in_cam_hsync_o   ,
        output logic            in_cam_data0_o   ,
        output logic            in_cam_data1_o   ,
        output logic            in_cam_data2_o   ,
        output logic            in_cam_data3_o   ,
        output logic            in_cam_data4_o   ,
        output logic            in_cam_data5_o   ,
        output logic            in_cam_data6_o   ,
        output logic            in_cam_data7_o   ,
        output logic            in_cam_vsync_o   ,
        output logic            in_i2c0_sda_o    ,
        output logic            in_i2c0_scl_o    ,
        output logic            in_uart_rx_o     ,
        output logic            in_uart_tx_o     ,

        // EXT CHIP TP PADS
        inout wire              pad_sdio_clk    ,
        inout wire              pad_sdio_cmd     ,
        inout wire              pad_sdio_data0    ,
        inout wire              pad_sdio_data1    ,
        inout wire              pad_sdio_data2    ,
        inout wire              pad_sdio_data3    ,
        inout wire              pad_spim_sdio0   ,
        inout wire              pad_spim_sdio1   ,
        inout wire              pad_spim_sdio2   ,
        inout wire              pad_spim_sdio3   ,
        inout wire              pad_spim_csn0    ,
        inout wire              pad_spim_csn1    ,
        inout wire              pad_spim_sck     ,
        inout wire              pad_i2s0_sck     ,
        inout wire              pad_i2s0_ws      ,
        inout wire              pad_i2s0_sdi     ,
        inout wire              pad_i2s1_sdi     ,
        inout wire              pad_cam_pclk     ,
        inout wire              pad_cam_hsync    ,
        inout wire              pad_cam_data0    ,
        inout wire              pad_cam_data1    ,
        inout wire              pad_cam_data2    ,
        inout wire              pad_cam_data3    ,
        inout wire              pad_cam_data4    ,
        inout wire              pad_cam_data5    ,
        inout wire              pad_cam_data6    ,
        inout wire              pad_cam_data7    ,
        inout wire              pad_cam_vsync    ,
        inout wire              pad_i2c0_sda     ,
        inout wire              pad_i2c0_scl     ,
        inout wire              pad_uart_rx      ,
        inout wire              pad_uart_tx      ,

        inout wire              pad_reset_n      ,
        inout wire              pad_bootsel      ,
        inout wire              pad_jtag_tck     ,
        inout wire              pad_jtag_tdi     ,
        inout wire              pad_jtag_tdo     ,
        inout wire              pad_jtag_tms     ,
        inout wire              pad_jtag_trst    ,
        input logic             pad_xtal_in


    );
    wire resetn;
/*
    pad_functional_pd padinst_sdio_data0 (.OEN(~oe_sdio_data0_i ), .I(out_sdio_data0_i ), .O(in_sdio_data0_o ), .PAD(pad_sdio_data0 ), .PEN(~pad_cfg_i[22][0]) );
    pad_functional_pd padinst_sdio_data1 (.OEN(~oe_sdio_data1_i ), .I(out_sdio_data1_i ), .O(in_sdio_data1_o ), .PAD(pad_sdio_data1 ), .PEN(~pad_cfg_i[23][0]) );
    pad_functional_pd padinst_sdio_data2 (.OEN(~oe_sdio_data2_i ), .I(out_sdio_data2_i ), .O(in_sdio_data2_o ), .PAD(pad_sdio_data2 ), .PEN(~pad_cfg_i[24][0]) );
    pad_functional_pd padinst_sdio_data3 (.OEN(~oe_sdio_data3_i ), .I(out_sdio_data3_i ), .O(in_sdio_data3_o ), .PAD(pad_sdio_data3 ), .PEN(~pad_cfg_i[25][0]) );
    pad_functional_pd padinst_sdio_clk   (.OEN(~oe_sdio_clk_i  ), .I(out_sdio_clk_i  ), .O(in_sdio_clk_o  ), .PAD(pad_sdio_clk  ), .PEN(~pad_cfg_i[20][0]) );
    pad_functional_pd padinst_sdio_cmd   (.OEN(~oe_sdio_cmd_i  ), .I(out_sdio_cmd_i  ), .O(in_sdio_cmd_o  ), .PAD(pad_sdio_cmd  ), .PEN(~pad_cfg_i[21][0]) );
*/

/*
    pad_functional_pd padinst_spim_sck   (.OEN(~oe_spim_sck_i  ), .I(out_spim_sck_i  ), .O(in_spim_sck_o  ), .PAD(pad_spim_sck  ), .PEN(~pad_cfg_i[6][0] ) );
    pad_functional_pd padinst_spim_sdio0 (.OEN(~oe_spim_sdio0_i), .I(out_spim_sdio0_i), .O(in_spim_sdio0_o), .PAD(pad_spim_sdio0), .PEN(~pad_cfg_i[0][0] ) );
    pad_functional_pd padinst_spim_sdio1 (.OEN(~oe_spim_sdio1_i), .I(out_spim_sdio1_i), .O(in_spim_sdio1_o), .PAD(pad_spim_sdio1), .PEN(~pad_cfg_i[1][0] ) );
    pad_functional_pd padinst_spim_sdio2 (.OEN(~oe_spim_sdio2_i), .I(out_spim_sdio2_i), .O(in_spim_sdio2_o), .PAD(pad_spim_sdio2), .PEN(~pad_cfg_i[2][0] ) );
    pad_functional_pd padinst_spim_sdio3 (.OEN(~oe_spim_sdio3_i), .I(out_spim_sdio3_i), .O(in_spim_sdio3_o), .PAD(pad_spim_sdio3), .PEN(~pad_cfg_i[3][0] ) );
 //   pad_functional_pd padinst_spim_csn1  (.OEN(~oe_spim_csn1_i ), .I(out_spim_csn1_i ), .O(in_spim_csn1_o ), .PAD(pad_spim_csn1 ), .PEN(~pad_cfg_i[5][0] ) );
    pad_functional_pd padinst_spim_csn0  (.OEN(~oe_spim_csn0_i ), .I(out_spim_csn0_i ), .O(in_spim_csn0_o ), .PAD(pad_spim_csn0 ), .PEN(~pad_cfg_i[4][0] ) );
*/

/*
    pad_functional_pd padinst_i2s1_sdi   (.OEN(~oe_i2s1_sdi_i  ), .I(out_i2s1_sdi_i  ), .O(in_i2s1_sdi_o  ), .PAD(pad_i2s1_sdi  ), .PEN(~pad_cfg_i[38][0]) );
    pad_functional_pd padinst_i2s0_ws    (.OEN(~oe_i2s0_ws_i   ), .I(out_i2s0_ws_i   ), .O(in_i2s0_ws_o   ), .PAD(pad_i2s0_ws   ), .PEN(~pad_cfg_i[36][0]) );
    pad_functional_pd padinst_i2s0_sdi   (.OEN(~oe_i2s0_sdi_i  ), .I(out_i2s0_sdi_i  ), .O(in_i2s0_sdi_o  ), .PAD(pad_i2s0_sdi  ), .PEN(~pad_cfg_i[37][0]) );
    pad_functional_pd padinst_i2s0_sck   (.OEN(~oe_i2s0_sck_i  ), .I(out_i2s0_sck_i  ), .O(in_i2s0_sck_o  ), .PAD(pad_i2s0_sck  ), .PEN(~pad_cfg_i[35][0]) );
*/
/*    pad_functional_pu padinst_jtag_tck   (.OEN(1'b1            ), .I(                ), .O(jtag_tck_o     ), .PAD(pad_jtag_tck  ), .PEN(1'b1             ) );
    pad_functional_pu padinst_jtag_tms   (.OEN(1'b1            ), .I(                ), .O(jtag_tms_o     ), .PAD(pad_jtag_tms  ), .PEN(1'b1             ) );
    pad_functional_pu padinst_jtag_tdi   (.OEN(1'b1            ), .I(                ), .O(jtag_tdi_o     ), .PAD(pad_jtag_tdi  ), .PEN(1'b1             ) );
    pad_functional_pu padinst_jtag_trstn (.OEN(1'b1            ), .I(                ), .O(jtag_trst_o    ), .PAD(pad_jtag_trst ), .PEN(1'b1             ) );
    pad_functional_pd padinst_jtag_tdo   (.OEN(1'b0            ), .I(jtag_tdo_i      ), .O(               ), .PAD(pad_jtag_tdo  ), .PEN(1'b1             ) );
*/
/*
    pad_functional_pd padinst_cam_pclk   (.OEN(~oe_cam_pclk_i  ), .I(out_cam_pclk_i  ), .O(in_cam_pclk_o  ), .PAD(pad_cam_pclk  ), .PEN(~pad_cfg_i[9][0] ) );
    pad_functional_pd padinst_cam_hsync  (.OEN(~oe_cam_hsync_i ), .I(out_cam_hsync_i ), .O(in_cam_hsync_o ), .PAD(pad_cam_hsync ), .PEN(~pad_cfg_i[10][0]) );
    pad_functional_pd padinst_cam_data0  (.OEN(~oe_cam_data0_i ), .I(out_cam_data0_i ), .O(in_cam_data0_o ), .PAD(pad_cam_data0 ), .PEN(~pad_cfg_i[11][0]) );
    pad_functional_pd padinst_cam_data1  (.OEN(~oe_cam_data1_i ), .I(out_cam_data1_i ), .O(in_cam_data1_o ), .PAD(pad_cam_data1 ), .PEN(~pad_cfg_i[12][0]) );
    pad_functional_pd padinst_cam_data2  (.OEN(~oe_cam_data2_i ), .I(out_cam_data2_i ), .O(in_cam_data2_o ), .PAD(pad_cam_data2 ), .PEN(~pad_cfg_i[13][0]) );
    pad_functional_pd padinst_cam_data3  (.OEN(~oe_cam_data3_i ), .I(out_cam_data3_i ), .O(in_cam_data3_o ), .PAD(pad_cam_data3 ), .PEN(~pad_cfg_i[14][0]) );
    pad_functional_pd padinst_cam_data4  (.OEN(~oe_cam_data4_i ), .I(out_cam_data4_i ), .O(in_cam_data4_o ), .PAD(pad_cam_data4 ), .PEN(~pad_cfg_i[15][0]) );
    pad_functional_pd padinst_cam_data5  (.OEN(~oe_cam_data5_i ), .I(out_cam_data5_i ), .O(in_cam_data5_o ), .PAD(pad_cam_data5 ), .PEN(~pad_cfg_i[16][0]) );
    pad_functional_pd padinst_cam_data6  (.OEN(~oe_cam_data6_i ), .I(out_cam_data6_i ), .O(in_cam_data6_o ), .PAD(pad_cam_data6 ), .PEN(~pad_cfg_i[17][0]) );
    pad_functional_pd padinst_cam_data7  (.OEN(~oe_cam_data7_i ), .I(out_cam_data7_i ), .O(in_cam_data7_o ), .PAD(pad_cam_data7 ), .PEN(~pad_cfg_i[18][0]) );
    pad_functional_pd padinst_cam_vsync  (.OEN(~oe_cam_vsync_i ), .I(out_cam_vsync_i ), .O(in_cam_vsync_o ), .PAD(pad_cam_vsync ), .PEN(~pad_cfg_i[19][0]) );
*/
    //pad_functional_pu padinst_uart_rx    (.OEN(~oe_uart_rx_i   ), .I(out_uart_rx_i   ), .O(in_uart_rx_o   ), .PAD(pad_uart_rx   ), .PEN(~pad_cfg_i[33][0]) );
    assign in_uart_rx_o=pad_uart_rx;
    //pad_functional_pu padinst_uart_tx    (.OEN(~oe_uart_tx_i   ), .I(out_uart_tx_i   ), .O(in_uart_tx_o   ), .PAD(pad_uart_tx   ), .PEN(~pad_cfg_i[34][0]) );
    assign pad_uart_tx=out_uart_tx_i;
/*
    pad_functional_pd padinst_i2c0_sda   (.OEN(~oe_i2c0_sda_i  ), .I(out_i2c0_sda_i  ), .O(in_i2c0_sda_o  ), .PAD(pad_i2c0_sda  ), .PEN(~pad_cfg_i[7][0] ) );
    pad_functional_pd padinst_i2c0_scl   (.OEN(~oe_i2c0_scl_i  ), .I(out_i2c0_scl_i  ), .O(in_i2c0_scl_o  ), .PAD(pad_i2c0_scl  ), .PEN(~pad_cfg_i[8][0] ) );
*/
    //pad_functional_pu padinst_reset_n    (.OEN(1'b1            ), .I(                ), .O(resetn         ), .PAD(pad_reset_n   ), .PEN(1'b1             ) );
    //rstn_o<=~resetn;
    //assign rstn_o=resetn;
`ifndef PULP_FPGA_EMUL
    pad_functional_pu padinst_ref_clk    (.OEN(1'b1            ), .I(                ), .O(ref_clk_o      ), .PAD(pad_xtal_in   ), .PEN(1'b1             ) );
`else
    
    wire ref_clk_int, ref_clk_pad, ref_clk;
    wire clk1, clk2, clk3, clk4, clk5, clkfb, lock;

    //pad_functional_pu padinst_ref_clk    (.OEN(1'b1            ), .I(                ), .O(ref_clk_pad    ), .PAD(pad_xtal_in   ), .PEN(1'b1             ) );
    //BUFG i_buf ( .O(ref_clk_int), .I(pad_xtal_in) );
    assign ref_clk_int=pad_xtal_in;
    //reset pulse
   /*
   reg [9:0] counter=10'd1023;
   always @(posedge ref_clk_int) begin
   
    counter<= counter+1
   end
   
    counter #(
        .CNT_WIDTH(10)
        .CNT_INIT()
    ) reset_pulse (
      clk_i,
    rstn_i,
    cfg_i,
    clear_i,
    event_o
    );*/
    //rstn_o=lock&rstn_pad
    /*reg rst_meta, rst_sync;
    always @(posedge ref_clk, negedge resetn, negedge lock)
    begin  
      if (resetn == 1'b0 || lock == 1'b0)
      begin
        rst_meta <= 1'b0;
        rst_sync <= 1'b0;
      end
      else
      begin
        rst_sync <= rst_meta;
        rst_meta <= 1'b1;
      end
    end
    assign rstn_o=rst_sync;*/
    PLLE2_BASE #(
        .BANDWIDTH          ( "OPTIMIZED" ),
        .CLKFBOUT_MULT      ( 8           ),
        .CLKFBOUT_PHASE     ( 0.0         ),
        .CLKIN1_PERIOD      ( 10.0        ),
        //16
        /*.CLKOUT0_DIVIDE     ( 32	  ), 
        .CLKOUT1_DIVIDE     ( 32	  ), //clkout0/8=slowclk??
        */
        
        .CLKOUT0_DIVIDE     ( 32	  ), 
        .CLKOUT1_DIVIDE     ( 32      ), //clkout0/8=slowclk??
                
        .CLKOUT2_DIVIDE     ( 1           ),
        .CLKOUT3_DIVIDE     ( 1           ),
        .CLKOUT4_DIVIDE     ( 1           ),
        .CLKOUT5_DIVIDE     ( 1           ),
        .CLKOUT0_DUTY_CYCLE ( 0.5         ),
        .CLKOUT1_DUTY_CYCLE ( 0.5         ),
        .CLKOUT2_DUTY_CYCLE ( 0.5         ),
        .CLKOUT3_DUTY_CYCLE ( 0.5         ),
        .CLKOUT4_DUTY_CYCLE ( 0.5         ),
        .CLKOUT5_DUTY_CYCLE ( 0.5         ),
        .CLKOUT0_PHASE      ( 0.0         ),
        .CLKOUT1_PHASE      ( 0.0         ),
        .CLKOUT2_PHASE      ( 0.0         ),
        .CLKOUT3_PHASE      ( 0.0         ),
        .CLKOUT4_PHASE      ( 0.0         ),
        .CLKOUT5_PHASE      ( 0.0         ),
        .DIVCLK_DIVIDE      ( 1 	  ), // 1.5625 MHz / 48 = 32.55 kHz
        .REF_JITTER1        ( 0.0         ),
        .STARTUP_WAIT       ( "TRUE"      )
    ) i_pll_pad_inst (
        .CLKOUT0  ( ref_clk     ),
        .CLKOUT1  ( clk1        ),
        .CLKOUT2  ( clk2        ),
        .CLKOUT3  ( clk3        ),
        .CLKOUT4  ( clk4        ),
        .CLKOUT5  ( clk5        ),
        .CLKFBOUT ( clkfb       ),
        .LOCKED   ( lock        ),
        .CLKIN1   ( ref_clk_int ),
        .PWRDWN   ( 1'b0        ),
        .RST      ( 1'b0        ),
        .CLKFBIN  ( clkfb       )
    );
    
    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
    wire resetn_s;
    assign rstn_o=~resetn_s;
    proc_sys_reset_0 your_instance_name (
      .slowest_sync_clk(ref_clk_o),          // input wire slowest_sync_clk
      .ext_reset_in(rstn_i),                  // input wire ext_reset_in
      .aux_reset_in(1'b0),                  // input wire aux_reset_in
      .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
      .dcm_locked(lock),                      // input wire dcm_locked
      .mb_reset(resetn_s)                          // output wire mb_reset
    /* .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
      .peripheral_reset(),          // output wire [0 : 0] peripheral_reset
      .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
      .peripheral_aresetn()      // output wire [0 : 0] peripheral_aresetn
      */      
    );
    // INST_TAG_END ------ End INSTANTIATION Template ---------

    /*BUFGCE slow_bufgce (
       .O  ( slow_clk_o ),
       .CE ( lock      ),
       .I  ( clk1   )
    );*/
    BUFGCE i_bufgce (
       .O  ( ref_clk_o ),
       .CE ( lock      ),
       .I  ( ref_clk   )
    );
    assign slow_clk_o=ref_clk_o;    
`endif

endmodule // pad_frame
