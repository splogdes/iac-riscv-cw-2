module memoryunit #(
    parameter   
    DATA_WIDTH = 32, 
    ADDRESS_WIDTH = 32, 
    MEMORY_SIZE = 14, 
    SOURCE_FILE = "datamemory.mem",
    CACHE_SIZE = 2,
    BLOCK_SIZE = 1
) (
    input logic     [ADDRESS_WIDTH-1:0] address,
    input logic     [DATA_WIDTH-1:0]    write_data,
    input logic     [2:0]               DATAMEMControl,
    input logic                         write_enable,
    input logic                         clk,
    input logic                         read_en,
    output logic    [DATA_WIDTH-1:0]    read_data
);

logic [DATA_WIDTH-1:0] cache_in,cache_out;
logic [DATA_WIDTH*(2**BLOCK_SIZE)-1:0] mem_read;
logic [ADDRESS_WIDTH-3:0] mem_address;


datamemory #(DATA_WIDTH,ADDRESS_WIDTH-2,MEMORY_SIZE,BLOCK_SIZE,SOURCE_FILE) datamemory1(
    .address(mem_address),
    .write_data(cache_in),
    .write_enable(write_enable),
    .clk(clk),
    .read_data(mem_read)
);

datacontroller #(DATA_WIDTH) data_controller1(
    .mem_data_in(write_data),
    .mem_data_out(cache_out),
    .DATAMEMControl(DATAMEMControl),
    .First_2(address[1:0]),
    .write_data(cache_in),
    .read_data(read_data)
);

cache #(DATA_WIDTH,ADDRESS_WIDTH-2,CACHE_SIZE,BLOCK_SIZE) cache1(
    .clk(clk),
    .read_en(read_en),
    .address(address[ADDRESS_WIDTH-1:2]),
    .write_enable(write_enable),
    .mem_data_in(mem_read),
    .mem_address(mem_address),
    .d_in(cache_in),
    .d_out(cache_out)
);
    
endmodule
