module datamemory #(
    parameter   DATA_WIDTH = 32, 
                ADDRESS_WIDTH = 27,
                MEMORY_SIZE = 16,
                BlOCK_SIZE = 3,
                SOURCE_FILE = "datamemory.mem"

)(
    input logic     [ADDRESS_WIDTH-1:0] address,
    input logic     [DATA_WIDTH-1:0]    write_data,
    input logic                         write_enable,
    input logic                         clk,
    output logic    [S-1:0]             read_data
);
    parameter S = DATA_WIDTH*BlOCK_SIZE;
    parameter A_SIZE = MEMORY_SIZE - BlOCK_SIZE;
    logic [DATA_WIDTH-1:0] data_mem [2**MEMORY_SIZE-1:0];
    logic [S-1:0] tmp_data;

    always_comb begin 
        tmp_data = 0;
        for(int i=0;i<BlOCK_SIZE;i++) begin
            tmp_data = {{tmp_data}[S-1:DATA_WIDTH],data_mem[{address[A_SIZE-1:0],{i}[BlOCK_SIZE-1:0]}]}<<DATA_WIDTH;
        end
        read_data = tmp_data;
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
