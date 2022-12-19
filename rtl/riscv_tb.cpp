#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vriscv.h"
#include "vbuddy.cpp"

#include "lib/testutils.h"

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vriscv* top = new Vriscv;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("riscv.vcd");
  if (vbdOpen()!=1) return(-1);
  vbdHeader("refrence");
  vbdCycle(0);
  top->clk_i = 0;
  top->rst_i = 0;
  int count = 0;

  top->eval();
  tfp->dump(count++);
  count++;

  top->rst_i = 1;
  top->eval();
  tfp->dump(count);
  count++;

  top->rst_i = 0;
  top->eval();
  tfp->dump(count);
  count++;

  while (top->data_out_o != 5) {
    count++;
    top->clk_i = !top->clk_i;
    top->eval();
  };
  count =4;
  while (count < 1)
  {
    vbdPlot(int(top->data_out_o), 0, 255);
    vbdCycle(count-4);
    count++;
    top->clk_i = !top->clk_i;
    top->eval();
    tfp->dump(count);
    if (Verilated::gotFinish()||vbdGetkey()=='q') exit(0);
  }
  
  vbdClose();
  tfp->close();
  top->final();
  exit(0);
}