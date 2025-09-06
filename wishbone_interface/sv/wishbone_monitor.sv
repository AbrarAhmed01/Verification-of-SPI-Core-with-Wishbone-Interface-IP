//------------------------------------------------------------------------------
//
// CLASS: wishbone_monitor
//
//------------------------------------------------------------------------------

class wishbone_monitor extends uvm_monitor;
    `uvm_component_utils(wishbone_monitor)

    uvm_analysis_port #(wishbone_transaction) wishbone_out;
	
	virtual interface wishbone_if vif;
    int num_tran_col;

    // Collected Data handle
  	wishbone_transaction wb_trans;

    //covergroup cover_transaction
    covergroup cover_transaction;
        option.per_instance = 0;
        reset : coverpoint wb_trans.rst_i;
        valid_cycle : coverpoint wb_trans.cyc_i;
        core_strobe_select : coverpoint wb_trans.stb_i;
        address : coverpoint wb_trans.adr_i;
        read_write_enable : coverpoint wb_trans.we_i;
        data_in : coverpoint wb_trans.dat_i{
            bins data = {[0:255]};
        }
        data_out : coverpoint wb_trans.dat_o{
            bins out = {[0:255]};
        }
        normal_bus_termination : coverpoint wb_trans.ack_o;
        interrupt_request : coverpoint wb_trans.inta_o;
    endgroup : cover_transaction


  	function new(string name = "wishbone_monitor" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Monitor_class","Inside Constructor", UVM_HIGH)
    	wishbone_out = new("wishbone_out", this);
        cover_transaction.set_inst_name({get_full_name(), ".cover_transaction"});
  	endfunction


    // UVM run() phase
	task run_phase(uvm_phase phase);
        @(negedge vif.rst_i)
        forever begin
            wb_trans = wishbone_transaction::type_id::create("wb_trans", this);
            
            // concurrent blocks for packet collection and transaction recording
            fork
                begin
                @(negedge vif.clk_i)
                void'(begin_tr(wb_trans, "Monitor_WISHBONE_Transaction"));
                wb_trans.rst_i <= vif.rst_i;
                wb_trans.cyc_i <= vif.cyc_i;         
                wb_trans.stb_i <= vif.stb_i;         
                wb_trans.adr_i <= vif.adr_i;   
                wb_trans.we_i <= vif.we_i;        
                wb_trans.dat_i <= vif.dat_i;

                @(posedge vif.clk_i)
                wb_trans.dat_o <= vif.dat_o; 
                wb_trans.ack_o <= vif.ack_o;       
                wb_trans.inta_o <= vif.inta_o;
                end
            join
            
            end_tr(wb_trans);
            `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", wb_trans.sprint()), UVM_LOW)

            perform_coverage();
            
            wishbone_out.write(wb_trans);
            num_tran_col++;
        end
    endtask : run_phase

    // Triggers coverage events and fill cover fields
    virtual protected function void perform_coverage();
        cover_transaction.sample();
    endfunction : perform_coverage

    // UVM report_phase
	function void report_phase(uvm_phase phase);
		num_tran_col = num_tran_col/3;
		`uvm_info(get_type_name(), $sformatf("Report: Wishbone Monitor Collected %0d Transactions", num_tran_col), UVM_LOW)
	endfunction : report_phase

	function void connect_phase(uvm_phase phase);
		if (!wishbone_vif_config::get(this, "", "vif", vif)) 
		begin
			`uvm_error("NOVIF", "Monitor: vif not set")
		end

		else 
		begin
			`uvm_info("VIFSET", "Monitor: vif successfully set", UVM_LOW)
		end

  	endfunction
  	
	function void start_of_simulation_phase(uvm_phase phase);
  		`uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH);
	endfunction

endclass : wishbone_monitor
