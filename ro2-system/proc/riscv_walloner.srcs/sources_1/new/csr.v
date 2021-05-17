`timescale 1ns / 1ps

`include "csr_adresses.vh"

module csr
    #(
    parameter HARTID = 0,
    parameter CLK_CYCLE = 0
    )(
    input CLK,
    input RES,
    input INSTRET,
    input [31:0] ADDR,
    output reg [31:0] Q
    );
    
    reg [63:0] RDCYCLE;
    reg [63:0] RDTIME;
    reg [63:0] RDINSTRET;
    
    always @(posedge CLK, posedge RES) begin
        if (RES) begin
            RDCYCLE <= 64'b0;
            RDTIME <= 64'b0;
            RDINSTRET <= 64'b0;
        end else begin
            RDCYCLE <= RDCYCLE + 1;
            RDTIME <= RDTIME + CLK_CYCLE;
            if (INSTRET) RDINSTRET <= RDINSTRET + 1;
        end
    end
    
    always @(ADDR, RDCYCLE, RDTIME, RDINSTRET) begin
        case (ADDR)
            `CSR_RDCYCLE_LOW:       Q = RDCYCLE[31:0];
            `CSR_RDCYCLE_HIGH:      Q = RDCYCLE[63:32];
            `CSR_RDTIME_LOW:        Q = RDTIME[31:0];
            `CSR_RDTIME_HIGH:       Q = RDTIME[63:32];
            `CSR_RDINSTRET_LOW:     Q = RDINSTRET[31:0];
            `CSR_RDINSTRET_HIGH:    Q = RDINSTRET[63:32];
            `CSR_MHARTID:           Q = HARTID;
            default:                Q = 32'b0;
        endcase
    end
    
endmodule
