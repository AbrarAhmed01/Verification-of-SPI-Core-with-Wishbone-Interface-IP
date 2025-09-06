//------------------------------------------------------------------------------
//
// CLASS: wishbone_driver
//
//------------------------------------------------------------------------------

class wishbone_driver extends uvm_driver #(wishbone_transaction);
    `uvm_component_utils(wishbone_driver)

    virtual interface wishbone_if vif;
    int num_sent;

    function new (string name = "wishbone_driver" , uvm_component parent);
        super.new(name, parent);
        `uvm_info("Driver_class","Inside Constructor", UVM_HIGH)
        num_sent = 0;
    endfunction : new

    // run_phase
    task run_phase(uvm_phase phase);

    forever begin
        seq_item_port.get_next_item(req);

        `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
        
        @(negedge vif.clk_i);
        void'(this.begin_tr(req, "Driver_WISHBONE_Transaction"));
        vif.rst_i <= req.rst_i;
        vif.cyc_i <= req.cyc_i;         
        vif.stb_i <= req.stb_i;         
        vif.adr_i <= req.adr_i;   
        vif.we_i <= req.we_i;        
        vif.dat_i <= req.dat_i; 
        //vif.dat_o <= req.dat_o;   
        //vif.ack_o <= req.ack_o;       
        //vif.inta_o <= req.inta_o;
		
        this.end_tr(req);
        num_sent++;

        // Communicate item done to the sequencer
        seq_item_port.item_done();
    end

    endtask : run_phase

    // UVM report_phase
	  function void report_phase(uvm_phase phase);
		  `uvm_info(get_type_name(), $sformatf("Report: Wishbone driver sent %0d transactions", num_sent), UVM_LOW)
	  endfunction : report_phase

    function void connect_phase(uvm_phase phase);
		if (!wishbone_vif_config::get(this, "", "vif", vif)) 
		begin
			`uvm_error("NOVIF", "Driver: vif not set")
		end

		else 
		begin
			`uvm_info("VIFSET", "Driver: vif successfully set", UVM_LOW)
		end
		
    endfunction :connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	  endfunction

endclass : wishbone_driver
