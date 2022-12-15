module cache #(
    parameter DATA_WIDTH =32,ADDRESS_WIDTH = 30,CACHE_SIZE = 8,BLOCK_SIZE = 3
) (
    input logic [ADDRESS_WIDTH-1:0] address,
    input logic [DATA_WIDTH-1:0] d_in,
    input logic [JUST_DATA-1:0] mem_data_in,
    input logic clk, write_enable, read_en,
    output logic [DATA_WIDTH-1:0] d_out,
    output logic [ADDRESS_WIDTH-1:0] mem_address
);

parameter TAG_SIZE =  ADDRESS_WIDTH-CACHE_SIZE;

parameter JUST_DATA = DATA_WIDTH*(2**BLOCK_SIZE);

parameter V = JUST_DATA+ADDRESS_WIDTH-CACHE_SIZE; //The V flag

logic [ADDRESS_WIDTH-CACHE_SIZE-1:0] tag = address[ADDRESS_WIDTH-1:CACHE_SIZE]; //tag

logic [CACHE_SIZE-BLOCK_SIZE-1:0] set = address[CACHE_SIZE-1:BLOCK_SIZE]; //Which Set

logic [BLOCK_SIZE-1:0] way = address[BLOCK_SIZE-1:0]; //Which Block

logic [JUST_DATA-1:0] block,write_data;

logic hit;

logic [V:0] cache_mem [2**(CACHE_SIZE-BLOCK_SIZE)-1:0];

always_comb begin
    hit = (cache_mem[set][V]!=0'b0)&&(cache_mem[set][V-1:V-TAG_SIZE] == tag);
    mem_address = 0;
    block = 0;
        if(write_enable) begin
            mem_address = address;
            if(hit) block = cache_mem[set][JUST_DATA-1:0];
            else block = mem_data_in;
        end
        else if(read_en)begin
            if(hit) block = cache_mem[set][JUST_DATA-1:0];
            else begin
                mem_address = address;
                block = mem_data_in;
            end
        end
    end

blockread #(DATA_WIDTH,BLOCK_SIZE) read1(
    .block(block),
    .way(way),
    .d_out(d_out)
);

blockwrite #(DATA_WIDTH,BLOCK_SIZE) write1(
    .d_in(d_in),
    .block(block),
    .way(way),
    .block_out(write_data)
);

always_ff @(posedge clk) begin
    if(write_enable) cache_mem[set] <= {1'b1,tag,write_data};
    else if((!hit)&&read_en) cache_mem[set] <= {1'b1,tag,mem_data_in};
end
    
endmodule
