//------------------------------------------------------------------------------
//
// CLASS: router_module_environment
//
//------------------------------------------------------------------------------
class router_module_environment extends uvm_env;
	spi_scoreboard scoreboard;
	
	/////////////////////PORTS DECLARATIONS//////////////////
	uvm_analysis_export#(spi_seq_item) spi_export_port;
	
	uvm_analysis_export#(wishbone_transaction) wishbone_export_port;
	
	///////////////////////////////////////////////////////////
	
	`uvm_component_utils_begin(router_module_environment)
		`uvm_field_object(scoreboard, UVM_ALL_ON)
	`uvm_component_utils_end
	
	function new(string name = "router_module_environment" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("UVC_class","Inside Constructor", UVM_HIGH)

    	spi_export_port = new("spi_export_port", this);
    	
    	wishbone_export_port = new("wishbone_export_port", this);
    	
  	endfunction
  	
  	//build phase
  	function void build_phase(uvm_phase phase);  //obj handle of uvm_phase
    	super.build_phase(phase);
		
		scoreboard = spi_scoreboard::type_id::create("scoreboard", this);
    	
    	`uvm_info("router_module_environment","Build phase", UVM_HIGH)      

  	endfunction
  	
	
	function void connect_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Connecting the router module UVC...", UVM_HIGH);
  		
  		spi_export_port.connect(scoreboard.spi_fifo.analysis_export);
  		wishbone_export_port.connect(scoreboard.wishbone_fifo.analysis_export);
  		
  		`uvm_info(get_type_name(), "Connection Complete", UVM_HIGH);
	endfunction


endclass : router_module_environment
