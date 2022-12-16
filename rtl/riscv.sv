module riscv #(
    parameter BITNESS = 32,
    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
) (
    input logic rst_i,
    /* verilator lint_off UNUSED */
    // not using int_i for anything just yet
    input logic int_i,
    /* verilator lint_on UNUSED */
    input logic clk_i,
    output logic [7:0] data_out_o
);

logic [BITNESS-1:0] rd1_d, rd1_e, alu_src_b, rd2_d, rd2_e;

cdl #(BITNESS) cdl_rd2_d_e (
    .clk_i(clk_i),
    .signal_i(rd2_d),
    .delayed_o(rd2_e)
);

cdl #(BITNESS) cdl_rd1_d_e (
    .clk_i(clk_i),
    .signal_i(rd1_d),
    .delayed_o(rd1_e)
);

logic [BITNESS-1:0] writedata_m;

cdl #(BITNESS) cdl_rd2_e_writedata_m (
    .clk_i(clk_i),
    .signal_i(rd2_e),
    .delayed_o(writedata_m)
);



logic [BITNESS-1:0] pc;

logic [INSTR_WIDTH-1:0] instr_read;

logic [INSTR_WIDTH-1:0] instr_d;

cdl #(INSTR_WIDTH) cdl_instr_read_d (
    .clk_i(clk_i),
    .signal_i(instr_read),
    .delayed_o(instr_d)
);

logic regwrite_d;

logic regwrite_e;

cdl #() cdl_regwrite_d_e (
    .clk_i(clk_i),
    .signal_i(regwrite_d),
    .delayed_o(regwrite_e)
);

logic regwrite_m;

cdl #() cdl_regwrite_e_m (
    .clk_i(clk_i),
    .signal_i(regwrite_e),
    .delayed_o(regwrite_m)
);

logic regwrite_w;

cdl #() cdl_regwrite_m_w (
    .clk_i(clk_i),
    .signal_i(regwrite_m),
    .delayed_o(regwrite_w)
);

logic alusrc_d;

logic alusrc_e;

cdl #() cdl_alusrc_d_e (
    .clk_i(clk_i),
    .signal_i(alusrc_d),
    .delayed_o(alusrc_e)
);

logic [2:0] immsrc;

logic [BITNESS-1:0] result;

/* verilator lint_off UNUSED */
// we keep some bits of a0 unused in case we want to use it as a debug output or similar: there is no disadvantage to having it exposed to the main module
logic [BITNESS-1:0] a0;
/* verilator lint_on UNUSED */

logic [BITNESS-1:0] immext_d, immext_e;

cdl #(BITNESS) cdl_immext_d_e (
    .clk_i(clk_i),
    .signal_i(immext_d),
    .delayed_o(immext_e)
);

logic [2:0] alu_ctrl_d;

logic [2:0] alu_ctrl_e;

cdl #(3) cdl_alu_ctrl_d_e (
    .clk_i(clk_i),
    .signal_i(alu_ctrl_d),
    .delayed_o(alu_ctrl_e)
);

logic [BITNESS-1:0] aluresult_e, aluresult_m, aluresult_w;

cdl #(BITNESS) cdl_aluresult_e_m (
    .clk_i(clk_i),
    .signal_i(aluresult_e),
    .delayed_o(aluresult_m)
);


cdl #(BITNESS) cdl_aluresult_m_w (
    .clk_i(clk_i),
    .signal_i(aluresult_m),
    .delayed_o(aluresult_w)
);

logic alu_eq_e;

wire [1:0] pcsrc;

logic [1:0] resultsrc_d;

logic [1:0] resultsrc_e;

cdl #(2) cdl_resultsrc_d_e (
    .clk_i(clk_i),
    .signal_i(resultsrc_d),
    .delayed_o(resultsrc_e)
);

logic [1:0] resultsrc_m;

cdl #(2) cdl_resultsrc_e_m (
    .clk_i(clk_i),
    .signal_i(resultsrc_e),
    .delayed_o(resultsrc_m)
);

logic [1:0] resultsrc_w;

cdl #(2) cdl_resultsrc_m_w (
    .clk_i(clk_i),
    .signal_i(resultsrc_m),
    .delayed_o(resultsrc_w)
);

logic memwrite_d;

logic memwrite_e;

cdl #() cdl_memwrite_d_e (
    .clk_i(clk_i),
    .signal_i(memwrite_d),
    .delayed_o(memwrite_e)
);

logic memwrite_m;

cdl #() cdl_memwrite_e_m (
    .clk_i(clk_i),
    .signal_i(memwrite_e),
    .delayed_o(memwrite_m)
);


logic [BITNESS-1:0] readdata_m, readdata_w;

