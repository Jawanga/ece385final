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

signed real cosine[60] = {
	1.0,
	0.995,
	0.979,
	0.952,
	0.914,
	0.867,
	0.81,
	0.744,
	0.67,
	0.588,
	0.501,
	0.407,
	0.31,
	0.208,
	0.105,
	0.001,
	-0.104,
	-0.207,
	-0.309,
	-0.406,
	-0.499,
	-0.587,
	-0.669,
	-0.743,
	-0.809,
	-0.866,
	-0.913,
	-0.951,
	-0.978,
	-0.994,
	-1.0,
	-0.994,
	-0.978,
	-0.951,
	-0.913,
	-0.866,
	-0.809,
	-0.743,
	-0.669,
	-0.587,
	-0.5,
	-0.406,
	-0.309,
	-0.207,
	-0.104,
	0.0,
	0.105,
	0.208,
	0.31,
	0.407,
	0.501,
	0.588,
	0.67,
	0.744,
	0.81,
	0.867,
	0.914,
	0.952,
	0.979,
	0.995
};

signed real sine[60] {
	0.0,
	0.105,
	0.208,
	0.31,
	0.407,
	0.5,
	0.588,
	0.67,
	0.744,
	0.81,
	0.867,
	0.914,
	0.952,
	0.979,
	0.995,
	1.0,
	0.995,
	0.979,
	0.952,
	0.914,
	0.867,
	0.81,
	0.744,
	0.67,
	0.588,
	0.5,
	0.407,
	0.31,
	0.208,
	0.105,
	0.001,
	-0.104,
	-0.207,
	-0.309,
	-0.406,
	-0.5,
	-0.587,
	-0.669,
	-0.743,
	-0.809,
	-0.866,
	-0.913,
	-0.951,
	-0.978,
	-0.994,
	-1.0,
	-0.994,
	-0.978,
	-0.951,
	-0.913,
	-0.866,
	-0.809,
	-0.743,
	-0.669,
	-0.587,
	-0.5,
	-0.406,
	-0.309,
	-0.207,
	-0.104

};
module  ball ( input Reset, frame_clk,
					input [7:0] keycode, input color, input [5:0] index;
               output [9:0]  BallX, BallY, BallS,
			   output [5:0] next_index);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
	parameter [9:0] Ball_X_Right=400;
	parameter [9:0] Ball_X_Left=240;
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	parameter [7:0] radius=80;			//radius of the circle

	
	
    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			relative_x = 0;
			relative_y = 0;
			if (color == 1'b1)
			begin
				Ball_X_Pos <= Ball_X_Right;	//red - right - 2'b1
				index = 0;
			end
			else if (color == 1'b0)
			begin
				Ball_X_Pos <= Ball_X_Left;
				index = 30;
			end
        end
		
           
        else 
        begin 
			
				 case (keycode)
					default:
						begin
							Ball_X_Motion = 0;
							Ball_Y_Motion = 0;
						end
				 7:		//right key
						begin
							prev_index = index;
							if (index == 0)
								next_index = 59;
							else 
								next_index = index - 1;
							Ball_X_Motion = (cosine[prev_index] - cosine[next_index]) * radius;
							Ball_Y_Motion = (sine[prev_index] - sine[next_index]) * radius;
						end
				 4:		//left key
							prev_index = index;
							if (index == 59)
								index = 0;
							else
								next_index = index + 1;
							Ball_X_Motion = (cosine[prev_index] - cosine[next_index]) * radius;
							Ball_Y_Motion = (sine[prev_index] - sine[next_index]) * radius;
							
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
