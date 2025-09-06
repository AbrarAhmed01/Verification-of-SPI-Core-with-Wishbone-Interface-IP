//------------------------------------------------------------------------------
//
// CLASS: wishbone_env
//
//------------------------------------------------------------------------------
class wishbone_env extends uvm_env;
	`uvm_component_utils(wishbone_env)
	
	wishbone_agent agent;

	function new(string name = "wishbone_env" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Env_class","Inside Constructor", UVM_HIGH)
  	endfunction
  	
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	agent = wishbone_agent::type_id::create("agent", this);

  	endfunction
  	
  	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction

endclass : wishbone_env