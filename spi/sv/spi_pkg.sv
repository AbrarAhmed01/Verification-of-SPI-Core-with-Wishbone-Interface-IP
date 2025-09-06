package spi_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual spi_if) spi_vif_config;

  `include "spi_seq_item.sv"

  `include "spi_monitor.sv"

  `include "spi_sequencer.sv"
  `include "spi_driver.sv"
  `include "spi_agent.sv"
  `include "spi_seqs.sv"

  `include "spi_env.sv"

endpackage : spi_pkg