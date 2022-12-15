module cache #(
    parameter DATA_WIDTH =32,ADDRESS_WIDTH = 30,CACHE_SIZE = 8,BLOCK_SIZE = 3
) (
    /* verilator lint_off UNUSED */
    /* verilator lint_off UNDRIVEN */
    input logic [ADDRESS_WIDTH-1:0] address,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic [MEM_IN_SIZE-1:0] mem_data_in,
    input logic clk, write_enable,
    output logic hit,
    output logic [DATA_WIDTH-1:0] d_out,
    output logic [ADDRESS_WIDTH-1:0] mem_address
);

parameter TAG_SIZE =  ADDRESS_WIDTH-CACHE_SIZE;
parameter MEM_IN_SIZE = DATA_WIDTH*(2**BLOCK_SIZE);
parameter V = MEM_IN_SIZE+ADDRESS_WIDTH-CACHE_SIZE; //The V flag
logic [ADDRESS_WIDTH-CACHE_SIZE-1:0] tag = address[ADDRESS_WIDTH-1:CACHE_SIZE]; //tag
logic [CACHE_SIZE-BLOCK_SIZE-1:0] set = address[CACHE_SIZE-1:BLOCK_SIZE]; //Which Set
logic [BLOCK_SIZE-1:0] way = address[BLOCK_SIZE-1:0]; //Which Block
logic [V-1-ADDRESS_WIDTH+CACHE_SIZE:0] tmpdata;


logic [V:0] cache_mem [2**(CACHE_SIZE-BLOCK_SIZE)-1:0];

always_comb begin
    hit = (cache_mem[set][V]!=0)&&(cache_mem[set][V-1:V-TAG_SIZE] == tag);
    tmpdata = 0;
    mem_address = 0;
    d_out = 0;
    if(write_enable) begin
        if(hit) begin
            
        end
        else begin
        end
    end
    else begin
        if(hit) d_out = {cache_mem[set]>>(DATA_WIDTH*way)}[DATA_WIDTH-1:0]; //optimize
        else mem_address = address; 
    end
end

always_ff @(posedge clk) begin
    if(!hit) cache_mem[set] <= {1'b1,tag,mem_data_in};
end
    
endmodule
