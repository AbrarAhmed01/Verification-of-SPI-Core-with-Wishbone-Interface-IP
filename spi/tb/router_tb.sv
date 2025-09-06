class router_tb extends uvm_env;
	
  	spi_env spi_uvc;
	wishbone_env wb_uvc;
	router_mcsequencer mc_seqr;

	router_module_environment router_module_uvc;

	`uvm_component_utils_begin(router_tb)
		`uvm_field_object(spi_uvc, UVM_ALL_ON)
		`uvm_field_object(wb_uvc, UVM_ALL_ON)
		`uvm_field_object(mc_seqr, UVM_ALL_ON)
	`uvm_component_utils_end
  	
	// constructor
  	function new(string name = "router_tb" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Testbench_class","Inside Constructor", UVM_HIGH)
    
  	endfunction
  
	//build phase
  	function void build_phase(uvm_phase phase);  //obj handle of uvm_phase
    	super.build_phase(phase);

    	spi_uvc = spi_env::type_id::create("spi_uvc", this);
		wb_uvc = wishbone_env::type_id::create("wb_uvc", this);
		
		mc_seqr = router_mcsequencer::type_id::create("mc_seqr", this);

		router_module_uvc = router_module_environment::type_id::create("router_module_uvc", this);
		
    	`uvm_info("router_tb","Build phase", UVM_HIGH)      

  	endfunction
  	
  	function void connect_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Connecting the Sequencer and the ports...", UVM_HIGH);
  		
  		mc_seqr.wb_seqr = wb_uvc.agent.sequencer;
  		mc_seqr.spi_seqr = spi_uvc.agent.sequencer;

		spi_uvc.agent.monitor.spi_out.connect(router_module_uvc.spi_export_port);
  		wb_uvc.agent.monitor.wishbone_out.connect(router_module_uvc.wishbone_export_port);
  		
  		`uvm_info(get_type_name(), "Connection Complete", UVM_HIGH);
	endfunction
  	
	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction
  
endclass : router_tb
