// Copyright 2014-2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/*
 * brandhsn
 */
//assuming ReadEnable_x XOR WriteEnable_y

module register_file_3r_2w_be
#(
    parameter ADDR_WIDTH    = 5,
    parameter DATA_WIDTH    = 64,
    parameter NUM_BYTE      = DATA_WIDTH/8,  
    parameter MEM_INIT_FILE ="none" 
)
(
    input   logic                               clk,
    input   logic                               rst_n,

    // Read port A
    input  logic                                ReadEnable_A,
    input  logic [ADDR_WIDTH-1:0]               ReadAddr_A,
    output logic [DATA_WIDTH-1:0]               ReadData_A,

    // Read port B
    input  logic                                ReadEnable_B,
    input  logic [ADDR_WIDTH-1:0]               ReadAddr_B,
    output logic [DATA_WIDTH-1:0]               ReadData_B,

    // Read port C
    input  logic                                ReadEnable_C,
    input  logic [ADDR_WIDTH-1:0]               ReadAddr_C,
    output logic [DATA_WIDTH-1:0]               ReadData_C,

    // Write port A
    input  logic                                WriteEnable_A,
    input  logic [ADDR_WIDTH-1:0]               WriteAddr_A,
    input  logic [DATA_WIDTH-1:0]               WriteData_A,
    input  logic [NUM_BYTE-1:0]                 WriteBE_A,

    // Write port B
    input  logic                                WriteEnable_B,
    input  logic [ADDR_WIDTH-1:0]               WriteAddr_B,
    input  logic [DATA_WIDTH-1:0]               WriteData_B,
    input  logic [NUM_BYTE-1:0]                 WriteBE_B
);
  localparam MEM_SIZE = (2**ADDR_WIDTH)*DATA_WIDTH;
  localparam READ_LATENCY= 1;


  logic ena,enb,enc;
  logic [ADDR_WIDTH-1:0] addra,addrb,addrc;
  logic [NUM_BYTE-1:0] wea,web;
  
  assign ena=ReadEnable_A | WriteEnable_A;
  assign enb=ReadEnable_B | WriteEnable_B;
  assign enc=ReadEnable_C | WriteEnable_A;
    
  //condition ? if true : if false
  assign addra=  WriteEnable_A ? WriteAddr_A : ReadAddr_A;
  assign addrb=  WriteEnable_B ? WriteAddr_B : ReadAddr_B;
  assign addrc=  WriteEnable_A ? WriteAddr_A : ReadAddr_C;
  
  assign wea={NUM_BYTE{WriteEnable_A}} & WriteBE_A;
  assign web={NUM_BYTE{WriteEnable_B}} & WriteBE_B;
  
  
  
  xpm_memory_tdpram # (
  
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
    .WRITE_DATA_WIDTH_A      (DATA_WIDTH),              //positive integer
    .READ_DATA_WIDTH_A       (DATA_WIDTH),              //positive integer
    .BYTE_WRITE_WIDTH_A      (8),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
    .ADDR_WIDTH_A            (ADDR_WIDTH),               //positive integer
    .READ_RESET_VALUE_A      ("0"),             //string
    .READ_LATENCY_A          (READ_LATENCY),               //non-negative integer
    .WRITE_MODE_A            ("no_change"),     //string; "write_first", "read_first", "no_change" 
  
    // Port B module parameters
    .WRITE_DATA_WIDTH_B      (DATA_WIDTH),              //positive integer
    .READ_DATA_WIDTH_B       (DATA_WIDTH),              //positive integer
    .BYTE_WRITE_WIDTH_B      (8),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
    .ADDR_WIDTH_B            (ADDR_WIDTH),               //positive integer
    .READ_RESET_VALUE_B      ("0"),             //vector of READ_DATA_WIDTH_B bits
    .READ_LATENCY_B          (READ_LATENCY),               //non-negative integer
    .WRITE_MODE_B            ("no_change")      //string; "write_first", "read_first", "no_change" 
  
  ) xpm_memory_tdpram_i_0 (
  
    // Common module ports
    .sleep                   (1'b0),
  
    // Port A module ports
    .clka                    (clk),
    .rsta                    (~rst_n),
    .ena                     (ena),
    .regcea                  (1'b1 ),
    .wea                     (wea),
    .addra                   (addra),
    .dina                    (WriteData_A),
    .injectsbiterra          (1'b0),
    .injectdbiterra          (1'b0),
    .douta                   (ReadData_A),
    .sbiterra                (),
    .dbiterra                (),
  
    // Port B module ports
    .clkb                    (clk),
    .rstb                    (~rst_n),
    .enb                     (enb),
    .regceb                  (1'b1 ),
    .web                     (web),
    .addrb                   (addrb),
    .dinb                    (WriteData_B),
    .injectsbiterrb          (1'b0),
    .injectdbiterrb          (1'b0),
    .doutb                   (ReadData_B),
    .sbiterrb                (),
    .dbiterrb                ()  
  );
  
    xpm_memory_tdpram # (
  
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
    .WRITE_DATA_WIDTH_A      (DATA_WIDTH),              //positive integer
    .READ_DATA_WIDTH_A       (DATA_WIDTH),              //positive integer
    .BYTE_WRITE_WIDTH_A      (8),              //integer; 8, 9, or WRITE_DATA_WIDTH_A value
    .ADDR_WIDTH_A            (ADDR_WIDTH),               //positive integer
    .READ_RESET_VALUE_A      ("0"),             //string
    .READ_LATENCY_A          (READ_LATENCY),               //non-negative integer
    .WRITE_MODE_A            ("no_change"),     //string; "write_first", "read_first", "no_change" 
  
    // Port B module parameters
    .WRITE_DATA_WIDTH_B      (DATA_WIDTH),              //positive integer
    .READ_DATA_WIDTH_B       (DATA_WIDTH),              //positive integer
    .BYTE_WRITE_WIDTH_B      (8),              //integer; 8, 9, or WRITE_DATA_WIDTH_B value
    .ADDR_WIDTH_B            (ADDR_WIDTH),               //positive integer
    .READ_RESET_VALUE_B      ("0"),             //vector of READ_DATA_WIDTH_B bits
    .READ_LATENCY_B          (READ_LATENCY),               //non-negative integer
    .WRITE_MODE_B            ("no_change")      //string; "write_first", "read_first", "no_change" 
  
  ) xpm_memory_tdpram_i_1 (
  
    // Common module ports
    .sleep                   (1'b0),
  
    // Port A module ports
    .clka                    (clk),
    .rsta                    (~rst_n),
    .ena                     (enc),
    .regcea                  (1'b1 ),
    .wea                     (wea),
    .addra                   (addrc),
    .dina                    (WriteData_A),
    .injectsbiterra          (1'b0),
    .injectdbiterra          (1'b0),
    .douta                   (ReadData_C),
    .sbiterra                (),
    .dbiterra                (),
  
    // Port B module ports
    .clkb                    (clk),
    .rstb                    (~rst_n),
    .enb                     (WriteEnable_B),
    .regceb                  (1'b1 ),
    .web                     (web),
    .addrb                   (addrb),
    .dinb                    (WriteData_B),
    .injectsbiterrb          (1'b0),
    .injectdbiterrb          (1'b0),
    .doutb                   (),
    .sbiterrb                (),
    .dbiterrb                ()  
  );
  
endmodule
