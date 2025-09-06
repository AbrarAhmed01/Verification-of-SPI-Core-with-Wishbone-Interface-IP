//------------------------------------------------------------------------------
//
// SEQUENCE: base spi sequence - base sequence with objections from which
// all sequences can be derived
//
//------------------------------------------------------------------------------
class spi_seqs extends uvm_sequence #(spi_seq_item);

  // Required macro for sequences automation
  `uvm_object_utils(spi_seqs)

  // Constructor
  function new(string name ="spi_seqs");
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

endclass : spi_seqs



class simple_seqs extends spi_seqs;
    
    // Required macro for sequences automation
    `uvm_object_utils(simple_seqs)

    // Constructor
    function new(string name = "simple_seqs");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing simple sequence", UVM_LOW)
        
        `uvm_do_with(req, {cpol == 0; cpha == 0; mosi == 0;})
    endtask

endclass : simple_seqs


class read_seqs_0_0 extends spi_seqs;
    
    // Required macro for sequences automation
    `uvm_object_utils(read_seqs_0_0)

    // Constructor
    function new(string name = "read_seqs_0_0");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();
        `uvm_info(get_type_name(), "Executing read sequence", UVM_LOW)
        
        `uvm_do_with(req, {cpol == 0; cpha == 0; mosi == 0;})
    endtask

endclass : read_seqs_0_0
