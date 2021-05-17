
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2018 12:35:31
// Design Name: 
// Module Name: jtag_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jtag_wrapper (
    input clock_i,
    input resetn_i,
    AXI_BUS.Master axi_master
);
/*
//axilite
jtag_axi_0 jtag_module (
    .aclk(clock_i),
    .aresetn(resetn_i),
    //.m_axi_awid(axi_master.aw_id[0]),
    .m_axi_awaddr(axi_master.aw_addr),
    //.m_axi_awlen(axi_master.aw_len),
    //.m_axi_awsize(axi_master.aw_size),
    //.m_axi_awburst(axi_master.aw_burst),
    //.m_axi_awlock(axi_master.aw_lock),
    //.m_axi_awcache(axi_master.aw_cache),
    .m_axi_awprot(axi_master.aw_prot),
    //.m_axi_awqos(axi_master.aw_qos),
    .m_axi_awvalid(axi_master.aw_valid),
    .m_axi_awready(axi_master.aw_ready),
    .m_axi_wdata(axi_master.w_data),
    .m_axi_wstrb(axi_master.w_strb),
    //.m_axi_wlast(axi_master.w_last),
    .m_axi_wvalid(axi_master.w_valid),
    .m_axi_wready(axi_master.w_ready),
    //.m_axi_bid(axi_master.b_id[0]),
    .m_axi_bresp(axi_master.b_resp),
    .m_axi_bvalid(axi_master.b_valid),
    .m_axi_bready(axi_master.b_ready),
    //.m_axi_arid(axi_master.ar_id[0]),
    .m_axi_araddr(axi_master.ar_addr),
    //.m_axi_arlen(axi_master.ar_len),
    //.m_axi_arsize(axi_master.ar_size),
    //.m_axi_arburst(axi_master.ar_burst),
    //.m_axi_arlock(axi_master.ar_lock),
    //.m_axi_arcache(axi_master.ar_cache),
    .m_axi_arprot(axi_master.ar_prot),
    //.m_axi_arqos(axi_master.ar_qos),
    .m_axi_arvalid(axi_master.ar_valid),
    .m_axi_arready(axi_master.ar_ready),
    //.m_axi_rid(axi_master.r_id[0]),
    .m_axi_rdata(axi_master.r_data),
    .m_axi_rresp(axi_master.r_resp),
    //.m_axi_rlast(axi_master.r_last),
    .m_axi_rvalid(axi_master.r_valid),
    .m_axi_rready(axi_master.r_ready)
  );
  */
  
  
  jtag_axi_0 jtag_module (
      .aclk(clock_i),
      .aresetn(resetn_i),
      .m_axi_awid(axi_master.aw_id[0]),
      .m_axi_awaddr(axi_master.aw_addr),
      .m_axi_awlen(axi_master.aw_len),
      .m_axi_awsize(axi_master.aw_size),
      .m_axi_awburst(axi_master.aw_burst),
      .m_axi_awlock(axi_master.aw_lock),
      .m_axi_awcache(axi_master.aw_cache),
      .m_axi_awprot(axi_master.aw_prot),
      .m_axi_awqos(axi_master.aw_qos),
      .m_axi_awvalid(axi_master.aw_valid),
      .m_axi_awready(axi_master.aw_ready),
      .m_axi_wdata(axi_master.w_data),
      .m_axi_wstrb(axi_master.w_strb),
      .m_axi_wlast(axi_master.w_last),
      .m_axi_wvalid(axi_master.w_valid),
      .m_axi_wready(axi_master.w_ready),
      .m_axi_bid(axi_master.b_id[0]),
      .m_axi_bresp(axi_master.b_resp),
      .m_axi_bvalid(axi_master.b_valid),
      .m_axi_bready(axi_master.b_ready),
      .m_axi_arid(axi_master.ar_id[0]),
      .m_axi_araddr(axi_master.ar_addr),
      .m_axi_arlen(axi_master.ar_len),
      .m_axi_arsize(axi_master.ar_size),
      .m_axi_arburst(axi_master.ar_burst),
      .m_axi_arlock(axi_master.ar_lock),
      .m_axi_arcache(axi_master.ar_cache),
      .m_axi_arprot(axi_master.ar_prot),
      .m_axi_arqos(axi_master.ar_qos),
      .m_axi_arvalid(axi_master.ar_valid),
      .m_axi_arready(axi_master.ar_ready),
      .m_axi_rid(axi_master.r_id[0]),
      .m_axi_rdata(axi_master.r_data),
      .m_axi_rresp(axi_master.r_resp),
      .m_axi_rlast(axi_master.r_last),
      .m_axi_rvalid(axi_master.r_valid),
      .m_axi_rready(axi_master.r_ready)
    );
  
  
endmodule
