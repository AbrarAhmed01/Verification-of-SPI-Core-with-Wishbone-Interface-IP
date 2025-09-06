class router_mcsequencer extends uvm_sequencer;

  	spi_sequencer spi_seqr;
	wishbone_sequencer wb_seqr;

	`uvm_component_utils_begin(router_mcsequencer)
		`uvm_field_object(spi_seqr, UVM_ALL_ON)
		`uvm_field_object(wb_seqr, UVM_ALL_ON)
	`uvm_component_utils_end
  	
	// constructor
  	function new(string name = "router_mcsequencer" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Multichannel Sequencer Class","Inside Constructor", UVM_HIGH)
  
  	endfunction
  
endclass : router_mcsequencer
