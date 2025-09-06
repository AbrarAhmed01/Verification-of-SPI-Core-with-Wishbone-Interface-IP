//------------------------------------------------------------------------------
//
// MODULE: hw_top
//
//------------------------------------------------------------------------------
module hw_top;

  logic         clk_i;

  // YAPP Interface to the DUT
  spi_if in0(wb_intf.rst_i);

  wishbone_if wb_intf(clk_i);

  clkgen clkgen (
    .clock(clk_i)
  );

  simple_spi dut(
    // 8bit WISHBONE bus slave interface
    .clk_i(clk_i),            // clock
    .rst_i(wb_intf.rst_i),    // reset
    .cyc_i(wb_intf.cyc_i),    // cycle
    .stb_i(wb_intf.stb_i),    // strobe
    .adr_i(wb_intf.adr_i),    // address
    .we_i(wb_intf.we_i),      // write enable
    .dat_i(wb_intf.dat_i),    // data input
    .dat_o(wb_intf.dat_o),    // data output
    .ack_o(wb_intf.ack_o),    // normal bus termination
    .inta_o(wb_intf.inta_o),  // interrupt output

    // SPI port
    .sck_o(in0.sck_o),         // serial clock output
    .ss_o(),                   // slave select (active low)
    .mosi_o(in0.mosi_o),       // MasterOut SlaveIN
    .miso_i(in0.miso_i)        // MasterIn SlaveOut
  );

endmodule


module clkgen(output logic clock=0);
  always begin
    #10;
    clock = ~clock;
  end
endmodule
