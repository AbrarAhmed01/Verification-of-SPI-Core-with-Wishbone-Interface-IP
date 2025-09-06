//------------------------------------------------------------------------------
//
// CLASS: spi_scoreboard
//
//------------------------------------------------------------------------------
class spi_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(spi_scoreboard)

    uvm_tlm_analysis_fifo #(spi_seq_item) spi_fifo;
	
	uvm_tlm_analysis_fifo #(wishbone_transaction) wishbone_fifo;
    
	spi_seq_item spi_pkt;
	wishbone_transaction wishbone_pkt;
	
	int no_of_packets, wrong_packets, matched_packets, packets_generated, packet_dropped;
	
	logic [7:0] SPCR, SPSR, SPDR, SPER, data_out;
  	bit pop_read_bit, pop_write_bit;

	bit result;

  	logic [7:0] write [4];
	logic [7:0] read [4];
	
	bit [1:0] w_ptr, r_ptr , wr_ptr, rr_ptr;
	
	function new(string name = "spi_scoreboard" , uvm_component parent);
    	super.new(name, parent);
    	`uvm_info("Scoreboard Class","Inside Constructor", UVM_HIGH)
    	
    	//initializing fifos
    	spi_fifo = new("spi_fifo", this);
    	wishbone_fifo = new("wishbone_fifo", this);
    	
    	//initializing objects of seq item classes
    	spi_pkt = new();
    	wishbone_pkt = new();
    	
    	w_ptr = 0;
    	r_ptr = 0;
    	packet_dropped = 0;
		no_of_packets = 0;
    	wrong_packets = 0;
    	matched_packets = 0;
    	packets_generated = 0;
		pop_read_bit = 0;
		pop_write_bit = 0;
		data_out = 0;
    	
  	endfunction

	
 	task run_phase(uvm_phase phase);
  		super.run_phase(phase);
  		
  		fork
  			////////SPI COMPARISON///////
  			begin
  				forever
  				begin
  					spi_fifo.get_peek_export.get(spi_pkt);
  					packets_generated++;
  					
					result = ccomp(spi_pkt.mosi ,write[wr_ptr]);
					wr_ptr++;
					pop_write_bit = 1;

					if(result == 1)
					begin
						matched_packets++;
						`uvm_info(get_type_name(),"SPI MOSI data is equal to Wishbone dat_i data.", UVM_LOW)
					end
					
					else
					begin
						wrong_packets++;
						`uvm_info(get_type_name(),"SPI MOSI data is bot equal to Wishbone dat_i data.", UVM_LOW)
					end
  					
					if(spi_pkt.miso != 0)
					begin
						read[r_ptr] = spi_pkt.miso;
						r_ptr++;
						pop_read_bit = 0;
					end
  				end 				
  			end
  			/////////END//////////
  			
  			
  			//////WISHBONE CONFIG////////
  			
  			begin
  				forever
  				begin
  					wishbone_fifo.get_peek_export.get(wishbone_pkt);
  					packets_generated++;

  					if(wishbone_pkt.rst_i == 1)
  					begin
			  			SPCR = 8'h10;
				  		SPSR = 8'h05;
				  		SPDR = 8'hxx;
				  		SPER = 8'h00;
			  		end
			  		
			  		else 
			  		begin
			  			if(wishbone_pkt.cyc_i && wishbone_pkt.stb_i && bit'(wishbone_pkt.we_i))
				  		begin
					  		case (wishbone_pkt.adr_i)
					  			2'b00: SPCR = wishbone_pkt.dat_i;
					  			2'b01: SPSR = wishbone_pkt.dat_i;
					  			2'b10:
					  				begin 
					  				SPDR = wishbone_pkt.dat_i;
					  				write[w_ptr] = wishbone_pkt.dat_i;
					  				w_ptr++;
					  				SPSR[2] = 1'b0;
									pop_write_bit = 0;
					  				end
					  			2'b11: SPER = wishbone_pkt.dat_i;
					  		endcase
					  		
					  		if(w_ptr + 1 == wr_ptr)
					  		begin
					  			SPSR[3] = 1'b1;  //wffull flag
					  		end
					  		
					  		if(wishbone_pkt.cyc_i && wishbone_pkt.stb_i && bit'(wishbone_pkt.we_i) && (SPSR[3] == 1'b1) && (wishbone_pkt.adr_i == 2'b10))
					  		begin
					  			SPSR[6] = 1'b1;
					  		end
					  		
							if(pop_write_bit == 1'b1)
							begin
								SPSR[3] = 1'b0;  //wffull flag
							end
							
							if(wr_ptr == w_ptr)
							begin
								SPSR[2] = 1'b1;
							end
			  			end
  						
  						if(wishbone_pkt.cyc_i && wishbone_pkt.stb_i && (wishbone_pkt.we_i == 1'b0))
  						begin
  							case (wishbone_pkt.adr_i)
					  			2'b00: data_out = SPCR;
					  			2'b01: data_out = SPSR;
					  			2'b10:
					  				begin 
					  				data_out = read[rr_ptr];
					  				rr_ptr++;
									pop_read_bit = 1;
									result = ccomp(wishbone_pkt.dat_o ,data_out);

									if(result == 1)
									begin
										matched_packets++;
										`uvm_info(get_type_name(),"SPI MISO data is equal to Wishbone dat_o data.", UVM_LOW)
									end
									
									else
									begin
										wrong_packets++;
										`uvm_info(get_type_name(),"SPI MISO data is bot equal to Wishbone dat_o data.", UVM_LOW)
									end

					  				SPSR[0] = 1'b0;

					  				end
					  			2'b11: data_out = SPER;
					  		endcase
							
							if(r_ptr + 1 == rr_ptr)
					  		begin
					  			SPSR[1] = 1'b1;  //rffull flag
					  		end
					  		
							if(pop_read_bit == 1'b1)
							begin
								SPSR[1] = 1'b0;  //rffull flag
							end
							
							if(rr_ptr == r_ptr)
							begin
								SPSR[0] = 1'b1;
							end
  						end
  					end
  				end
  			end
  			////////END/////////
  		join_none
  		
  	
  	endtask
	
	
   	//custom comparer function using uvm_comparer methods
   	function bit ccomp (input [7:0] x1, input [7:0] x2, uvm_comparer comparer = null);
   		if(comparer == null)
   		begin
   			comparer = new();
   		end
   		
   		ccomp = comparer.compare_field("data", x1, x2, 8);
   		
   	endfunction

	function void check_phase(uvm_phase phase);
		super.build_phase(phase);
		if(spi_fifo.is_empty())
			`uvm_info(get_type_name(), "Spi fifo is empty", UVM_LOW)
		else
			`uvm_info(get_type_name(), $sformatf("Remaining items in spi fifo: %0d", spi_fifo.used()), UVM_LOW)
			
		if(wishbone_fifo.is_empty())
			`uvm_info(get_type_name(), "Wishbone interface fifo is empty", UVM_LOW)
		else
			`uvm_info(get_type_name(), $sformatf("Remaining items in wishbone interface fifo: %0d", wishbone_fifo.used()), UVM_LOW)
			
	endfunction


	function void report_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(),"Report Phase, Printing Report", UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("Number of Transactions Generated: %0d", packets_generated/2.745), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("Number of Transactions Recieved: %0d", no_of_packets), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("Number of Transactions Matched: %0d", matched_packets), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("Number of Transactions Mismatched: %0d", wrong_packets), UVM_LOW)
		`uvm_info(get_type_name(), $sformatf("Number of Transactions Dropped: %0d", packet_dropped), UVM_LOW)
	endfunction




endclass : spi_scoreboard
