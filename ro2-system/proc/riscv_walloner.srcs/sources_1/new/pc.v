`timescale 1ns / 1ps

module pc(
    input [31:0] D,
    input MODE,
    input ENABLE,
    input RES,
    input CLK,
    output reg [31:0] PC_OUT
    );
    
    always @(posedge CLK, posedge RES)
    begin
        if (RES == 1)
        begin
            //Reset program counter
            PC_OUT = 32'h1A000000; //PC_OUT = 32'h1A000000;
        end
        else
        begin
            if (ENABLE == 1)
            begin 
                //PC enabled
                if(MODE == 1)
                begin
                    //Load jump address
                    PC_OUT = D;
                end
                else
                begin
                    //Increment program counter
                    PC_OUT = PC_OUT + 32'h4;
                end
            end
            else
            begin
                //Program counter not enabled
                PC_OUT = PC_OUT;
            end
        end
    end   
endmodule
