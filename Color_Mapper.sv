//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX [0:1], BallY [0:1], Ball_size [0:1],
							  input			[9:0] BlockX [0:4], BlockY [0:4], Block_size [0:4], DrawX, DrawY,
							  input			block_ready [0:4],
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_red_on, ball_blue_on, block_on [0:4];
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int RedDistX, RedDistY, RedSize, BlueDistX, BlueDistY, BlueSize;
	 int BlockDistX [0:4], BlockDistY [0:4];
	 assign BlueDistX = DrawX - BallX[0];
    assign BlueDistY = DrawY - BallY[0];
	 assign RedDistX = DrawX - BallX[1];
    assign RedDistY = DrawY - BallY[1];
	 assign BlockDistX[0] = DrawX - BlockX[0];
	 assign BlockDistY[0] = DrawY - BlockY[0];
	 assign BlockDistX[1] = DrawX - BlockX[1];
	 assign BlockDistY[1] = DrawY - BlockY[1];
	 assign BlockDistX[2] = DrawX - BlockX[2];
	 assign BlockDistY[2] = DrawY - BlockY[2];
	 assign BlockDistX[3] = DrawX - BlockX[3];
	 assign BlockDistY[3] = DrawY - BlockY[3];
	 assign BlockDistX[4] = DrawX - BlockX[4];
	 assign BlockDistY[4] = DrawY - BlockY[4];
    assign BlueSize = Ball_size[0];
	 assign RedSize = Ball_size[1];
	 
	 logic draw_block;
	  
    always_comb
    begin:BlueBall_on_proc
        if ( ( BlueDistX*BlueDistX + BlueDistY*BlueDistY) <= (BlueSize * BlueSize) ) 
            ball_blue_on = 1'b1;
        else 
            ball_blue_on = 1'b0;
     end
	  
	 always_comb
    begin:RedBall_on_proc
        if ( ( RedDistX*RedDistX + RedDistY*RedDistY) <= (RedSize * RedSize) ) 
            ball_red_on = 1'b1;
        else 
            ball_red_on = 1'b0;
     end 
	  
	 always_comb
	 begin:Block_on_proc
		for (int i = 0; i < 5; i++) begin
		  if ( (BlockDistX[i] <= Block_size[i]) && (BlockDistY[i] <= Block_size[i]) )
				block_on[i] = 1'b1;
		  else
				block_on[i] = 1'b0;
		end
	 end
       
    always_comb
    begin:RGB_Display
		
		Red = 8'h4f - DrawX[9:3];
		Green = 8'h00;
		Blue = 8'h44;
		
		for (int i = 0; i < 5; i++) begin
			if (block_on[i] && block_ready[i])
			begin
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'hff;
			end
		end
		
		if (ball_red_on == 1'b1)
		begin
			Red = 8'h00;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		if (ball_blue_on == 1'b1)
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
		end
		
    end
    
endmodule
