module riscv #(
    parameter BITNESS = 32,
    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
) (
    input logic rst_i,
    input logic int_i,
    input logic clk_i,
    output logic [7:0] data_out_o
);

logic [BITNESS-1:0] alu_src_a, alu_src_b, regfile_d2;

logic [BITNESS-1:0] pc;

logic [INSTR_WIDTH-1:0] instr;

logic regwrite;

logic alusrc;

logic [1:0] immsrc;

logic [BITNESS-1:0] result;

logic [BITNESS-1:0] a0;

logic [BITNESS-1:0] immext;

logic [2:0] alu_ctrl;

logic [BITNESS-1:0] aluresult;

logic alu_eq;

logic pcsrc;


always_comb begin
    data_out_o = a0[7:0];

    if (alusrc)
        alu_src_b = immext;
    else 
        alu_src_b = regfile_d2;
end;

/* verilator lint_off PINMISSING */
// need this for unused count pin
programcounter #() programcounter (
    .ImmOp(immext),
    .clk(clk_i),
    .PCsrc(pcsrc),
    .rst(rst_i),
    .pc(pc)
);
/* verilator lint_on PINMISSING */

instructionmemory #(BITNESS, INSTR_WIDTH) instructionmemory (
    .clk_i(clk_i),
    .addr_i(pc),
    .dout_o(instr)
);

alu #(BITNESS,3) alu (
    .op1(alu_src_a),
    .op2(alu_src_b),
    .ctrl(alu_ctrl),
    .aluout(aluresult),
    .zero(alu_eq)
);

regfile #(BITNESS, REG_ADDR_WIDTH) registerfile(
    .clk(clk_i),
    .we3(regwrite),
    .a1(instr[19:15]),
    .a2(instr[24:20]),
    .a3(instr[11:7]),
    .wd3(result),
    .rd1(alu_src_a),
    .rd2(regfile_d2),
    .a0(a0)
);

// todo: datamemory

controlunit #() controlunit(
    .eq(alu_eq),
    .instr(instr),
    .PCsrc(pcsrc),
    //.ResultSrc(ResultSrc),
    .RegWrite(regwrite),
    .ALUctrl(alu_ctrl),
    .ALUsrc(alusrc),
    .ImmSrc(immsrc)
);

signextend #() signextend(
    .imm(instr[31:7]),
    .immop(immext)
);

endmodule
