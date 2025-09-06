//------------------------------------------------------------------------------
//
// CLASS: spi_monitor
//
//------------------------------------------------------------------------------

class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    uvm_analysis_port #(spi_seq_item) spi_out;
	
	virtual interface spi_if vif;
    int num_tran_col;
    logic [7:0] in;

    // Collected Data handle
  	spi_seq_item spi_item;

    //covergroup cover_item
    covergroup cover_item;
        option.per_instance = 0;
        miso : coverpoint spi_item.miso;
        mosi : coverpoint spi_item.mosi;
        cpha : coverpoint spi_item.cpha;
        cpol : coverpoint spi_item.cpol;
    endgroup : cover_item


  	function new(string name = "spi_monitor" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Monitor_class","Inside Constructor", UVM_HIGH)
    	spi_out = new("spi_out", this);
        cover_item.set_inst_name({get_full_name(), ".cover_item"});
  	endfunction


    // UVM run() phase
	task run_phase(uvm_phase phase);
        @(posedge vif.rst_i)
		@(negedge vif.rst_i)
        forever begin
            spi_item = spi_seq_item::type_id::create("spi_item", this);
           
                if(vif.cpha == 0)
                begin
                    void'(begin_tr(spi_item, "Monitor_SPI_Transaction"));
                    
                    repeat(8)
                    begin
                        @(posedge vif.sck_o);
                        in[0] <= vif.mosi_o;
                        spi_item.cpha <= vif.cpha;
                        spi_item.cpol <= vif.cpol;
                        spi_item.miso <= vif.miso_data;
                        in = in << 1;
                    end
                    @(posedge vif.sck_o);
                    in[0] <= vif.mosi_o;
                    spi_item.mosi = in;

                end

                else if(vif.cpha == 1)
                begin
                    void'(begin_tr(spi_item, "Monitor_SPI_Transaction"));
                    repeat(8)
                    begin
                        @(negedge vif.sck_o);
                        in[0] <= vif.mosi_o;
                        spi_item.cpha <= vif.cpha;
                        spi_item.cpol <= vif.cpol;
                        spi_item.miso <= vif.miso_data;
                        in = in << 1;
                    end
                    @(posedge vif.sck_o);
                    in[0] <= vif.mosi_o;
                    spi_item.mosi = in;
                end

            end_tr(spi_item);
            `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", spi_item.sprint()), UVM_LOW)

            perform_coverage();
            
            spi_out.write(spi_item);
            num_tran_col++;
        end
    endtask : run_phase

    // Triggers coverage events and fill cover fields
    virtual protected function void perform_coverage();
        cover_item.sample();
    endfunction : perform_coverage

    // UVM report_phase
	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("Report: Spi Monitor Collected %0d Transactions", num_tran_col), UVM_LOW)
	endfunction : report_phase

	function void connect_phase(uvm_phase phase);
		if (!spi_vif_config::get(this, "", "vif", vif)) 
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

endclass : spi_monitor
