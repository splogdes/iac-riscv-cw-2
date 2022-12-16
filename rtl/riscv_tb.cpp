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

  if(vbdOpen() != 1) return(-1);
  vbdHeader("F1 LIGHTS");
 
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

  while (count < 100000) {
    count++;
    top->clk_i = !top->clk_i;
    top->eval();
    tfp->dump(count);
    top->int_i = vbdFlag();

    vbdCycle(count);
    vbdBar(top->data_out_o & 0xFF);
    if (Verilated::gotFinish()) exit(0);
  };

  tfp->close();
  top->final();
  exit(0);
}