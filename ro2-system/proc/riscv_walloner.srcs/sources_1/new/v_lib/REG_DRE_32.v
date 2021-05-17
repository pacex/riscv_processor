`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2018 10:24:09
// Design Name: 
// Module Name: REG_DRE_32
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


module REG_DRE_32(
    input [31:0] D,
    output [31:0] Q,
    input CLK,
    input RES,
    input ENABLE
    );
    reg [31:0] Q_tmp=32'd0;
    assign Q=Q_tmp;
    always @(posedge CLK, posedge RES)
    begin
      if(RES==1'b1)
        Q_tmp<=32'd0;        
      else if(ENABLE==1'b1)
        Q_tmp<=D;
      else
        Q_tmp<=Q_tmp;
    end
endmodule
