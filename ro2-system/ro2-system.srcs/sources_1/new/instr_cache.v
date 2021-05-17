`timescale 1ns / 1ps

//States
`define IDLE    2'b00
`define HIT     2'b01
`define MISS    2'b10


module instr_cache
    #(
        parameter LOG_SIZE = 6
    )(
        input clk,
        input res,
        
        //Interface proc <=> cache
        input cached_instr_req,
        input [31:0] cached_instr_adr,
        output cached_instr_gnt,
        output cached_instr_rvalid,
        output [31:0] cached_instr_read,
        
        //Interface cache <=> memory
        output instr_req,
        output [31:0] instr_adr,
        input instr_gnt,
        input instr_rvalid,
        input [31:0] instr_read
    );
    
    reg [31:0] lines [(2**LOG_SIZE)-1:0];
    reg [29-LOG_SIZE:0] tags [(2**LOG_SIZE)-1:0];
    reg [(2**LOG_SIZE)-1:0] valids;
    wire hit;
    wire [LOG_SIZE-1:0] index;
    
    reg [1:0] state;
    
    //Internal signals
    assign index = cached_instr_adr[LOG_SIZE+1:2];
    assign hit = (valids[index] == 1) ? (tags[index] == cached_instr_adr[31:LOG_SIZE+2]) : 0;
    
    //Non-state dependant output signals
    assign cached_instr_read = hit ? lines[index] : instr_read;
    assign instr_req = hit ? 0 : cached_instr_req;
    assign instr_adr = cached_instr_adr;
    
    //State transitions and internal data updates
    always @(posedge res, posedge clk) begin
        if (res == 1) begin
            state <= `IDLE;
            valids <= {2**LOG_SIZE{1'b0}};
        end
        else begin
            //State transitions
            case (state)
                `IDLE:
                    if (cached_instr_req == 1 && hit == 0) state <= `MISS;
                    else if (cached_instr_req == 1 && hit == 1) state <= `HIT;
                    else state <= `IDLE;
                `HIT: state <= `IDLE;
                `MISS: 
                    if (instr_rvalid == 1) state <= `IDLE;
                    else state <= `MISS;
                default:
                    state <= `IDLE;
            endcase
            
            //Internal data updates
            if (instr_rvalid == 1) begin
                lines[index] <= instr_read;
                tags[index] <= cached_instr_adr[31:LOG_SIZE+2];
                valids[index] <= 1'b1;
            end
            else begin
            end
        end
    end
    
    //State dependant outputs
    assign cached_instr_gnt = hit ? cached_instr_req : instr_gnt;
    assign cached_instr_rvalid = hit ? (state == `HIT) : instr_rvalid;
    
endmodule
