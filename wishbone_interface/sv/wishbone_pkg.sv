package wishbone_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual wishbone_if) wishbone_vif_config;

  `include "../../wishbone_interface/sv/wishbone_transaction.sv"

  `include "../../wishbone_interface/sv/wishbone_monitor.sv"

  `include "../../wishbone_interface/sv/wishbone_sequencer.sv"
  `include "../../wishbone_interface/sv/wishbone_driver.sv"
  `include "../../wishbone_interface/sv/wishbone_agent.sv"
  `include "../../wishbone_interface/sv/wishbone_sequence.sv"

  `include "../../wishbone_interface/sv/wishbone_env.sv"

endpackage : wishbone_pkg
