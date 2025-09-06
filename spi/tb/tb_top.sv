module tb_top;
	// import the UVM library
	import uvm_pkg::*;

	
	// include the UVM macros
	`include "uvm_macros.svh"
	
	// import the YAPP package
	import spi_pkg::*;

	import wishbone_pkg::*;
	
	`include "router_mcsequencer.sv"
	`include "router_mcseqs_lib.sv"
	`include "../sv/spi_scoreboard.sv"
	`include "../sv/router_module_env.sv"
	`include "router_tb.sv"
	`include "router_test_lib.sv"
	
	
	// generate 5 random packets and use the print method
	initial
	begin
		spi_vif_config::set(null, "*.tb.spi_uvc.*", "vif", hw_top.in0);
		wishbone_vif_config::set(null, "*.tb.wb_uvc.*", "vif", hw_top.wb_intf);

  		run_test();
    	
	end
	
	
endmodule : top
