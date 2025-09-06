//------------------------------------------------------------------------------
//
// SEQUENCE: base wishbone sequence - base sequence with objections from which
// all sequences can be derived
//
//------------------------------------------------------------------------------
class wishbone_sequence extends uvm_sequence #(wishbone_transaction);

  // Required macro for sequences automation
  `uvm_object_utils(wishbone_sequence)

  // Constructor
  function new(string name ="wishbone_sequence");
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

endclass : wishbone_sequence

class reset_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(reset_seqs)

    // Constructor
    function new(string name = "reset_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing reset sequence", UVM_LOW)
        
        `uvm_create(req)
        req.rst_i = 0;
        `uvm_send(req)

        `uvm_create(req)
        req.rst_i = 1;
        `uvm_send(req)

        `uvm_create(req)
        req.rst_i = 0;
        `uvm_send(req)
    endtask

endclass

//configs the sequence to cpha = 0 and cpol = 0
class config_1_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(config_1_seqs)

    // Constructor
    function new(string name = "config_1_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing config 1 sequence", UVM_LOW)
        
        //setting control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h0;
        req.we_i = 'b1;
        req.dat_i = 'b1110000;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        //setting extension register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b0;
        req.adr_i = 'h3;
        req.we_i = 'b1;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        

    endtask

endclass

//configs the sequence to cpha = 0 and cpol = 0 and SPE to 0
class config_1_spe_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(config_1_spe_seqs)

    // Constructor
    function new(string name = "config_1_spe_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing config 1 spe sequence", UVM_LOW)
        
        //setting control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h0;
        req.we_i = 'b1;
        req.dat_i = 'b1010000;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//configs the sequence to cpha = 0 and cpol = 1
class config_2_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(config_1_seqs)

    // Constructor
    function new(string name = "config_1_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing config 1 sequence", UVM_LOW)
        
        //setting control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h0;
        req.we_i = 'b1;
        req.dat_i = 'b1111000;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        //setting extension register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b0;
        req.adr_i = 'h3;
        req.we_i = 'b1;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//configs the sequence to cpha = 1 and cpol = 0
class config_3_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(config_1_seqs)

    // Constructor
    function new(string name = "config_1_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing config 1 sequence", UVM_LOW)
        
        //setting control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h0;
        req.we_i = 'b1;
        req.dat_i = 'b1110100;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        //setting extension register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b0;
        req.adr_i = 'h3;
        req.we_i = 'b1;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//configs the sequence to cpha = 1 and cpol = 1
class config_4_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(config_1_seqs)

    // Constructor
    function new(string name = "config_1_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing config 1 sequence", UVM_LOW)
        
        //setting control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h0;
        req.we_i = 'b1;
        req.dat_i = 'b1111100;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        //setting extension register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h3;
        req.we_i = 'b1;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        

    endtask

endclass


//sequence to read status register
class read_status_reg_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(read_status_reg_seqs)

    // Constructor
    function new(string name = "read_stat_reg_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing read status register sequence", UVM_LOW)
        
        //reading status register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h1;
        req.we_i = 'b0;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//sequence to write status register
class write_status_reg_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(write_status_reg_seqs)

    // Constructor
    function new(string name = "write_status_reg_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing write status register sequence", UVM_LOW)
        
        //reading status register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h1;
        req.we_i = 'b1;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//sequence to read control register
class read_ctrl_reg_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(read_ctrl_reg_seqs)

    // Constructor
    function new(string name = "read_ctrl_reg_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing read control register sequence", UVM_LOW)
        
        //reading control register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b0;
        req.adr_i = 'h0;
        req.we_i = 'b0;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass


//sequence to read data register
class read_data_reg_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(read_data_reg_seqs)

    // Constructor
    function new(string name = "read_data_reg_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing read data register sequence", UVM_LOW)
        
        //reading data register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b0;
        req.adr_i = 'h2;
        req.we_i = 'b0;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)
        

    endtask

endclass

//sequence to write data register and transmit on mosi
class write_data_reg_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(write_data_reg_seqs)

    // Constructor
    function new(string name = "write_data_reg_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing write data register sequence", UVM_LOW)
        
        //writing data register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h2;
        req.we_i = 'b1;
        req.randomize(dat_i);
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass

//sequence to read data register and received data on miso
class read_data_miso_seqs extends wishbone_sequence;
    
    // Required macro for sequences automation
    `uvm_object_utils(read_data_miso_seqs)

    // Constructor
    function new(string name = "read_data_miso_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing write data miso sequence", UVM_LOW)
        
        //writing data register
        `uvm_create(req)
        req.rst_i = 'b0;
        req.cyc_i = 'b1;
        req.stb_i = 'b1;
        req.adr_i = 'h2;
        req.we_i = 'b0;
        req.dat_i = 'h0;
        req.dat_o = 'h0;
        req.ack_o = 'b0;
        `uvm_send(req)

    endtask

endclass
