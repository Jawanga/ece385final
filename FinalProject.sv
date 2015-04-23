//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  FinalProject		( input         Clk,
                                     Reset,
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  output [8:0]  LEDG,
							  output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  Red,
							                Green,
												 Blue,
							  output        VGA_clk,
							                sync,
												 blank,
												 vs,
												 hs,
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] sdram_wire_addr,				// SDRAM Address 13 Bits
							  inout [31:0]  sdram_wire_dq,				// SDRAM Data 32 Bits
							  output [1:0]  sdram_wire_ba,				// SDRAM Bank Address 2 Bits
							  output [3:0]  sdram_wire_dqm,				// SDRAM Data Mast 4 Bits
							  output			 sdram_wire_ras_n,			// SDRAM Row Address Strobe
							  output			 sdram_wire_cas_n,			// SDRAM Column Address Strobe
							  output			 sdram_wire_cke,				// SDRAM Clock Enable
							  output			 sdram_wire_we_n,				// SDRAM Write Enable
							  output			 sdram_wire_cs_n,				// SDRAM Chip Select
							  output			 sdram_clk						// SDRAM Clock
											);
    
    logic Reset_h;
	 logic [7:0] keycode;
	 logic [9:0] DrawX, DrawY;
	 logic [9:0] BallX, BallY, BallS;
	 logic [9:0] BlockX, BlockY, BlockS;
    
    assign {Reset_h}=~ (Reset);  // The push buttons are active low
	 assign OTG_FSPEED = 1'bz;
	 assign OTG_LSPEED = 1'bz;
	    
	 finalproject usbsys_instance(
										 .clk_clk(Clk),         
										 .reset_reset_n(1'b1),   
										 .sdram_wire_addr(sdram_wire_addr), 
										 .sdram_wire_ba(sdram_wire_ba),   
										 .sdram_wire_cas_n(sdram_wire_cas_n),
										 .sdram_wire_cke(sdram_wire_cke),  
										 .sdram_wire_cs_n(sdram_wire_cs_n), 
										 .sdram_wire_dq(sdram_wire_dq),   
										 .sdram_wire_dqm(sdram_wire_dqm),  
										 .sdram_wire_ras_n(sdram_wire_ras_n),
										 .sdram_wire_we_n(sdram_wire_we_n), 
										 .sdram_out_clk_clk(sdram_clk),
										 .keycode_export(keycode),  
										 .usb_DATA(OTG_DATA),    
										 .usb_ADDR(OTG_ADDR),    
										 .usb_RD_N(OTG_RD_N),    
										 .usb_WR_N(OTG_WR_N),    
										 .usb_CS_N(OTG_CS_N),    
										 .usb_RST_N(OTG_RST_N),   
										 .usb_INT(OTG_INT) );
	 /*
	 module  vga_controller ( input        Clk,       // 50 MHz clock
                                      Reset,     // reset signal
                         output logic hs,        // Horizontal sync pulse.  Active low
								              vs,        // Vertical sync pulse.  Active low
												  pixel_clk, // 25 MHz pixel clock output
												  blank,     // Blanking interval indicator.  Active low.
												  sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
								 output [9:0] DrawX,     // horizontal coordinate
								              DrawY );   // vertical coordinate
	 */
	 vga_controller vga_instance(.Clk, .Reset(Reset_h), .hs, .vs, .pixel_clk(VGA_clk), .blank, .sync, .DrawX, .DrawY);
	 
	 /*
	 module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [7:0]  Red, Green, Blue );
	 */
	 
	 color_mapper color_instance(.BallX, .BallY, .DrawX, .DrawY, .Ball_size(BallS), .BlockX, .BlockY, .Block_size(BlockS), .Red, .Green, .Blue);
	 /*
	 module  ball ( input Reset, frame_clk,
               output [9:0]  BallX, BallY, BallS );
	 */
	 
	 ball ball_instance(.Reset(Reset_h), .frame_clk(vs), .BallX, .BallY, .BallS, .keycode);
	 
	 block block1(.Reset(Reset_h), .frame_clk(vs), .Block_X_Center(440), .Block_Y_Center(120), .BlockX, .BlockY, .BlockS);
	 HexDriver hex_inst_0 (keycode[3:0], HEX0);
	 HexDriver hex_inst_1 (keycode[7:4], HEX1);
    

	 /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #1/2:
          What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
			 connect to the keyboard? List any two.  Give an answer in your Post-Lab.
     **************************************************************************************/
endmodule
