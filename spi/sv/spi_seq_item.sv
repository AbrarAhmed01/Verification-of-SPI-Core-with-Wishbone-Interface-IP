//------------------------------------------------------------------------------
//
// CLASS: spi_seq_item
//
//------------------------------------------------------------------------------

class spi_seq_item extends uvm_sequence_item;

    rand bit cpol;              // clock polarity
    rand bit cpha;              // clock phase
    rand bit [7:0] mosi;   // master out slave in data
    rand bit [7:0] miso;   // master in slave out data

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_int(cpol, UVM_ALL_ON)
        `uvm_field_int(cpha, UVM_ALL_ON)
        `uvm_field_int(mosi, UVM_ALL_ON)
        `uvm_field_int(miso, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor - required syntax for UVM automation and utilities
    function new (string name = "spi_seq_item");
        super.new(name);
    endfunction : new

endclass : spi_seq_item
