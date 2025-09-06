//------------------------------------------------------------------------------
//
// CLASS: spi_sequencer
//
//------------------------------------------------------------------------------

class spi_sequencer extends uvm_sequencer #(spi_seq_item);

  `uvm_component_utils(spi_sequencer)

  function new(string name = "spi_sequencer" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Sequencer_class","Inside Constructor", UVM_HIGH)
  endfunction 


	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction



endclass : spi_sequencer