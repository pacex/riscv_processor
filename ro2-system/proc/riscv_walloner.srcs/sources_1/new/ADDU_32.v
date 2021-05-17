`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 03:11:10 PM
// Design Name: 
// Module Name: ADDU_32
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


//Adds two unsigned 32bit integers

module ADDU_32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Q
    );
    
    assign Q = A + B;
endmodule
