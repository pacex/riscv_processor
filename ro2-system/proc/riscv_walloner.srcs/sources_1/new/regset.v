`timescale 1ns / 1ps

module regset(
    input [31:0] D,
    input [4:0] A_D,
    input [4:0] A_Q0,
    input [4:0] A_Q1,
    input write_enable,
    input RES,
    input CLK,
    output wire [31:0] Q0,
    output wire [31:0] Q1
    );
    
    reg [31:0] REG [31:1];
    integer i;
    
    assign Q0 = A_Q0 == 0 ? 0 : REG[A_Q0];
    assign Q1 = A_Q1 == 0 ? 0 : REG[A_Q1];
    
    always @(posedge CLK, posedge RES)
    begin
        if (RES==1'b1)
        begin
            for (i=1; i<32; i=i+1) REG[i] <= 32'b0;
        end
        else
        begin
            if (write_enable == 1'b1)
            begin
                REG[A_D] <= D;
            end
        end
    end
endmodule
