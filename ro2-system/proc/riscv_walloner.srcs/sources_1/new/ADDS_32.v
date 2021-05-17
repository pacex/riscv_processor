`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 03:28:13 PM
// Design Name: 
// Module Name: ADDS_32
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


module ADDS_32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Q
    );
    
    assign Q = $signed(A) + $signed(B);
endmodule
