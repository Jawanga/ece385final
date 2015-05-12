//-------------------------------------------------------------------------
//    Block.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  block ( input Reset, frame_clk, restart,
					 input Collision [0:1],
					 input [9:0]  Block_X_Center, Block_Y_Step,
					 input block_ready,
					 output end_level,
               output [9:0]  BlockX, BlockY);
    
    logic [9:0] Block_X_Pos, Block_X_Motion, Block_Y_Pos, Block_Y_Motion, Block_Size;
	 
    //parameter [9:0] Block_X_Center=440;  // Center position on the X axis
    //parameter [9:0] Block_Y_Center=120;  // Center position on the Y axis
    parameter [9:0] Block_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Block_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Block_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Block_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Block_X_Step=1;      // Step size on the X axis

	
    //assign Block_Size = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge restart or posedge Collision[0] or posedge Collision[1] or posedge frame_clk )
    begin: Move_Block
        if (Reset || restart || Collision[0] || Collision[1])  // Asynchronous Reset
        begin
            Block_Y_Motion <= 10'd0; //Block_Y_Step;
				Block_X_Motion <= 10'd0; //Block_X_Step;
				Block_Y_Pos <= 0;
				Block_X_Pos <= Block_X_Center;
				end_level <= 0;
        end
           
        else 
        begin
				if ((Block_Y_Pos > Block_Y_Max) || ~block_ready)	//allow block to stop once off screen, or if block is not ready to come on the screen
				begin
					if (Block_Y_Pos > Block_Y_Max)
						end_level = 1;
					Block_Y_Motion = 10'd0;
				end
				
				else
				begin
				 Block_Y_Motion = Block_Y_Step;
				 end_level = 0;
				end
				 
				 Block_Y_Pos = (Block_Y_Pos + Block_Y_Motion);  // Update Block position
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Block_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Block_Y_pos.  Will the new value of Block_Y_Motion be used,
          or the old?  How will this impact behavior of the Block during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BlockX = Block_X_Center;
   
    assign BlockY = Block_Y_Pos;
   
    //assign BlockS = Block_Size;
    

endmodule
