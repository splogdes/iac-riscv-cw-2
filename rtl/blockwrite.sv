module blockwrite #(
    parameter DATA_WIDTH=32,BLOCK_SIZE=3
)(
    input logic [DATA_WIDTH-1:0] d_in,
    input logic [S-1:0][DATA_WIDTH-1:0] block,
    input logic [BLOCK_SIZE-1:0] way,
    output logic [S-1:0][DATA_WIDTH-1:0] block_out
);

    parameter S= 2**BLOCK_SIZE;

always_comb begin
    block_out = block;
    block_out[way] = d_in;
end


endmodule
