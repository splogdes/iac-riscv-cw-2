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
    output logic    [S-1:0]             read_data
);
    parameter S = DATA_WIDTH*(2**BLOCK_SIZE);
    logic [DATA_WIDTH-1:0] data_mem [2**MEMORY_SIZE-1:0];
    logic [S+DATA_WIDTH-1:0] tmp_data;

    always_comb begin 
        tmp_data = 0;
        for(int i=2**BLOCK_SIZE-1;i>=0;i--) begin
            tmp_data = {{tmp_data}[S+DATA_WIDTH-1:DATA_WIDTH],data_mem[{address[MEMORY_SIZE-1:BLOCK_SIZE],{i}[BLOCK_SIZE-1:0]}]}<<DATA_WIDTH;
        end
        read_data = {tmp_data}[S+DATA_WIDTH-1:DATA_WIDTH];
    end

    initial begin
        $display("Loading Data Memory...");
        $readmemh({"./src/generated/",SOURCE_FILE}, data_mem);
        $display("Done loading");
    end;

    always_ff @(posedge clk)
        begin
            if (write_enable == 1'b1) data_mem[{address}[MEMORY_SIZE-1:0]] <= write_data;
        end

endmodule
