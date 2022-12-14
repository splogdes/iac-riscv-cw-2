module memoryunit #(
    parameter   DATA_WIDTH = 32, ADDRESS_WIDTH = 32, MEMORY_SIZE = 14
) (
    input logic     [ADDRESS_WIDTH-1:0] address,
    input logic     [DATA_WIDTH-1:0]    write_data,
    input logic     [2:0]               DATAMEMControl,
    input logic                         write_enable,
    input logic                         clk,
    output logic    [DATA_WIDTH-1:0]    read_data
);

logic [DATA_WIDTH-1:0] mem_in,mem_out,mem_addr,cache_out;

datamemory #(DATA_WIDTH,ADDRESS_WIDTH-2,MEMORY_SIZE) datamemory1(
    .address(mem_addr),
    .write_data(write_data),
    .write_enable(write_enable),
    .clk(clk),
    .read_data(mem_out)
);

// datacontroller #(DATA_WIDTH) data_controller1(
//     .mem_data_in(write_data),
//     .mem_data_out(mem_out),
//     .DATAMEMControl(DATAMEMControl),
//     .First_2(address[1:0]),
//     .write_data(mem_in),
//     .read_data(read_data)
// );

cache #(DATA_WIDTH,ADDRESS_WIDTH-2,8,3) cache1(
    .address(address[ADDRESS_WIDTH-1:2]),
    .mem_data_in(mem_out),
    .clk(clk),
    .write_enable(write_enable),
    .d_out(cache_out),
    .write_data()
    .mem_address(mem_addr)
);
    
endmodule
