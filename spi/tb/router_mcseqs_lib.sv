class router_simple_mcseq extends uvm_sequence;
  
  	// Required macro for sequences automation
  	`uvm_object_utils(router_simple_mcseq)
	`uvm_declare_p_sequencer(router_mcsequencer)
	
	reset_seqs rst_seqs;
	simple_seqs ss_sqs;
	config_1_seqs config_seqs;
  config_1_spe_seqs config_spe_seqs;
	read_ctrl_reg_seqs read_c_seqs;
	write_data_reg_seqs write_d_reg_seqs;
	read_seqs_0_0 read_seqs;
	read_status_reg_seqs read_s_seqs;
  write_status_reg_seqs write_s_seqs;
	read_data_miso_seqs read_d_miso_seqs;
	
	// Constructor
	function new(string name="router_simple_mcseq");
		super.new(name);
	endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body
  

	virtual task body();
		`uvm_info(get_type_name(), "Executing router_simple_mcseq sequence", UVM_LOW)
		
		//reset test
        `uvm_do_on(rst_seqs, p_sequencer.wb_seqr)
        
        //setting spi core
        `uvm_do_on(config_seqs, p_sequencer.wb_seqr)
        
        //reading control register of spi core
        `uvm_do_on(read_c_seqs, p_sequencer.wb_seqr)
        
        `uvm_do_on(write_d_reg_seqs, p_sequencer.wb_seqr)
        #50;
        //write fifo full and also test for collision

        repeat(5)
        begin
		    `uvm_do_on(write_d_reg_seqs, p_sequencer.wb_seqr)
		   	//`uvm_do_on(read_seqs, p_sequencer.spi_seqr)
		    #20;
		    
		    `uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)
		    end

        //clearing wcol flag of status register
        `uvm_do_on(write_s_seqs, p_sequencer.wb_seqr)

        `uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)

        //configuring SPE bit to 0 than 1
        `uvm_do_on(config_spe_seqs, p_sequencer.wb_seqr)

        `uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)

        `uvm_do_on(config_seqs, p_sequencer.wb_seqr)


        //read fifo full
        repeat(5)
        begin
		    `uvm_do_on(write_d_reg_seqs, p_sequencer.wb_seqr)
		   	`uvm_do_on(read_seqs, p_sequencer.spi_seqr)
		    
		    `uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)
		    end

        //read fifo empty
        repeat(5)
        begin
        	`uvm_do_on(read_d_miso_seqs, p_sequencer.wb_seqr)
        	`uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)
        end
		
	    	//concurrent read and write test		
		  fork
	      `uvm_do_on(write_d_reg_seqs, p_sequencer.wb_seqr)
	      `uvm_do_on(read_seqs, p_sequencer.spi_seqr)
	    join
	    
        `uvm_do_on(read_s_seqs, p_sequencer.wb_seqr)
        `uvm_do_on(read_d_miso_seqs, p_sequencer.wb_seqr)
        `uvm_do_on(config_seqs, p_sequencer.wb_seqr)
        
  	endtask


  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : router_simple_mcseq
