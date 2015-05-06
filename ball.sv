//-------------------------------------------------------------------------
//    Ball.sv                                                            --
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

/*

	Ball circle takes up bottom third of the screen
	2 balls 180 degrees from each other
		red ball - right side
		blue ball - left side
	
	mid_y = starting y position of balls
	mid_x = center point of circle
	left_x = left edge of circle
	right_x = right edge of circle

	number of degrees rotated
	
	left key - counter clockwise
		if y_pos > mid_y
			decrease x
		if y_pos < mid_y
			increase x
		if x_pos > mid_x
			increase y
		if x_pos < mid_x
			decrease y
	right key - clockwise
		if y_pos > mid_y
			increase x
		if y_pos < mid_y
			decrease x
		if x_pos > mid_x
			decrease y
		if x_pos < mid_x
			increase y
	circumference = pi*2*radius
	area = pi*radius^2
	
	color: 2 - dead, 1 - red, 0 - blue
	
*/



module  ball ( input Reset, frame_clk, Collision_other,
					input [7:0] keycode, input color,
					input [9:0] BlockX [0:9], BlockY [0:9], BlockS [0:9],
               output logic [9:0]  BallX, BallY, BallS,
					output logic Collision);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
	parameter [9:0] Ball_X_Right=380;
	parameter [9:0] Ball_X_Left=260;
    parameter [9:0] Ball_Y_Center=390;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=150;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=490;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk or posedge Collision_other)
    begin: Move_Ball
        if (Reset || Collision_other)  // Asynchronous Reset
        begin 
		   Collision = 1'b0;
         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			if (color == 1'b1)
			begin
				Ball_X_Pos <= Ball_X_Right;	//red - right - 2'b1
			end
			else if (color == 1'b0)
			begin
				Ball_X_Pos <= Ball_X_Left;
			end
        end
		
		 else if(((((Ball_X_Pos - Ball_Size) >= BlockX[0]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[0] + BlockS[0]))) && ((Ball_Y_Pos >= BlockY[0]) && (Ball_Y_Pos <= (BlockY[0] + BlockS[0]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[0]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[0] + BlockS[0]))) && ((Ball_Y_Pos >= BlockY[0]) && (Ball_Y_Pos <= (BlockY[0] + BlockS[0]))))
						|| (((Ball_X_Pos >= BlockX[0]) && (Ball_X_Pos <= (BlockX[0] + BlockS[0]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[0]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[0] + BlockS[0]))))
						|| (((Ball_X_Pos >= BlockX[0]) && (Ball_X_Pos <= (BlockX[0] + BlockS[0]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[0]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[0] + BlockS[0]))))
		            || ((((Ball_X_Pos - Ball_Size) >= BlockX[1]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[1] + BlockS[1]))) && ((Ball_Y_Pos >= BlockY[1]) && (Ball_Y_Pos <= (BlockY[1] + BlockS[1]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[1]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[1] + BlockS[1]))) && ((Ball_Y_Pos >= BlockY[1]) && (Ball_Y_Pos <= (BlockY[1] + BlockS[1]))))
						|| (((Ball_X_Pos >= BlockX[1]) && (Ball_X_Pos <= (BlockX[1] + BlockS[1]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[1]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[1] + BlockS[1]))))
						|| (((Ball_X_Pos >= BlockX[1]) && (Ball_X_Pos <= (BlockX[1] + BlockS[1]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[1]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[1] + BlockS[1]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[2]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[2] + BlockS[2]))) && ((Ball_Y_Pos >= BlockY[2]) && (Ball_Y_Pos <= (BlockY[2] + BlockS[2]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[2]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[2] + BlockS[2]))) && ((Ball_Y_Pos >= BlockY[2]) && (Ball_Y_Pos <= (BlockY[2] + BlockS[2]))))
						|| (((Ball_X_Pos >= BlockX[2]) && (Ball_X_Pos <= (BlockX[2] + BlockS[2]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[2]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[2] + BlockS[2]))))
						|| (((Ball_X_Pos >= BlockX[2]) && (Ball_X_Pos <= (BlockX[2] + BlockS[2]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[2]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[2] + BlockS[2]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[3]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[3] + BlockS[3]))) && ((Ball_Y_Pos >= BlockY[3]) && (Ball_Y_Pos <= (BlockY[3] + BlockS[3]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[3]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[3] + BlockS[3]))) && ((Ball_Y_Pos >= BlockY[3]) && (Ball_Y_Pos <= (BlockY[3] + BlockS[3]))))
						|| (((Ball_X_Pos >= BlockX[3]) && (Ball_X_Pos <= (BlockX[3] + BlockS[3]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[3]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[3] + BlockS[3]))))
						|| (((Ball_X_Pos >= BlockX[3]) && (Ball_X_Pos <= (BlockX[3] + BlockS[3]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[3]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[3] + BlockS[3]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[4]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[4] + BlockS[4]))) && ((Ball_Y_Pos >= BlockY[4]) && (Ball_Y_Pos <= (BlockY[4] + BlockS[4]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[4]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[4] + BlockS[4]))) && ((Ball_Y_Pos >= BlockY[4]) && (Ball_Y_Pos <= (BlockY[4] + BlockS[4]))))
						|| (((Ball_X_Pos >= BlockX[4]) && (Ball_X_Pos <= (BlockX[4] + BlockS[4]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[4]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[4] + BlockS[4]))))
						|| (((Ball_X_Pos >= BlockX[4]) && (Ball_X_Pos <= (BlockX[4] + BlockS[4]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[4]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[4] + BlockS[4]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[5]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[5] + BlockS[5]))) && ((Ball_Y_Pos >= BlockY[5]) && (Ball_Y_Pos <= (BlockY[5] + BlockS[5]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[5]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[5] + BlockS[5]))) && ((Ball_Y_Pos >= BlockY[5]) && (Ball_Y_Pos <= (BlockY[5] + BlockS[5]))))
						|| (((Ball_X_Pos >= BlockX[5]) && (Ball_X_Pos <= (BlockX[5] + BlockS[5]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[5]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[5] + BlockS[5]))))
						|| (((Ball_X_Pos >= BlockX[5]) && (Ball_X_Pos <= (BlockX[5] + BlockS[5]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[5]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[5] + BlockS[5]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[6]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[6] + BlockS[6]))) && ((Ball_Y_Pos >= BlockY[6]) && (Ball_Y_Pos <= (BlockY[6] + BlockS[6]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[6]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[6] + BlockS[6]))) && ((Ball_Y_Pos >= BlockY[6]) && (Ball_Y_Pos <= (BlockY[6] + BlockS[6]))))
						|| (((Ball_X_Pos >= BlockX[6]) && (Ball_X_Pos <= (BlockX[6] + BlockS[6]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[6]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[6] + BlockS[6]))))
						|| (((Ball_X_Pos >= BlockX[6]) && (Ball_X_Pos <= (BlockX[6] + BlockS[6]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[6]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[6] + BlockS[6]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[7]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[7] + BlockS[7]))) && ((Ball_Y_Pos >= BlockY[7]) && (Ball_Y_Pos <= (BlockY[7] + BlockS[7]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[7]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[7] + BlockS[7]))) && ((Ball_Y_Pos >= BlockY[7]) && (Ball_Y_Pos <= (BlockY[7] + BlockS[7]))))
						|| (((Ball_X_Pos >= BlockX[7]) && (Ball_X_Pos <= (BlockX[7] + BlockS[7]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[7]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[7] + BlockS[7]))))
						|| (((Ball_X_Pos >= BlockX[7]) && (Ball_X_Pos <= (BlockX[7] + BlockS[7]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[7]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[7] + BlockS[7]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[8]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[8] + BlockS[8]))) && ((Ball_Y_Pos >= BlockY[8]) && (Ball_Y_Pos <= (BlockY[8] + BlockS[8]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[8]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[8] + BlockS[8]))) && ((Ball_Y_Pos >= BlockY[8]) && (Ball_Y_Pos <= (BlockY[8] + BlockS[8]))))
						|| (((Ball_X_Pos >= BlockX[8]) && (Ball_X_Pos <= (BlockX[8] + BlockS[8]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[8]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[8] + BlockS[8]))))
						|| (((Ball_X_Pos >= BlockX[8]) && (Ball_X_Pos <= (BlockX[8] + BlockS[8]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[8]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[8] + BlockS[8]))))
						|| ((((Ball_X_Pos - Ball_Size) >= BlockX[9]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[9] + BlockS[9]))) && ((Ball_Y_Pos >= BlockY[9]) && (Ball_Y_Pos <= (BlockY[9] + BlockS[9]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[9]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[9] + BlockS[9]))) && ((Ball_Y_Pos >= BlockY[9]) && (Ball_Y_Pos <= (BlockY[9] + BlockS[9]))))
						|| (((Ball_X_Pos >= BlockX[9]) && (Ball_X_Pos <= (BlockX[9] + BlockS[9]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[9]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[9] + BlockS[9]))))
						|| (((Ball_X_Pos >= BlockX[9]) && (Ball_X_Pos <= (BlockX[9] + BlockS[9]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[9]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[9] + BlockS[9]))))
						)
			begin 
		   Collision = 1'b1;
         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			if (color == 1'b1)
			begin
				Ball_X_Pos <= Ball_X_Right;	//red - right - 2'b1
			end
			else if (color == 1'b0)
			begin
				Ball_X_Pos <= Ball_X_Left;
			end
        end
		  
        else 
        begin 
				Collision = 1'b0;
				 case (keycode)
					default:
						begin
							Ball_X_Motion = 0;
							Ball_Y_Motion = 0;
						end
				 7:		//right key
						begin
							if (Ball_Y_Pos < Ball_Y_Center)
								Ball_X_Motion = (Ball_X_Step);
							else if (Ball_Y_Pos > Ball_Y_Center)
								Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
							if (Ball_X_Pos < Ball_X_Center)
								Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
							else if (Ball_X_Pos > Ball_X_Center)
								Ball_Y_Motion = (Ball_Y_Step);				
							
							if (Ball_X_Pos == Ball_X_Center)
							begin
								if (Ball_Y_Pos < Ball_Y_Center)
									begin
									//decrease x & y
									Ball_X_Motion = (Ball_X_Step);
									Ball_Y_Motion = (Ball_Y_Step);
									end
								else
									begin
									//increase x & y
									Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
									Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
									end
							end
							if (Ball_Y_Pos == Ball_Y_Center)
							begin
								if (Ball_X_Pos < Ball_X_Center)
									//increase y, decrease x
									begin
									Ball_X_Motion = (Ball_X_Step);
									Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
									end
								else
									//decrease y, increase x
									begin
									Ball_Y_Motion = (Ball_Y_Step);
									Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
									end
							end
							
						end
				 4:		//left key
					// begin
						// if (y_pos < mid_y)
							// Ball_X_Motion = (Ball_X_Step);
						// else if (y_pos > mid_y)
							// Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
						// if (x_pos < mid_x)
							// Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
						// else if (x_pos > mid_x)
							// Ball_Y_Motion = (Ball_Y_Step);
					// end

						begin
							if (Ball_Y_Pos < Ball_Y_Center)
								Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
							else if (Ball_Y_Pos > Ball_Y_Center)
								Ball_X_Motion = (Ball_X_Step);
							if (Ball_X_Pos < Ball_X_Center)
								Ball_Y_Motion = (Ball_Y_Step);
							else if (Ball_X_Pos > Ball_X_Center)
								Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
							if (Ball_X_Pos == Ball_X_Center)
							begin
								if (Ball_Y_Pos > Ball_Y_Center)
								begin
									//decrease x & y
									Ball_X_Motion = (Ball_X_Step);
									Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
								end
								else
								begin
									//increase x & y
									Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
									Ball_Y_Motion = (Ball_Y_Step);
								end
							end
							if (Ball_Y_Pos == Ball_Y_Center)
							begin
								if (Ball_X_Pos < Ball_X_Center)
								begin
									//increase y, decrease x
									Ball_Y_Motion = (Ball_Y_Step);
									Ball_X_Motion = (Ball_X_Step);
								end
								else
								begin
									//decrease y, increase x
									Ball_X_Motion = ~(Ball_X_Step) + 1'b1;
									Ball_Y_Motion = ~(Ball_Y_Step) + 1'b1;
								end
							end
							
						end
				 endcase
				 
				 /*
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion = (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion = Ball_Y_Step;
					  
				 else 
					  Ball_Y_Motion = Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_X_Motion = (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_X_Motion = Ball_X_Step;
					  
				 else 
					  Ball_X_Motion = Ball_X_Motion;  // You need to remove this and make both X and Y respond to keyboard input
				 
				 Ball_Y_Pos = (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos = (Ball_X_Pos + Ball_X_Motion);
				*/
			Ball_Y_Pos = (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
			Ball_X_Pos = (Ball_X_Pos + Ball_X_Motion);
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
	
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
