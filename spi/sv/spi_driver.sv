//------------------------------------------------------------------------------
//
// CLASS: spi_driver
//
//------------------------------------------------------------------------------

class spi_driver extends uvm_driver #(spi_seq_item);
    `uvm_component_utils(spi_driver)

    virtual interface spi_if vif;
    int num_sent;
    logic [7:0] out;

    function new (string name = "spi_driver" , uvm_component parent);
        super.new(name, parent);
        `uvm_info("Driver_class","Inside Constructor", UVM_HIGH)
        num_sent = 0;
    endfunction : new

    // run_phase
    task run_phase(uvm_phase phase);
    fork
        begin
        	@(posedge vif.rst_i)
			@(negedge vif.rst_i)
            forever begin
                seq_item_port.get_next_item(req);

                `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)

                out = req.miso; 

                if(req.cpol == 0)
                begin
                    void'(this.begin_tr(req, "Driver_SPI_Transaction"));
                  	
                  	vif.miso_i <= out[7];
                  	out = out << 1;
                  	
                    repeat(6)
                    begin
                        @(negedge vif.sck_o);
                        vif.miso_i <= out[7];
                        vif.cpol <= req.cpol;
                        vif.cpha <= req.cpha;
                        vif.miso_data <= req.miso;
                        out = out << 1;
                    end
                    
                    @(negedge vif.sck_o);
                    vif.miso_i <= out[7];
                    @(negedge vif.sck_o);
                    
                end
                
                else if(req.cpol == 1)
                begin
                    void'(this.begin_tr(req, "Driver_SPI_Transaction"));
                    vif.miso_i <= out[7];
                    out = out << 1;
                    repeat(6)
                    begin
                        @(posedge vif.sck_o);
                        vif.miso_i <= out[7];
                        vif.cpol <= req.cpol;
                        vif.cpha <= req.cpha;
                        vif.miso_data <= req.miso;
                        out = out << 1;
                    end
                end
				
				out = 'hx;
                this.end_tr(req);
                num_sent++;

                // Communicate item done to the sequencer
                seq_item_port.item_done();
            end
        end

        begin
            @(posedge vif.rst_i);
            vif.cpol <= 'b0;
            vif.cpha <= 'b0;
            vif.miso_i <= 'hx;
            vif.miso_data <= 'hx;
        end
    join

    endtask : run_phase

    // UVM report_phase
	  function void report_phase(uvm_phase phase);
		  `uvm_info(get_type_name(), $sformatf("Report: SPI driver sent %0d transactions", num_sent), UVM_LOW)
	  endfunction : report_phase

    function void connect_phase(uvm_phase phase);
		if (!spi_vif_config::get(this, "", "vif", vif)) 
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

endclass : spi_driver
