`timescale 1ns / 1ps

module MUX_4x1_32(
    input [31:0] I0,
    input [31:0] I1,
    input [31:0] I2,
    input [31:0] I3,
    input [1:0] S,
    output reg [31:0] Y
    );
    
    always @(I0, I1, I2, I3, S) begin
        case (S)
            2'b00: Y = I0;
            2'b01: Y = I1;
            2'b10: Y = I2;
            2'b11: Y = I3;
        endcase
    end
endmodule
