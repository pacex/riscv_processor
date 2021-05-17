// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


`include "pulp_soc_defines.sv"

module boot_rom #(
    parameter ROM_ADDR_WIDTH = 13
    )
    (
     input logic             clk_i,
     input logic             rst_ni,
     input logic             init_ni,
     UNICAD_MEM_BUS_32.Slave mem_slave,
     input logic             test_mode_i
    );

    `ifndef PULP_FPGA_EMUL

        generic_rom #(
            .ADDR_WIDTH(ROM_ADDR_WIDTH-2),
            .DATA_WIDTH(32)
         ) rom_mem_i (
            .CLK            (  clk_i                ),
            .CEN            (  mem_slave.csn        ),
            .A              (  mem_slave.add[ROM_ADDR_WIDTH-1:2]  ),
            .Q              (  mem_slave.rdata      )
        );

    `else
        xpm_memory_spram # (
        `ifndef XILINX_SIMULATOR
          .MEMORY_SIZE        ( 2**(ROM_ADDR_WIDTH-2)*32 ),
        `else
		  .MEMORY_SIZE        ( 65536 ),
        `endif
          .MEMORY_PRIMITIVE   ( "block"               ),
        `ifndef XILINX_SIMULATOR
          .MEMORY_INIT_FILE   ( "./boot-pulpissimo.mem"  ),
          //.MEMORY_INIT_FILE   ( "system.mem"  ),
          //.MEMORY_INIT_FILE   ( "system.mem"  ),
        `else
          .MEMORY_INIT_FILE   ( "system.mem"  ),
          //.MEMORY_INIT_FILE   ( "./boot-pulpissimo.mem"  ),
        `endif
          //.MEMORY_INIT_FILE   ( "none"  ),
          .MEMORY_INIT_PARAM  ( ""                    ),
          .USE_MEM_INIT       ( 1                     ),
          .WAKEUP_TIME        ( "disable_sleep"       ),
          .MESSAGE_CONTROL    ( 0                     ),
          .ECC_MODE           ( "no_ecc"              ),
          .AUTO_SLEEP_TIME    ( 0                     ),
          .READ_DATA_WIDTH_A  ( 32                    ),
           `ifndef XILINX_SIMULATOR
              .ADDR_WIDTH_A       ( ROM_ADDR_WIDTH-2      ),
          `else
              //.ADDR_WIDTH_A       ( 19      ),
              .ADDR_WIDTH_A       ( ROM_ADDR_WIDTH-2      ),
          `endif
          .READ_RESET_VALUE_A ( "0"                   ),
          .READ_LATENCY_A     ( 1                     )
        ) rom_mem_i (
          .sleep          ( 1'b0                              ),
          .clka           ( clk_i                             ),
          .rsta           ( 1'b0                              ),
          .ena            ( ~mem_slave.csn                    ),
          .regcea         ( 1'b1                              ),
          .addra          ( mem_slave.add[ROM_ADDR_WIDTH-1:2] ),
          .injectsbiterra ( 1'b0                              ),
          .injectdbiterra ( 1'b0                              ),
          .douta          ( mem_slave.rdata                   ),
          .sbiterra       (                                   ),
          .dbiterra       (                                   )
        );
/*
	initial
	begin
     		$readmemb("/home/brandhsn/fpgaPulpissimo/pulpissimo/fpga/boot_code.cde", pulpissimo_i/soc_domain_i/pulp_soc_i/boot_rom_i/rom_mem_i/xpm_memory_base_inst/gen_wr_a.gen_word_narrow.mem_reg_0);
     		$readmemb("/home/brandhsn/fpgaPulpissimo/pulpissimo/fpga/boot_code.cde", pulpissimo_i/soc_domain_i/pulp_soc_i/boot_rom_i/rom_mem_i/xpm_memory_base_inst);
     		$readmemb("/home/brandhsn/fpgaPulpissimo/pulpissimo/fpga/boot_code.cde", pulpissimo_i/soc_domain_i/pulp_soc_i/boot_rom_i/rom_mem_i);
	end */
    `endif
endmodule
