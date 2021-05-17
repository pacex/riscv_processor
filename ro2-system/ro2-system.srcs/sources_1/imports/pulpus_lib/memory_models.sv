// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
It models a mix of SRAM and SCM memory for low voltage operations.
The SCM it's mapped at the end of the address space.
For Sythesis, replace the generic_memory with the MACRO of the SRAM
*/

`include "fpga_defines.sv"

module model_6144x32_2048x32scm
#(
parameter MEM_INIT_FILE_SCM0="none",
parameter MEM_INIT_FILE_CUT0 ="none",
parameter MEM_INIT_FILE_CUT1 ="none"

/*
    parameter MEM_INIT_FILE_SCM0  = "none",
    parameter MEM_INIT_FILE_CUT0  = "none",
    parameter MEM_INIT_FILE_CUT1  = "none"
    */
)
(
    input  logic        CLK,
    input  logic        RSTN,

    input  logic        CEN,
    input  logic        CEN_scm0,
    input  logic        CEN_scm1,

    input  logic        WEN,
    input  logic        WEN_scm0,
    input  logic        WEN_scm1,

    input  logic  [3:0] BEN,
    input  logic  [3:0] BEN_scm0,

    input  logic [12:0] A,
    input  logic [10:0] A_scm0,
    input  logic [10:0] A_scm1,

    input  logic [31:0] D,
    input  logic [31:0] D_scm0,

    output logic [31:0] Q,
    output logic [31:0] Q_scm0,
    output logic [31:0] Q_scm1
);
        localparam CUT0_ADDRW = 12;
        localparam CUT1_ADDRW = 11;
        localparam SCM0_ADDRW = 11;


         logic CEN_int[2:0];
         logic [2:0][31:0] Q_int;

         logic [1:0]  muxsel;
         logic [31:0] BE_BW;

         logic [3:0]   BE;
         logic [3:0]   BE_scm0;
         logic read_enA,read_enB,read_enC;
         logic write_enA,write_enB;


         assign BE      = ~BEN;
         assign BE_scm0 = ~BEN_scm0;

         assign BE_BW      = { {8{BE[3]}}, {8{BE[2]}}, {8{BE[1]}}, {8{BE[0]}} };

         assign CEN_int[2] = CEN |   ~A[12] | ~A[11]; //scm
         assign CEN_int[1] = CEN |   ~A[12] | A[11];
         assign CEN_int[0] = CEN |   A[12];

         always @(*)
         begin
            case(muxsel)
               2'b00: Q=Q_int[0];
               2'b01: Q=Q_int[0];
               2'b10: Q=Q_int[1];
               2'b11: Q=Q_int[2];
            endcase
         end

         always_ff @(posedge CLK or negedge RSTN)
         begin
            if(~RSTN)
            begin
                muxsel <= '0;
            end
            else
            begin
                if(CEN == 1'b0)
                     muxsel <= A[12:11];
            end
         end
`ifndef DISABLE_UNUSED_MEM
            scm_2048x32 #(
                .MEM_INIT_FILE(MEM_INIT_FILE_SCM0)
            ) scm_0 (
                .CLK       ( CLK          ),
                .RSTN      ( RSTN         ),
                .CEN       ( CEN_int[2]   ),
                .CEN_scm0  ( CEN_scm0     ),
                .CEN_scm1  ( CEN_scm1     ),

                .WEN       ( WEN          ),
                .WEN_scm0  ( WEN_scm0     ),
                .WEN_scm1  ( WEN_scm1     ),

                .BE        ( BE           ),
                .BE_scm0   ( BE_scm0      ),

                .A         ( A[10:0]      ),
                .A_scm0    ( A_scm0[10:0] ),
                .A_scm1    ( A_scm1[10:0] ),

                .D         ( D[31:0]      ),
                .D_scm0    ( D_scm0[31:0] ),

                .Q         ( Q_int[2]     ),
                .Q_scm0    ( Q_scm0       ),
                .Q_scm1    ( Q_scm1       )
            );
                        
            generic_memory #(
               .ADDR_WIDTH ( 13  ),
               .DATA_WIDTH ( 32  ),
               .MEM_INIT_FILE(MEM_INIT_FILE_CUT1)
            ) cut_1 (
               .CLK   ( CLK         ),
               .INITN ( 1'b1        ),
               .D     ( D           ),
               .A     ( {A[10:0],2'b00}     ),
               .CEN   ( CEN_int[1]  ),
               .WEN   ( WEN         ),
               .BEN   ( BEN         ),
               .Q     ( Q_int[1]    )
            );
`endif
            generic_memory #(
               .ADDR_WIDTH ( 14  ),
               .DATA_WIDTH ( 32  ),
               .MEM_INIT_FILE(MEM_INIT_FILE_CUT0)
            ) cut_0 (
               .CLK   ( CLK         ),
               .INITN ( 1'b1        ),
               .D     ( D           ),
               .A     ( {A[11:0],2'b00}    ),
               .CEN   ( CEN_int[0]  ),
               .WEN   ( WEN         ),
               .BEN   ( BEN         ),
               .Q     ( Q_int[0]    )
            );
endmodule

module model_sram_65536x32(
    input  logic        CLK,
    input  logic        RSTN,
    input  logic        CEN,
    input  logic        WEN,
    input  logic  [3:0] BEN,
    input  logic [15:0] A,
    input  logic [31:0] D,
    output logic [31:0] Q
);
        generic_memory #(
               //.ADDR_WIDTH ( 16+2  ),
               .ADDR_WIDTH ( 12+2  ),
               .DATA_WIDTH ( 32  )
               //.MEM_INIT_FILE(MEM_INIT_FILE_CUT0)
            ) bigram (
               .CLK   ( CLK         ),
               .INITN ( 1'b1        ),
               .D     ( D           ),
               .A     ( {A[11:0],2'b00}    ),
               .CEN   ( CEN ),
               .WEN   ( WEN ),
               .BEN   ( BEN ),
               .Q     ( Q )
            );

endmodule


module model_sdp_sram_65536x32
#(
  parameter ADDR_W_WIDTH = 16,
  parameter ADDR_R_WIDTH = 16,
  parameter DATA_W_WIDTH = 32,
  parameter DATA_R_WIDTH = 32,
  parameter BE_WIDTH   = 4,
  parameter MEM_INIT_FILE  = "none",
  parameter MEM_SIZE = 2048
)
(
    input  logic        CLK,
    input  logic        RSTN,
    input  logic        CEN,
    input  logic        WEN,
    input  logic [BE_WIDTH-1:0] BEN,
    input  logic [ADDR_W_WIDTH-1:0] AdrW,    
    input  logic [DATA_W_WIDTH-1:0] D,
    input  logic [ADDR_R_WIDTH-1:0] AdrR,
    output logic [DATA_R_WIDTH-1:0] Q
);
       /* generic_memory #(
               //.ADDR_WIDTH ( 16+2  ),
               .ADDR_WIDTH ( 12+2  ),
               .DATA_WIDTH ( 32  )
               //.MEM_INIT_FILE(MEM_INIT_FILE_CUT0)
            ) bigram (
               .CLK   ( CLK         ),
               .INITN ( 1'b1        ),
               .D     ( D           ),
               .A     ( {A[11:0],2'b00}    ),
               .CEN   ( CEN ),
               .WEN   ( WEN ),
               .BEN   ( BEN ),
               .Q     ( Q )
            );*/
            logic [3:0] wea;
            assign wea = ~WEN ? ~BEN : '0;         
            
            // xpm_memory_sdpram: Simple Dual Port RAM
            // Xilinx Parameterized Macro, Version 2017.4
            xpm_memory_sdpram # (
            
              // Common module parameters
              .MEMORY_SIZE             (MEM_SIZE),            //positive integer
              .MEMORY_PRIMITIVE        ("block"),          //string; "auto", "distributed", "block" or "ultra";
              .CLOCKING_MODE           ("common_clock"),  //string; "common_clock", "independent_clock" 
              .MEMORY_INIT_FILE        (MEM_INIT_FILE),          //string; "none" or "<filename>.mem" 
              .MEMORY_INIT_PARAM       (""    ),          //string;
              .USE_MEM_INIT            (1),               //integer; 0,1
              .WAKEUP_TIME             ("disable_sleep"), //string; "disable_sleep" or "use_sleep_pin" 
              .MESSAGE_CONTROL         (0),               //integer; 0,1
              .ECC_MODE                ("no_ecc"),        //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
              .AUTO_SLEEP_TIME         (0),               //Do not Change
              .USE_EMBEDDED_CONSTRAINT (0),               //integer: 0,1
              .MEMORY_OPTIMIZATION     ("true"),          //string; "true", "false" 
            
              // Port A module parameters
              .WRITE_DATA_WIDTH_A      (DATA_W_WIDTH),              //positive integer
              .BYTE_WRITE_WIDTH_A      (8),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
              .ADDR_WIDTH_A            (ADDR_W_WIDTH),               //positive integer
            
              // Port B module parameters
              .READ_DATA_WIDTH_B       (DATA_R_WIDTH),              //positive integer
              .ADDR_WIDTH_B            (ADDR_R_WIDTH),               //positive integer
              .READ_RESET_VALUE_B      ("0"),             //string
              .READ_LATENCY_B          (1),               //non-negative integer
              .WRITE_MODE_B            ("read_first")      //string; "write_first", "read_first", "no_change" 
            
            ) vga_ram (
            
              // Common module ports
              .sleep                   (1'b0),
            
              // Port A module ports
              .clka                    (CLK),
              .ena                     (~CEN),
              .wea                     (wea),
              .addra                   (AdrW),
              .dina                    (D),
              .injectsbiterra          (1'b0),
              .injectdbiterra          (1'b0),
            
              // Port B module ports
              .clkb                    (CLK),
              .rstb                    (~RSTN),
              .enb                     (1'b1),
              
              .regceb                  (1'b1),
              .addrb                   (AdrR),
              .doutb                   (Q),
              .sbiterrb                (),
              .dbiterrb                ()
            
            );

endmodule

module model_sram_28672x32_scm_512x32
(
    input  logic        CLK,
    input  logic        RSTN,

    input  logic        CEN,
    input  logic        WEN,
    input  logic  [3:0] BEN,
    input  logic [14:0] A,
    input  logic [31:0] D,
    output logic [31:0] Q
);
         logic [7:0]       CEN_int;
         logic             CEN_sram;
         logic [7:0][31:0] Q_int;

         logic  [2:0] muxsel;
         logic [31:0] BE_BW;

         logic [3:0]   BE;
         assign BE = ~BEN;

         assign BE_BW      = { {8{BE[3]}}, {8{BE[2]}}, {8{BE[1]}}, {8{BE[0]}} };


         assign CEN_int[0] = CEN |  A[14] |  A[13] |  A[12];
         assign CEN_int[1] = CEN |  A[14] |  A[13] | ~A[12];
         assign CEN_int[2] = CEN |  A[14] | ~A[13] |  A[12];
         assign CEN_int[3] = CEN |  A[14] | ~A[13] | ~A[12];
         assign CEN_int[4] = CEN | ~A[14] |  A[13] |  A[12];
         assign CEN_int[5] = CEN | ~A[14] |  A[13] | ~A[12];
         assign CEN_int[6] = CEN | ~A[14] | ~A[13] |  A[12];
         assign CEN_int[7] = CEN | ~A[14] | ~A[13] | ~A[12]; // 2KB scm

         assign Q = Q_int[muxsel];

         always_ff @(posedge CLK or negedge RSTN)
         begin
            if(~RSTN)
            begin
                muxsel <= '0;
            end
            else
            begin
                if(CEN == 1'b0)
                     muxsel <= A[14:12];
            end
         end

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_0 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[0]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[0]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_1 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[1]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[1]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_2 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[2]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[2]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_3 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[3]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[3]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_4 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[4]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[4]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_5 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[5]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[5]    )
         );

         generic_memory #(
            .ADDR_WIDTH ( 12  ),
            .DATA_WIDTH ( 32  )
         ) cut_6 (
            .CLK   ( CLK         ),
            .INITN ( 1'b1        ),
            .D     ( D           ),
            .A     ( A[11:0]     ),
            .CEN   ( CEN_int[6]  ),
            .WEN   ( WEN         ),
            .BEN   ( BEN         ),
            .Q     ( Q_int[6]    )
         );

         scm_512x32 scm_7
         (
           .CLK       ( CLK          ),
           .RSTN      ( RSTN         ),
           .CEN       ( CEN_int[7]   ),
           .WEN       ( WEN          ),
           .BE        ( BE           ),
           .A         ( A[10:0]      ), // 2 kB -> 9 bits; 4 kB -> 10 bits; 8 kB -> 11 bits; 16 kB -> 12 bits
           .D         ( D[31:0]      ),
           .Q         ( Q_int[7]     )
         );

endmodule