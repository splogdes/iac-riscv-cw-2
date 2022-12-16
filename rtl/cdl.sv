module cdl #(
    parameter DATA_WIDTH = 1
) (
//Inputs
    input logic clk_i,
    input logic [DATA_WIDTH-1:0] signal_i,
    output logic [DATA_WIDTH-1:0] delayed_o
);


always_ff @(posedge clk_i) begin
    delayed_o <= signal_i;
end

endmodule
