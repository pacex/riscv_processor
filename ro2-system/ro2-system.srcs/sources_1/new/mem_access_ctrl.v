`timescale 1ns / 1ps

//States
`define IDLE    2'b00
`define ACCESS  2'b01
`define VALID   2'b10


module mem_access_ctrl(

    input CLK,
    input RES,

    //Signals to Memory
    input [31:0] data_read,
    output [31:0] data_write,
    output [31:0] data_adr,
    output data_req,
    input data_gnt,
    input data_r_valid,
    output data_write_enable,
    output [3:0] data_be,
    
    //Signals to proc1
    output [31:0] proc0_read,
    input [31:0] proc0_write,
    input [31:0] proc0_adr,
    input proc0_req,
    output proc0_gnt,
    output proc0_r_valid,
    input proc0_write_enable,
    input [3:0] proc0_be,
    
    //Signals to proc2
    output [31:0] proc1_read,
    input [31:0] proc1_write,
    input [31:0] proc1_adr,
    input proc1_req,
    output proc1_gnt,
    output proc1_r_valid,
    input proc1_write_enable,
    input [3:0] proc1_be
    );
    
    reg [1:0] state;
    reg core;
    
    wire core_selected;
    
    assign core_selected = (state == `IDLE) ? (proc1_req & (~proc0_req | core == 0)) : core; //contains ID of core that is granted access (IDLE) or that currently has access (ACCESS)
    
    always @(posedge RES, posedge CLK) begin
        if (RES == 1)begin
            state <= `IDLE;
            core <= 1'b1;
        end
        else if(state == `IDLE && (proc0_req | proc1_req) && data_gnt == 1) begin
            state <= `ACCESS;
            core <= core_selected;
        end
        else if (state == `ACCESS && data_r_valid == 1'b1)
        begin
            state <= `VALID;
        end
        else if (state == `VALID && data_r_valid == 1'b0) begin
            state <= `IDLE;
        end
        else state <= state;
    end
    
    //===AUSGANGSSIGNALE===
    
    //Data signals
    assign data_write = (core_selected == 0) ? proc0_write : proc1_write;
    assign data_adr = (core_selected == 0) ? proc0_adr : proc1_adr;
    assign data_req = ((core_selected == 0) ? proc0_req : proc1_req) & state == `IDLE;
    assign data_write_enable = (core_selected == 0) ? proc0_write_enable : proc1_write_enable;
    assign data_be = (core_selected == 0) ? proc0_be : proc1_be;
    
    //Proc0 signals
    assign proc0_read = (core_selected == 0) ? data_read : 32'b0;
    assign proc0_gnt = ((core_selected == 0) ? data_gnt : 1'b0) & state == `IDLE;
    assign proc0_r_valid = (core_selected == 0) ? data_r_valid : 1'b0;
    
    //Proc1 signals
    assign proc1_read = (core_selected == 1) ? data_read : 32'b0;
    assign proc1_gnt = ((core_selected == 1) ? data_gnt : 1'b0) & state == `IDLE;
    assign proc1_r_valid = (core_selected == 1) ? data_r_valid : 1'b0;
    
endmodule
