//------------------------------------------------------------------------------
//  FILE : spi_if.sv
//------------------------------------------------------------------------------

interface spi_if(input rst_i);

    logic sck_o;         // serial clock output
    logic mosi_o;        // MasterOut SlaveIN
    logic miso_i;         // MasterIn SlaveOut
    logic cpol;
    logic cpha;

    logic [7:0] miso_data;

endinterface : spi_if
