//------------------------------------------------------------------------------
//
// CLASS: spi_env
//
//------------------------------------------------------------------------------
class spi_env extends uvm_env;
	`uvm_component_utils(spi_env)
	
	spi_agent agent;

	function new(string name = "spi_env" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Env_class","Inside Constructor", UVM_HIGH)
  	endfunction
  	
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	agent = spi_agent::type_id::create("agent", this);

  	endfunction
  	
  	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction

endclass : spi_env