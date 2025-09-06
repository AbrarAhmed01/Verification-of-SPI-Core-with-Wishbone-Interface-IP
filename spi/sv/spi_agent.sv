//------------------------------------------------------------------------------
//
// CLASS: spi_agent
//
//------------------------------------------------------------------------------

class spi_agent extends uvm_agent;

    // This field determines whether an agent is active or passive.
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    spi_monitor    monitor;
    spi_driver     driver;
    spi_sequencer  sequencer;

    `uvm_component_utils_begin(spi_agent)
        `uvm_field_object(monitor, UVM_ALL_ON)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name = "spi_agent" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Agent_class","Inside Constructor", UVM_HIGH)
  	endfunction

    virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor = spi_monitor::type_id::create("monitor", this);
		
		if (is_active == UVM_ACTIVE) 
		begin
		  	driver = spi_driver::type_id::create("driver", this);
		  	sequencer = spi_sequencer::type_id::create("sequencer", this);
		end
		
	endfunction

    virtual function void connect_phase(uvm_phase phase);
  		super.connect_phase(phase);
  		
  		if (is_active == UVM_ACTIVE) 
  		begin
    		driver.seq_item_port.connect(sequencer.seq_item_export);
  		end
  		
	endfunction
	
	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction

endclass : spi_agent