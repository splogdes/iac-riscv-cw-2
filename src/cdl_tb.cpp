#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcdl.h"

#include "lib/testutils.h"

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vcdl* top = new Vcdl;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("cdl.vcd");
 
  top->signal_i = 0;
  top->clk_i=1;
  top->eval();

  assert_message(top->delayed_o == 0, "Set signal_i to 0 and clocked but delayed_o was %d", top->delayed_o);

  top->clk_i=0;
  top->eval();

  top->signal_i = 1;
  top->eval();
  assert_message(top->delayed_o == 0, "Set signal_i to 1 and did not clock but delayed_o was %d", top->delayed_o);

  top->clk_i=1;
  top->eval();
  assert_message(top->delayed_o == 1, "Set signal_i to 1 and clocked but delayed_o was %d", top->delayed_o);

  tfp->close(); 
  exit(0);
}