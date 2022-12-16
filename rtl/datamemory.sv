module datamemory #(
    parameter   DATA_WIDTH = 32, 
                ADDRESS_WIDTH = 30,
                MEMORY_SIZE = 16,
                BLOCK_SIZE = 3,
                SOURCE_FILE = "datamemory.mem"

)(
    input logic     [ADDRESS_WIDTH-1:0] address,
    input logic     [DATA_WIDTH-1:0]    write_data,
    input logic                         write_enable,
    input logic                         clk,
    output logic   [S-1:0][DATA_WIDTH-1:0]      read_data
);
    parameter S = 2**BLOCK_SIZE;
    logic [S-1:0][DATA_WIDTH-1:0] write_block;

    logic [S-1:0][3:0][DATA_WIDTH/4-1:0] data_mem [2**(MEMORY_SIZE-BLOCK_SIZE)-1:0];

    always_comb read_data = data_mem[address[MEMORY_SIZE-1:BLOCK_SIZE]];

    blockwrite #(DATA_WIDTH,BLOCK_SIZE) writedatamem(
        .d_in(write_data),
        .block(read_data),
        .way(address[BLOCK_SIZE-1:0]),
        .block_out(write_block)
    );

    initial begin
        $display("Loading Data Memory...");
        $readmemh({"./rtl/datamemory/",SOURCE_FILE},data_mem,'h1000);
        $display("Done loading");
    end;

    always_ff @(negedge clk) if (write_enable == 1) data_mem[{address}[MEMORY_SIZE-1:BLOCK_SIZE]] <= write_block;

endmodule
