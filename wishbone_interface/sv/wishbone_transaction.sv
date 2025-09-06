// read write enum parameter
typedef enum bit { WB_READ, WB_WRITE } wishbone_read_write_enum;

//------------------------------------------------------------------------------
//
// CLASS: wishbone_transaction
//
//------------------------------------------------------------------------------

class wishbone_transaction extends uvm_sequence_item;

    bit rst_i;              // reset
    rand bit cyc_i;         // cycle
    rand bit stb_i;         // strobe
    rand bit [2:0] adr_i;    // address
    rand wishbone_read_write_enum we_i;          // write enable
    rand bit [7:0] dat_i;   // data input
    rand bit [7:0] dat_o;   // data output
    rand bit ack_o;         // normal bus termination
    rand bit inta_o;        // interrupt output

    `uvm_object_utils_begin(wishbone_transaction)
        `uvm_field_int(rst_i, UVM_ALL_ON)
        `uvm_field_int(cyc_i, UVM_ALL_ON)
        `uvm_field_int(stb_i, UVM_ALL_ON)
        `uvm_field_int(adr_i, UVM_ALL_ON)
        `uvm_field_enum(wishbone_read_write_enum, we_i, UVM_ALL_ON)
        `uvm_field_int(dat_i, UVM_ALL_ON)
        `uvm_field_int(dat_o, UVM_ALL_ON)
        `uvm_field_int(ack_o, UVM_ALL_ON)
        `uvm_field_int(inta_o, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor - required syntax for UVM automation and utilities
    function new (string name = "wishbone_transaction");
        super.new(name);
    endfunction : new

endclass : wishbone_transaction
