//------------------------------------------------------------------------------
//
// CLASS: wishbone_sequencer
//
//------------------------------------------------------------------------------

class wishbone_sequencer extends uvm_sequencer #(wishbone_transaction);

  `uvm_component_utils(wishbone_sequencer)

  function new(string name = "wishbone_sequencer" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Sequencer_class","Inside Constructor", UVM_HIGH)
  endfunction 


	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction



endclass : wishbone_sequencer