cdl #(BITNESS) cdl_readdata_m_w (
    .clk_i(clk_i),
    .signal_i(readdata_m),
    .delayed_o(readdata_w)
);

wire  instr_funct7_5  = instr_d[30];

wire [2:0] instr_funct3  = instr_d[14:12];

wire [6:0] instr_op = instr_d[6:0];

wire [BITNESS-1:0] pcplus4_f, pcplus4_d, pcplus4_e, pcplus4_m, pcplus4_w;

cdl #(BITNESS) cdl_pcplus4_f_d (
    .clk_i(clk_i),
    .signal_i(pcplus4_f),
    .delayed_o(pcplus4_d)
);

cdl #(BITNESS) cdl_pcplus4_d_e (
    .clk_i(clk_i),
    .signal_i(pcplus4_d),
    .delayed_o(pcplus4_e)
);

cdl #(BITNESS) cdl_pcplus4_e_m (
    .clk_i(clk_i),
    .signal_i(pcplus4_e),
    .delayed_o(pcplus4_m)
);

cdl #(BITNESS) cdl_pcplus4_m_w (
    .clk_i(clk_i),
    .signal_i(pcplus4_m),
    .delayed_o(pcplus4_w)
);

wire [REG_ADDR_WIDTH-1:0] rd_d = instr_d[11:7];

logic [REG_ADDR_WIDTH-1:0] rd_e, rd_m, rd_w;

cdl #(REG_ADDR_WIDTH) cdl_rd_d_e (
    .clk_i(clk_i),
    .signal_i(rd_d),
    .delayed_o(rd_e)
);

cdl #(REG_ADDR_WIDTH) cdl_rd_e_m (
    .clk_i(clk_i),
    .signal_i(rd_e),
    .delayed_o(rd_m)
);

cdl #(REG_ADDR_WIDTH) cdl_rd_m_w (
    .clk_i(clk_i),
    .signal_i(rd_m),
    .delayed_o(rd_w)
);


always_comb begin
    data_out_o = a0[7:0];

    if (alusrc_e == 1'b1)
        alu_src_b = immext_e;
    else if (alusrc_e == 1'b0)
        alu_src_b = rd2_e;
    //else if (alusrc_e == 2'b10)
        //alu_src_b = PCplus4;
    else
        alu_src_b = 'b1111111;

    if (resultsrc_w == 2'b00)
        result = readdata_w;
    else if (resultsrc_w == 2'b01)
        result = aluresult_w;
    else if (resultsrc_w == 2'b10)
        result = pcplus4_w; //JAL/JALR return storage
    else if (resultsrc_w == 2'b11)
        result = immext_e;
    else
        result = 'b1111111;//Shouldn't happen

end;

/* verilator lint_off PINMISSING */
// need this for unused count pin
programcounter #() programcounter (
    .ImmOp(immext_e),
    .clk(clk_i),
    .PCsrc(pcsrc),
    .rst(rst_i),
    .pc(pc),
    .pcplus4(pcplus4_f),
    .ALUresult (aluresult_e)
);
/* verilator lint_on PINMISSING */


instructionmemory #(BITNESS, INSTR_WIDTH, "instructionmemory.tmp.mem") instructionmemory (
    .addr_i(pc),
    .data_o(instr_read)
);

alu #(BITNESS,3) alu (
    .op1(rd1_e),
    .op2(alu_src_b),
    .ctrl(alu_ctrl_e),
    .aluout(aluresult_e),
    .zero(alu_eq_e)
);

regfile #(BITNESS, REG_ADDR_WIDTH) registerfile(
    .clk(clk_i),
    .we3(regwrite_w),
    .a1(instr_d[19:15]),
    .a2(instr_d[24:20]),
    .a3(rd_w),
    .wd3(result),
    .rd1(rd1_d),
    .rd2(rd2_d),
    .a0(a0)
);

datamemory #() datamemory(
    .address(aluresult_m),
    .write_data(writedata_m),
    .write_enable(memwrite_m),
    .DATAMEMControl(instr_funct3),
    .clk(clk_i),
    .read_data(readdata_m)
);

controlUnit #() controlunit(
    .clk_i(clk_i),
    .funct3(instr_funct3),
    .funct7_5(instr_funct7_5),
    .zero(alu_eq_e),
    .op(instr_op),
    .PCSrc(pcsrc),
    .ResultSrc(resultsrc_d),
    .RegWrite(regwrite_d),
    .ALUControl(alu_ctrl_d),
    .ALUSrc(alusrc_d),
    .ImmSrc(immsrc),
    .MemWrite(memwrite_d)
);

signextend #() signextend(
    .toextend_i(instr_d[31:7]),
    .immsrc_i(immsrc),
    .immop_o(immext_d)
);


endmodule
