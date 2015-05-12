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
												 Run,
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
	 logic [9:0] BallX [0:1], BallY [0:1], BallS [0:1];
	 logic [9:0] BlockX [0:13], BlockY [0:13], BlockS [0:13];
	 logic block_ready [0:13];
	 logic [9:0] RectX [0:5], RectY[0:5], RectS[0:5];
	 logic rect_ready [0:5];
	 logic [5:0] index [0:1], next_index [0:1];
	 logic [9:0] seconds;
	 logic level_one, level_two, title, pstart, restart;
    logic end_level [0:19];
	 logic Collision [0:1];
	 logic blue_paint [0:19], orange_paint [0:19];
	 logic [5:0] block_hit [0:1], block_hit_other [0:1];
	 
	 initial begin
		for (int i = 0; i < $size(block_ready); i++) begin
			block_ready[i] = 0;
		end
		for (int i = 0; i < $size(rect_ready); i++) begin
			rect_ready[i] = 0;
		end
		for (int i = 0; i < 20; i++) begin
			blue_paint[i] = 0;
			orange_paint[i] = 0;
		end
		Collision[0] = 0;
		Collision[1] = 0;
		keycode = 0;
	 end
	 
    assign {Reset_h}=~ (Reset);  // The push buttons are active low
	 assign Run_h = ~Run;
	 assign OTG_FSPEED = 1'bz;
	 assign OTG_LSPEED = 1'bz;
	 
	 assign BlockS[0] = 20;
	 assign BlockS[1] = 20;
	 assign BlockS[2] = 20;
	 assign BlockS[3] = 20;
	 assign BlockS[4] = 20;
	 assign BlockS[5] = 20;
	 assign BlockS[6] = 20;
	 assign BlockS[7] = 20;
	 assign BlockS[8] = 20;
	 assign BlockS[9] = 20;
	 assign BlockS[10] = 20;
	 assign BlockS[11] = 20;
	 assign BlockS[12] = 20;
	 assign BlockS[13] = 20;
	 
	 assign RectS[0] = 40;
	 assign RectS[1] = 40;
	 assign RectS[2] = 40;
	 assign RectS[3] = 50;
	 assign RectS[4] = 70;
	 assign RectS[5] = 60;
	 
	 assign index[0] = next_index[0];
	 assign index[1] = next_index[1];
	    
	 usb_system usbsys_instance(
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
	 
	 color_mapper color_instance(.BallX, .BallY, .DrawX, .DrawY, .Ball_size(BallS), .BlockX, .BlockY, .Block_size(BlockS), .block_ready, .RectX, .RectY, .Rect_size(RectS), .rect_ready, .title, .level_one, .level_two, .pstart, .blue_paint, .orange_paint, .Red, .Green, .Blue);
	 /*
	 module  ball ( input Reset, frame_clk,
               output [9:0]  BallX, BallY, BallS );
	 */
	 
	 ball blue(.Reset(Reset_h), .frame_clk(vs), .Collision_other(Collision[1]), .block_hit_other(block_hit[1]), .BlockX, .BlockY, .BlockS, .RectX, .RectY, .RectS, .color(0), .BallX(BallX[0]), .BallY(BallY[0]), .BallS(BallS[0]), .keycode, .paint(blue_paint), .Collision(Collision[0]), .block_hit(block_hit[0]), .index(index[0]), .next_index(next_index[0]));
	 ball red(.Reset(Reset_h), .frame_clk(vs), .Collision_other(Collision[0]), .block_hit_other(block_hit[0]), .BlockX, .BlockY, .BlockS, .RectX, .RectY, .RectS, .color(1), .BallX(BallX[1]), .BallY(BallY[1]), .BallS(BallS[1]), .keycode, .paint(orange_paint), .Collision(Collision[1]), .block_hit(block_hit[1]), .index(index[1]), .next_index(next_index[1]));
	 
	 block_SM statemachine_instance(.Clk, .Reset(Reset_h), .Run(Run_h), .Collision, .keycode, .end_level, .block_ready, .rect_ready, .title, .level_one, .level_two, .pstart, .restart, .seconds);
	 
	 block block1(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(370), .BlockX(BlockX[0]), .BlockY(BlockY[0]), .block_ready(block_ready[0]), .end_level(end_level[0]));
	 block block2(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(320), .BlockX(BlockX[1]), .BlockY(BlockY[1]), .block_ready(block_ready[1]), .end_level(end_level[1]));
	 block block3(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(BlockX[2]), .BlockY(BlockY[2]), .block_ready(block_ready[2]), .end_level(end_level[2]));
	 block block4(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(340), .BlockX(BlockX[3]), .BlockY(BlockY[3]), .block_ready(block_ready[3]), .end_level(end_level[3]));
	 block block5(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(310), .BlockX(BlockX[4]), .BlockY(BlockY[4]), .block_ready(block_ready[4]), .end_level(end_level[4]));
	 block block6(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(290), .BlockX(BlockX[5]), .BlockY(BlockY[5]), .block_ready(block_ready[5]), .end_level(end_level[5]));
	 block block7(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(365), .BlockX(BlockX[6]), .BlockY(BlockY[6]), .block_ready(block_ready[6]), .end_level(end_level[6]));
	 block block8(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[7]), .BlockY(BlockY[7]), .block_ready(block_ready[7]), .end_level(end_level[7]));
	 block block9(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(BlockX[8]), .BlockY(BlockY[8]), .block_ready(block_ready[8]), .end_level(end_level[8]));
	 block block10(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[9]), .BlockY(BlockY[9]), .block_ready(block_ready[9]), .end_level(end_level[9]));
	 
	 block rect1(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(RectX[0]), .BlockY(RectY[0]), .block_ready(rect_ready[0]), .end_level(end_level[10]));
	 block rect2(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(350), .BlockX(RectX[1]), .BlockY(RectY[1]), .block_ready(rect_ready[1]), .end_level(end_level[11]));
	 block rect3(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(RectX[2]), .BlockY(RectY[2]), .block_ready(rect_ready[2]), .end_level(end_level[12]));
	 block block11(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[10]), .BlockY(BlockY[10]), .block_ready(block_ready[10]), .end_level(end_level[13]));
	 block block12(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[11]), .BlockY(BlockY[11]), .block_ready(block_ready[11]), .end_level(end_level[14]));
	 block rect4(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(RectX[3]), .BlockY(RectY[3]), .block_ready(rect_ready[3]), .end_level(end_level[15]));
	 block block13(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[12]), .BlockY(BlockY[12]), .block_ready(block_ready[12]), .end_level(end_level[16]));
	 block rect5(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(RectX[4]), .BlockY(RectY[4]), .block_ready(rect_ready[4]), .end_level(end_level[17]));
	 block rect6(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(250), .BlockX(RectX[5]), .BlockY(RectY[5]), .block_ready(rect_ready[5]), .end_level(end_level[18]));
	 block block14(.Reset(Reset_h), .frame_clk(vs), .restart, .Collision, .Block_X_Center(300), .BlockX(BlockX[13]), .BlockY(BlockY[13]), .block_ready(block_ready[13]), .end_level(end_level[19]));
	 
	 HexDriver hex_inst_0 (seconds[3:0], HEX0);
	 HexDriver hex_inst_1 (keycode[7:4], HEX1);
    

	 /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #1/2:
          What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
			 connect to the keyboard? List any two.  Give an answer in your Post-Lab.
     **************************************************************************************/
endmodule
