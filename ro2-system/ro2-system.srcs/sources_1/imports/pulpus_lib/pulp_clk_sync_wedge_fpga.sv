// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module pulp_clk_sync_wedge_fpga
  (
   input  logic clk_i,
   input  logic rstn_i,
   input  logic slower_clk_i,
   output logic r_edge_o,
   output logic f_edge_o,
   output logic serial_o
   );
   
   logic [2:0] r_clk_sync;
   always_ff @(posedge clk_i or negedge rstn_i) begin : proc_r_clk_sync
         if(~rstn_i) begin
             r_clk_sync[1] <= 1'b0;
             r_clk_sync[2] <= 1'b0;
                   r_edge_o <= 1'b0;
                    f_edge_o <= 1'b0;
                    serial_o   <= 1'b0;
         end else begin
             //store prev
             r_clk_sync[1]<=r_clk_sync[0];
             //delay 1 clock to be in sync with former solution
             r_clk_sync[2] <= r_clk_sync[1];
                      
             r_edge_o <= ~r_clk_sync[2] & r_clk_sync[1];
             f_edge_o <= r_clk_sync[2] & ~r_clk_sync[1];
             serial_o   <=  r_clk_sync[2];
         end
     end
    always_ff @(posedge slower_clk_i or negedge rstn_i) begin : proc_r_clk_sync2
        if(~rstn_i) begin
          r_clk_sync[0] <= 1'b0;
        end else begin                 
          r_clk_sync[0]<=~r_clk_sync[0];
        end
    end   
endmodule