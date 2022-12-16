module programcounter #(
    parameter                                   DATA_WIDTH = 32
)(
    input logic     [DATA_WIDTH-1:0]            ImmOp,
    input logic                                 clk,
    input logic        [1:0]                    PCsrc,
    input logic                                 rst,
    input logic     [DATA_WIDTH-1:0]            ALUresult,
    output logic    [DATA_WIDTH-1:0]            pc,
    output logic    [DATA_WIDTH-1:0]            pcplus4
);

    logic [DATA_WIDTH-1:0] pc_d;
    
    cdl #(DATA_WIDTH) cdl_pc_pc_d (
        .clk_i(clk),
        .signal_i(pc),
        .delayed_o(pc_d)
    );

    logic [DATA_WIDTH-1:0] pc_e;

    cdl #(DATA_WIDTH) cdl_pc_d_e (
        .clk_i(clk),
        .signal_i(pc_d),
        .delayed_o(pc_e)
    );

    always_comb pcplus4 = {pc + 4}[DATA_WIDTH-1:0];

    always_ff @(negedge clk)
        begin
        if (rst == 1'b1)            pc <= 'b0; //Reset PC
        else if (PCsrc == 2'b01)    pc <= {pc_e + ImmOp}[DATA_WIDTH-1:0]; //B-type generic and JAL
        else if (PCsrc == 2'b10)    pc <= ALUresult; //JALR
        else                        pc <= pcplus4; //Increment PC by 4
        end
        
endmodule
