module blockread #(
    parameter DATA_WIDTH=32,BLOCK_SIZE=3
)(
    input logic [S-1:0][DATA_WIDTH-1:0] block,
    input logic [BLOCK_SIZE-1:0] way,
    output logic [DATA_WIDTH-1:0] d_out
);

    parameter S= 2**BLOCK_SIZE;

always_comb d_out = block[way];


endmodule
