// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

// include directories
//*** add incdir include directories here
-incdir ../sv // include directory for sv files
-incdir ../../wishbone/sv

// compile files
//*** add compile files here

../sv/spi_pkg.sv // compile spi package
../sv/spi_if.sv
../../wishbone_interface/sv/wishbone_if.sv
../../wishbone_interface/sv/wishbone_pkg.sv


hw_top.sv
simple_spi_top.v
fifo4.v
tb_top.sv // compile top level 

+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH
+SVSEED=random

-access +rwc -timescale 1ns/1ns
