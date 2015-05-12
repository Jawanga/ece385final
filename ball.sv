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
					input [5:0] block_hit_other,
					input [7:0] keycode, input color, input[5:0] index,
					input [9:0] BlockX [0:17], BlockY [0:17], BlockS [0:17],
					input [9:0] RectX [0:11], RectY [0:11], RectS [0:11],
               output logic [9:0]  BallX, BallY, BallS,
					output logic paint [0:29],
					output logic [5:0] block_hit,
					output logic Collision,
					output logic [5:0] next_index);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic block_collision [0:17];
	 logic rect_collision [0:11];
	 
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
	 parameter int signed radius = 60;
	 
	 logic [5:0] prev_index;
	 logic [5:0] up_index, down_index;
	 logic [5:0] zero_index, last_index;
	 
	 assign prev_index = index;
	 assign up_index = index + 1;
	 assign down_index = index - 1;
	 assign zero_index = 1;
	 assign last_index = 60;
	 
	 int signed sine_val, cosine_val;		//????!?!?!?!?!??!?!?
	 int signed up_sine_val, up_cosine_val, down_sine_val, down_cosine_val, zero_sine_val, zero_cosine_val, last_sine_val, last_cosine_val;
	 Sin_Cos get_vals ( .clk(frame_clk), .index, .sine(sine_val), .cosine(cosine_val));
	 Sin_Cos up_index_val (.clk(frame_clk), .index(up_index), .sine(up_sine_val), .cosine(up_cosine_val));
	 Sin_Cos down_index_val (.clk(frame_clk), .index(down_index), .sine(down_sine_val), .cosine(down_cosine_val));
	 Sin_Cos zero_index_val (.clk(frame_clk), .index(zero_index), .sine(zero_sine_val), .cosine(zero_cosine_val));
	 Sin_Cos last_index_val (.clk(frame_clk), .index(last_index), .sine(last_sine_val), .cosine(last_cosine_val));
	 
    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign block_collision[0] = ((((Ball_X_Pos - Ball_Size) >= BlockX[0]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[0] + BlockS[0]))) && ((Ball_Y_Pos >= BlockY[0]) && (Ball_Y_Pos <= (BlockY[0] + BlockS[0]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[0]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[0] + BlockS[0]))) && ((Ball_Y_Pos >= BlockY[0]) && (Ball_Y_Pos <= (BlockY[0] + BlockS[0]))))
						|| (((Ball_X_Pos >= BlockX[0]) && (Ball_X_Pos <= (BlockX[0] + BlockS[0]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[0]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[0] + BlockS[0]))))
						|| (((Ball_X_Pos >= BlockX[0]) && (Ball_X_Pos <= (BlockX[0] + BlockS[0]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[0]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[0] + BlockS[0]))));
	 assign block_collision[1] = ((((Ball_X_Pos - Ball_Size) >= BlockX[1]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[1] + BlockS[1]))) && ((Ball_Y_Pos >= BlockY[1]) && (Ball_Y_Pos <= (BlockY[1] + BlockS[1]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[1]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[1] + BlockS[1]))) && ((Ball_Y_Pos >= BlockY[1]) && (Ball_Y_Pos <= (BlockY[1] + BlockS[1]))))
						|| (((Ball_X_Pos >= BlockX[1]) && (Ball_X_Pos <= (BlockX[1] + BlockS[1]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[1]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[1] + BlockS[1]))))
						|| (((Ball_X_Pos >= BlockX[1]) && (Ball_X_Pos <= (BlockX[1] + BlockS[1]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[1]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[1] + BlockS[1]))));
	 assign block_collision[2] = ((((Ball_X_Pos - Ball_Size) >= BlockX[2]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[2] + BlockS[2]))) && ((Ball_Y_Pos >= BlockY[2]) && (Ball_Y_Pos <= (BlockY[2] + BlockS[2]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[2]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[2] + BlockS[2]))) && ((Ball_Y_Pos >= BlockY[2]) && (Ball_Y_Pos <= (BlockY[2] + BlockS[2]))))
						|| (((Ball_X_Pos >= BlockX[2]) && (Ball_X_Pos <= (BlockX[2] + BlockS[2]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[2]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[2] + BlockS[2]))))
						|| (((Ball_X_Pos >= BlockX[2]) && (Ball_X_Pos <= (BlockX[2] + BlockS[2]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[2]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[2] + BlockS[2]))));
	 assign block_collision[3] = ((((Ball_X_Pos - Ball_Size) >= BlockX[3]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[3] + BlockS[3]))) && ((Ball_Y_Pos >= BlockY[3]) && (Ball_Y_Pos <= (BlockY[3] + BlockS[3]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[3]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[3] + BlockS[3]))) && ((Ball_Y_Pos >= BlockY[3]) && (Ball_Y_Pos <= (BlockY[3] + BlockS[3]))))
						|| (((Ball_X_Pos >= BlockX[3]) && (Ball_X_Pos <= (BlockX[3] + BlockS[3]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[3]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[3] + BlockS[3]))))
						|| (((Ball_X_Pos >= BlockX[3]) && (Ball_X_Pos <= (BlockX[3] + BlockS[3]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[3]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[3] + BlockS[3]))));
	 assign block_collision[4] = ((((Ball_X_Pos - Ball_Size) >= BlockX[4]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[4] + BlockS[4]))) && ((Ball_Y_Pos >= BlockY[4]) && (Ball_Y_Pos <= (BlockY[4] + BlockS[4]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[4]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[4] + BlockS[4]))) && ((Ball_Y_Pos >= BlockY[4]) && (Ball_Y_Pos <= (BlockY[4] + BlockS[4]))))
						|| (((Ball_X_Pos >= BlockX[4]) && (Ball_X_Pos <= (BlockX[4] + BlockS[4]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[4]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[4] + BlockS[4]))))
						|| (((Ball_X_Pos >= BlockX[4]) && (Ball_X_Pos <= (BlockX[4] + BlockS[4]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[4]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[4] + BlockS[4]))));
	 assign block_collision[5] = ((((Ball_X_Pos - Ball_Size) >= BlockX[5]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[5] + BlockS[5]))) && ((Ball_Y_Pos >= BlockY[5]) && (Ball_Y_Pos <= (BlockY[5] + BlockS[5]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[5]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[5] + BlockS[5]))) && ((Ball_Y_Pos >= BlockY[5]) && (Ball_Y_Pos <= (BlockY[5] + BlockS[5]))))
						|| (((Ball_X_Pos >= BlockX[5]) && (Ball_X_Pos <= (BlockX[5] + BlockS[5]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[5]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[5] + BlockS[5]))))
						|| (((Ball_X_Pos >= BlockX[5]) && (Ball_X_Pos <= (BlockX[5] + BlockS[5]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[5]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[5] + BlockS[5]))));
	 assign block_collision[6] = ((((Ball_X_Pos - Ball_Size) >= BlockX[6]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[6] + BlockS[6]))) && ((Ball_Y_Pos >= BlockY[6]) && (Ball_Y_Pos <= (BlockY[6] + BlockS[6]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[6]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[6] + BlockS[6]))) && ((Ball_Y_Pos >= BlockY[6]) && (Ball_Y_Pos <= (BlockY[6] + BlockS[6]))))
						|| (((Ball_X_Pos >= BlockX[6]) && (Ball_X_Pos <= (BlockX[6] + BlockS[6]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[6]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[6] + BlockS[6]))))
						|| (((Ball_X_Pos >= BlockX[6]) && (Ball_X_Pos <= (BlockX[6] + BlockS[6]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[6]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[6] + BlockS[6]))));
	 assign block_collision[7] = ((((Ball_X_Pos - Ball_Size) >= BlockX[7]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[7] + BlockS[7]))) && ((Ball_Y_Pos >= BlockY[7]) && (Ball_Y_Pos <= (BlockY[7] + BlockS[7]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[7]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[7] + BlockS[7]))) && ((Ball_Y_Pos >= BlockY[7]) && (Ball_Y_Pos <= (BlockY[7] + BlockS[7]))))
						|| (((Ball_X_Pos >= BlockX[7]) && (Ball_X_Pos <= (BlockX[7] + BlockS[7]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[7]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[7] + BlockS[7]))))
						|| (((Ball_X_Pos >= BlockX[7]) && (Ball_X_Pos <= (BlockX[7] + BlockS[7]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[7]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[7] + BlockS[7]))));
	 assign block_collision[8] = ((((Ball_X_Pos - Ball_Size) >= BlockX[8]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[8] + BlockS[8]))) && ((Ball_Y_Pos >= BlockY[8]) && (Ball_Y_Pos <= (BlockY[8] + BlockS[8]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[8]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[8] + BlockS[8]))) && ((Ball_Y_Pos >= BlockY[8]) && (Ball_Y_Pos <= (BlockY[8] + BlockS[8]))))
						|| (((Ball_X_Pos >= BlockX[8]) && (Ball_X_Pos <= (BlockX[8] + BlockS[8]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[8]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[8] + BlockS[8]))))
						|| (((Ball_X_Pos >= BlockX[8]) && (Ball_X_Pos <= (BlockX[8] + BlockS[8]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[8]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[8] + BlockS[8]))));
	 assign block_collision[9] = ((((Ball_X_Pos - Ball_Size) >= BlockX[9]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[9] + BlockS[9]))) && ((Ball_Y_Pos >= BlockY[9]) && (Ball_Y_Pos <= (BlockY[9] + BlockS[9]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[9]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[9] + BlockS[9]))) && ((Ball_Y_Pos >= BlockY[9]) && (Ball_Y_Pos <= (BlockY[9] + BlockS[9]))))
						|| (((Ball_X_Pos >= BlockX[9]) && (Ball_X_Pos <= (BlockX[9] + BlockS[9]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[9]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[9] + BlockS[9]))))
						|| (((Ball_X_Pos >= BlockX[9]) && (Ball_X_Pos <= (BlockX[9] + BlockS[9]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[9]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[9] + BlockS[9]))));
    assign block_collision[10] = ((((Ball_X_Pos - Ball_Size) >= BlockX[10]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[10] + BlockS[10]))) && ((Ball_Y_Pos >= BlockY[10]) && (Ball_Y_Pos <= (BlockY[10] + BlockS[10]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[10]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[10] + BlockS[10]))) && ((Ball_Y_Pos >= BlockY[10]) && (Ball_Y_Pos <= (BlockY[10] + BlockS[10]))))
						|| (((Ball_X_Pos >= BlockX[10]) && (Ball_X_Pos <= (BlockX[10] + BlockS[10]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[10]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[10] + BlockS[10]))))
						|| (((Ball_X_Pos >= BlockX[10]) && (Ball_X_Pos <= (BlockX[10] + BlockS[10]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[10]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[10] + BlockS[10]))));
	 assign block_collision[11] = ((((Ball_X_Pos - Ball_Size) >= BlockX[11]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[11] + BlockS[11]))) && ((Ball_Y_Pos >= BlockY[11]) && (Ball_Y_Pos <= (BlockY[11] + BlockS[11]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[11]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[11] + BlockS[11]))) && ((Ball_Y_Pos >= BlockY[11]) && (Ball_Y_Pos <= (BlockY[11] + BlockS[11]))))
						|| (((Ball_X_Pos >= BlockX[11]) && (Ball_X_Pos <= (BlockX[11] + BlockS[11]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[11]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[11] + BlockS[11]))))
						|| (((Ball_X_Pos >= BlockX[11]) && (Ball_X_Pos <= (BlockX[11] + BlockS[11]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[11]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[11] + BlockS[11]))));
	 assign block_collision[12] = ((((Ball_X_Pos - Ball_Size) >= BlockX[12]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[12] + BlockS[12]))) && ((Ball_Y_Pos >= BlockY[12]) && (Ball_Y_Pos <= (BlockY[12] + BlockS[12]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[12]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[12] + BlockS[12]))) && ((Ball_Y_Pos >= BlockY[12]) && (Ball_Y_Pos <= (BlockY[12] + BlockS[12]))))
						|| (((Ball_X_Pos >= BlockX[12]) && (Ball_X_Pos <= (BlockX[12] + BlockS[12]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[12]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[12] + BlockS[12]))))
						|| (((Ball_X_Pos >= BlockX[12]) && (Ball_X_Pos <= (BlockX[12] + BlockS[12]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[12]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[12] + BlockS[12]))));
	 assign block_collision[13] = ((((Ball_X_Pos - Ball_Size) >= BlockX[13]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[13] + BlockS[13]))) && ((Ball_Y_Pos >= BlockY[13]) && (Ball_Y_Pos <= (BlockY[13] + BlockS[13]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[13]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[13] + BlockS[13]))) && ((Ball_Y_Pos >= BlockY[13]) && (Ball_Y_Pos <= (BlockY[13] + BlockS[13]))))
						|| (((Ball_X_Pos >= BlockX[13]) && (Ball_X_Pos <= (BlockX[13] + BlockS[13]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[13]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[13] + BlockS[13]))))
						|| (((Ball_X_Pos >= BlockX[13]) && (Ball_X_Pos <= (BlockX[13] + BlockS[13]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[13]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[13] + BlockS[13]))));
	 assign block_collision[14] = ((((Ball_X_Pos - Ball_Size) >= BlockX[14]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[14] + BlockS[14]))) && ((Ball_Y_Pos >= BlockY[14]) && (Ball_Y_Pos <= (BlockY[14] + BlockS[14]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[14]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[14] + BlockS[14]))) && ((Ball_Y_Pos >= BlockY[14]) && (Ball_Y_Pos <= (BlockY[14] + BlockS[14]))))
						|| (((Ball_X_Pos >= BlockX[14]) && (Ball_X_Pos <= (BlockX[14] + BlockS[14]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[14]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[14] + BlockS[14]))))
						|| (((Ball_X_Pos >= BlockX[14]) && (Ball_X_Pos <= (BlockX[14] + BlockS[14]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[14]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[14] + BlockS[14]))));
	 assign block_collision[15] = ((((Ball_X_Pos - Ball_Size) >= BlockX[15]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[15] + BlockS[15]))) && ((Ball_Y_Pos >= BlockY[15]) && (Ball_Y_Pos <= (BlockY[15] + BlockS[15]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[15]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[15] + BlockS[15]))) && ((Ball_Y_Pos >= BlockY[15]) && (Ball_Y_Pos <= (BlockY[15] + BlockS[15]))))
						|| (((Ball_X_Pos >= BlockX[15]) && (Ball_X_Pos <= (BlockX[15] + BlockS[15]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[15]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[15] + BlockS[15]))))
						|| (((Ball_X_Pos >= BlockX[15]) && (Ball_X_Pos <= (BlockX[15] + BlockS[15]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[15]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[15] + BlockS[15]))));
	 assign block_collision[16] = ((((Ball_X_Pos - Ball_Size) >= BlockX[16]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[16] + BlockS[16]))) && ((Ball_Y_Pos >= BlockY[16]) && (Ball_Y_Pos <= (BlockY[16] + BlockS[16]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[16]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[16] + BlockS[16]))) && ((Ball_Y_Pos >= BlockY[16]) && (Ball_Y_Pos <= (BlockY[16] + BlockS[16]))))
						|| (((Ball_X_Pos >= BlockX[16]) && (Ball_X_Pos <= (BlockX[16] + BlockS[16]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[16]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[16] + BlockS[16]))))
						|| (((Ball_X_Pos >= BlockX[16]) && (Ball_X_Pos <= (BlockX[16] + BlockS[16]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[16]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[16] + BlockS[16]))));
	 assign block_collision[17] = ((((Ball_X_Pos - Ball_Size) >= BlockX[17]) && ((Ball_X_Pos - Ball_Size) <= (BlockX[17] + BlockS[17]))) && ((Ball_Y_Pos >= BlockY[17]) && (Ball_Y_Pos <= (BlockY[17] + BlockS[17]))))
						|| ((((Ball_X_Pos + Ball_Size) >= BlockX[17]) && ((Ball_X_Pos + Ball_Size) <= (BlockX[17] + BlockS[17]))) && ((Ball_Y_Pos >= BlockY[17]) && (Ball_Y_Pos <= (BlockY[17] + BlockS[17]))))
						|| (((Ball_X_Pos >= BlockX[17]) && (Ball_X_Pos <= (BlockX[17] + BlockS[17]))) && (((Ball_Y_Pos - Ball_Size) >= BlockY[17]) && ((Ball_Y_Pos - Ball_Size) <= (BlockY[17] + BlockS[17]))))
						|| (((Ball_X_Pos >= BlockX[17]) && (Ball_X_Pos <= (BlockX[17] + BlockS[17]))) && (((Ball_Y_Pos + Ball_Size) >= BlockY[17]) && ((Ball_Y_Pos + Ball_Size) <= (BlockY[17] + BlockS[17]))));
	 
	 
	 assign rect_collision[0] = ((((Ball_X_Pos - Ball_Size) >= RectX[0]) && ((Ball_X_Pos - Ball_Size) <= (RectX[0] + RectS[0]))) && ((Ball_Y_Pos >= RectY[0]) && (Ball_Y_Pos <= (RectY[0] + RectS[0]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[0]) && ((Ball_X_Pos + Ball_Size) <= (RectX[0] + RectS[0]))) && ((Ball_Y_Pos >= RectY[0]) && (Ball_Y_Pos <= (RectY[0] + RectS[0]/4))))
						|| (((Ball_X_Pos >= RectX[0]) && (Ball_X_Pos <= (RectX[0] + RectS[0]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[0]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[0] + RectS[0]/4))))
						|| (((Ball_X_Pos >= RectX[0]) && (Ball_X_Pos <= (RectX[0] + RectS[0]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[0]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[0] + RectS[0]/4))));
	 assign rect_collision[1] = ((((Ball_X_Pos - Ball_Size) >= RectX[1]) && ((Ball_X_Pos - Ball_Size) <= (RectX[1] + RectS[1]))) && ((Ball_Y_Pos >= RectY[1]) && (Ball_Y_Pos <= (RectY[1] + RectS[1]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[1]) && ((Ball_X_Pos + Ball_Size) <= (RectX[1] + RectS[1]))) && ((Ball_Y_Pos >= RectY[1]) && (Ball_Y_Pos <= (RectY[1] + RectS[1]/4))))
						|| (((Ball_X_Pos >= RectX[1]) && (Ball_X_Pos <= (RectX[1] + RectS[1]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[1]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[1] + RectS[1]/4))))
						|| (((Ball_X_Pos >= RectX[1]) && (Ball_X_Pos <= (RectX[1] + RectS[1]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[1]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[1] + RectS[1]/4))));
	 assign rect_collision[2] = ((((Ball_X_Pos - Ball_Size) >= RectX[2]) && ((Ball_X_Pos - Ball_Size) <= (RectX[2] + RectS[2]))) && ((Ball_Y_Pos >= RectY[2]) && (Ball_Y_Pos <= (RectY[2] + RectS[2]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[2]) && ((Ball_X_Pos + Ball_Size) <= (RectX[2] + RectS[2]))) && ((Ball_Y_Pos >= RectY[2]) && (Ball_Y_Pos <= (RectY[2] + RectS[2]/4))))
						|| (((Ball_X_Pos >= RectX[2]) && (Ball_X_Pos <= (RectX[2] + RectS[2]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[2]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[2] + RectS[2]/4))))
						|| (((Ball_X_Pos >= RectX[2]) && (Ball_X_Pos <= (RectX[2] + RectS[2]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[2]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[2] + RectS[2]/4))));
	 assign rect_collision[3] = ((((Ball_X_Pos - Ball_Size) >= RectX[3]) && ((Ball_X_Pos - Ball_Size) <= (RectX[3] + RectS[3]))) && ((Ball_Y_Pos >= RectY[3]) && (Ball_Y_Pos <= (RectY[3] + RectS[3]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[3]) && ((Ball_X_Pos + Ball_Size) <= (RectX[3] + RectS[3]))) && ((Ball_Y_Pos >= RectY[3]) && (Ball_Y_Pos <= (RectY[3] + RectS[3]/4))))
						|| (((Ball_X_Pos >= RectX[3]) && (Ball_X_Pos <= (RectX[3] + RectS[3]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[3]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[3] + RectS[3]/4))))
						|| (((Ball_X_Pos >= RectX[3]) && (Ball_X_Pos <= (RectX[3] + RectS[3]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[3]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[3] + RectS[3]/4))));
	 assign rect_collision[4] = ((((Ball_X_Pos - Ball_Size) >= RectX[4]) && ((Ball_X_Pos - Ball_Size) <= (RectX[4] + RectS[4]))) && ((Ball_Y_Pos >= RectY[4]) && (Ball_Y_Pos <= (RectY[4] + RectS[4]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[4]) && ((Ball_X_Pos + Ball_Size) <= (RectX[4] + RectS[4]))) && ((Ball_Y_Pos >= RectY[4]) && (Ball_Y_Pos <= (RectY[4] + RectS[4]/4))))
						|| (((Ball_X_Pos >= RectX[4]) && (Ball_X_Pos <= (RectX[4] + RectS[4]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[4]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[4] + RectS[4]/4))))
						|| (((Ball_X_Pos >= RectX[4]) && (Ball_X_Pos <= (RectX[4] + RectS[4]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[4]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[4] + RectS[4]/4))));
	 assign rect_collision[5] = ((((Ball_X_Pos - Ball_Size) >= RectX[5]) && ((Ball_X_Pos - Ball_Size) <= (RectX[5] + RectS[5]))) && ((Ball_Y_Pos >= RectY[5]) && (Ball_Y_Pos <= (RectY[5] + RectS[5]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[5]) && ((Ball_X_Pos + Ball_Size) <= (RectX[5] + RectS[5]))) && ((Ball_Y_Pos >= RectY[5]) && (Ball_Y_Pos <= (RectY[5] + RectS[5]/4))))
						|| (((Ball_X_Pos >= RectX[5]) && (Ball_X_Pos <= (RectX[5] + RectS[5]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[5]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[5] + RectS[5]/4))))
						|| (((Ball_X_Pos >= RectX[5]) && (Ball_X_Pos <= (RectX[5] + RectS[5]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[5]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[5] + RectS[5]/4))));
	 assign rect_collision[6] = ((((Ball_X_Pos - Ball_Size) >= RectX[6]) && ((Ball_X_Pos - Ball_Size) <= (RectX[6] + RectS[6]))) && ((Ball_Y_Pos >= RectY[6]) && (Ball_Y_Pos <= (RectY[6] + RectS[6]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[6]) && ((Ball_X_Pos + Ball_Size) <= (RectX[6] + RectS[6]))) && ((Ball_Y_Pos >= RectY[6]) && (Ball_Y_Pos <= (RectY[6] + RectS[6]/4))))
						|| (((Ball_X_Pos >= RectX[6]) && (Ball_X_Pos <= (RectX[6] + RectS[6]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[6]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[6] + RectS[6]/4))))
						|| (((Ball_X_Pos >= RectX[6]) && (Ball_X_Pos <= (RectX[6] + RectS[6]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[6]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[6] + RectS[6]/4))));
	 assign rect_collision[7] = ((((Ball_X_Pos - Ball_Size) >= RectX[7]) && ((Ball_X_Pos - Ball_Size) <= (RectX[7] + RectS[7]))) && ((Ball_Y_Pos >= RectY[7]) && (Ball_Y_Pos <= (RectY[7] + RectS[7]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[7]) && ((Ball_X_Pos + Ball_Size) <= (RectX[7] + RectS[7]))) && ((Ball_Y_Pos >= RectY[7]) && (Ball_Y_Pos <= (RectY[7] + RectS[7]/4))))
						|| (((Ball_X_Pos >= RectX[7]) && (Ball_X_Pos <= (RectX[7] + RectS[7]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[7]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[7] + RectS[7]/4))))
						|| (((Ball_X_Pos >= RectX[7]) && (Ball_X_Pos <= (RectX[7] + RectS[7]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[7]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[7] + RectS[7]/4))));
	 assign rect_collision[8] = ((((Ball_X_Pos - Ball_Size) >= RectX[8]) && ((Ball_X_Pos - Ball_Size) <= (RectX[8] + RectS[8]))) && ((Ball_Y_Pos >= RectY[8]) && (Ball_Y_Pos <= (RectY[8] + RectS[8]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[8]) && ((Ball_X_Pos + Ball_Size) <= (RectX[8] + RectS[8]))) && ((Ball_Y_Pos >= RectY[8]) && (Ball_Y_Pos <= (RectY[8] + RectS[8]/4))))
						|| (((Ball_X_Pos >= RectX[8]) && (Ball_X_Pos <= (RectX[8] + RectS[8]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[8]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[8] + RectS[8]/4))))
						|| (((Ball_X_Pos >= RectX[8]) && (Ball_X_Pos <= (RectX[8] + RectS[8]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[8]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[8] + RectS[8]/4))));
	 assign rect_collision[9] = ((((Ball_X_Pos - Ball_Size) >= RectX[9]) && ((Ball_X_Pos - Ball_Size) <= (RectX[9] + RectS[9]))) && ((Ball_Y_Pos >= RectY[9]) && (Ball_Y_Pos <= (RectY[9] + RectS[9]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[9]) && ((Ball_X_Pos + Ball_Size) <= (RectX[9] + RectS[9]))) && ((Ball_Y_Pos >= RectY[9]) && (Ball_Y_Pos <= (RectY[9] + RectS[9]/4))))
						|| (((Ball_X_Pos >= RectX[9]) && (Ball_X_Pos <= (RectX[9] + RectS[9]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[9]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[9] + RectS[9]/4))))
						|| (((Ball_X_Pos >= RectX[9]) && (Ball_X_Pos <= (RectX[9] + RectS[9]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[9]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[9] + RectS[9]/4))));
	 assign rect_collision[10] = ((((Ball_X_Pos - Ball_Size) >= RectX[10]) && ((Ball_X_Pos - Ball_Size) <= (RectX[10] + RectS[10]))) && ((Ball_Y_Pos >= RectY[10]) && (Ball_Y_Pos <= (RectY[10] + RectS[10]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[10]) && ((Ball_X_Pos + Ball_Size) <= (RectX[10] + RectS[10]))) && ((Ball_Y_Pos >= RectY[10]) && (Ball_Y_Pos <= (RectY[10] + RectS[10]/4))))
						|| (((Ball_X_Pos >= RectX[10]) && (Ball_X_Pos <= (RectX[10] + RectS[10]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[10]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[10] + RectS[10]/4))))
						|| (((Ball_X_Pos >= RectX[10]) && (Ball_X_Pos <= (RectX[10] + RectS[10]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[10]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[10] + RectS[10]/4))));
	 assign rect_collision[11] = ((((Ball_X_Pos - Ball_Size) >= RectX[11]) && ((Ball_X_Pos - Ball_Size) <= (RectX[11] + RectS[11]))) && ((Ball_Y_Pos >= RectY[11]) && (Ball_Y_Pos <= (RectY[11] + RectS[11]/4))))
						|| ((((Ball_X_Pos + Ball_Size) >= RectX[11]) && ((Ball_X_Pos + Ball_Size) <= (RectX[11] + RectS[11]))) && ((Ball_Y_Pos >= RectY[11]) && (Ball_Y_Pos <= (RectY[11] + RectS[11]/4))))
						|| (((Ball_X_Pos >= RectX[11]) && (Ball_X_Pos <= (RectX[11] + RectS[11]))) && (((Ball_Y_Pos - Ball_Size) >= RectY[11]) && ((Ball_Y_Pos - Ball_Size) <= (RectY[11] + RectS[11]/4))))
						|| (((Ball_X_Pos >= RectX[11]) && (Ball_X_Pos <= (RectX[11] + RectS[11]))) && (((Ball_Y_Pos + Ball_Size) >= RectY[11]) && ((Ball_Y_Pos + Ball_Size) <= (RectY[11] + RectS[11]/4))));

    always_ff @ (posedge Reset or posedge frame_clk or posedge Collision_other)
    begin: Move_Ball
        if (Reset || Collision_other)  // Asynchronous Reset
        begin 
			if (Reset) begin
				for (int i = 0; i < 30; i++) begin
					paint[i] = 0;
				end
			end
		   Collision = 1'b0;
         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			paint[block_hit_other] <= 0;
			if (color == 1'b1)
			begin
				Ball_X_Pos <= Ball_X_Right;	//red - right - 2'b1
				next_index <= 1;
			end
			else if (color == 1'b0)
			begin
				Ball_X_Pos <= Ball_X_Left;
				next_index <= 31;
			end
        end
		
		 else if(block_collision[0] || block_collision[1] || block_collision[2] || block_collision[3] || block_collision[4] || block_collision[5] || block_collision[6] || block_collision[7] || block_collision[8]
						|| block_collision[9] || block_collision[10] || block_collision[11] || block_collision[12] || block_collision[13] || block_collision[14] || block_collision[15] || block_collision[16]
						|| block_collision[17] || rect_collision[0] || rect_collision[1] || rect_collision[2] || rect_collision[3] || rect_collision[4] || rect_collision[5] || rect_collision[6] || rect_collision[7]
						|| rect_collision[8] || rect_collision[9] || rect_collision[10] || rect_collision[11])
						
			begin 
		   Collision = 1'b1;
         Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			for (int i = 0; i < $size(block_collision); i++) begin
				if (block_collision[i]) begin
						paint[i] = 1;
						block_hit = i;
				end
			end
			for (int j = 0; j < $size(rect_collision); j++) begin
				if (rect_collision[j]) begin
						paint[j+18] = 1;
						block_hit = j+18;
				end
			end
			if (color == 1'b1)
			begin
				Ball_X_Pos <= Ball_X_Right;	//red - right - 2'b1
				next_index <= 1;
			end
			else if (color == 1'b0)
			begin
				Ball_X_Pos <= Ball_X_Left;
				next_index <= 31;
			end
        end
		  
        else 
        begin
				Collision = 1'b0;
				case (keycode)
					default:
						begin
						
							if(Ball_X_Pos <= Ball_X_Center)
								Ball_X_Motion = Ball_X_Center - cosine_val*radius/1000;
							else
								Ball_X_Motion = Ball_X_Center + cosine_val * radius/1000;
							if(Ball_Y_Pos >= Ball_Y_Center)
								Ball_Y_Motion = Ball_Y_Center + sine_val * radius/1000;
							else
								Ball_Y_Motion = Ball_Y_Center - sine_val * radius/1000;

						end
						
						7:		//right key
						begin
							if (index == 60)
							begin
								next_index = 1;
								Ball_X_Motion = Ball_X_Center + zero_cosine_val*radius/1000;
								Ball_Y_Motion = Ball_Y_Center + zero_sine_val*radius/1000;
							end
							else
							begin
								next_index = index + 1;
								if (index > 0 && index < 16)
									begin
									Ball_X_Motion = Ball_X_Center + up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + up_sine_val*radius/1000;
									end
								else if (index >= 16 && index <= 30)
									begin
									Ball_X_Motion = Ball_X_Center - up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + up_sine_val*radius/1000;
									end
								else if (index > 30 && index < 46)
									begin
									Ball_X_Motion = Ball_X_Center - up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - up_sine_val*radius/1000;
									end
								else if (index >= 46)
									begin
									Ball_X_Motion = Ball_X_Center + up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - up_sine_val*radius/1000;
									end
							end
							
						end
					4:		//left key
					
						begin
							if (index == 1)
							begin
								next_index = 60;
								Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
								Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
							end	
								
							else
							begin
								next_index = index - 1;
								if (index > 0 && index < 16)
									begin
									Ball_X_Motion = Ball_X_Center + down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + down_sine_val*radius/1000;
									end
								else if (index >= 16 && index <= 30)
									begin
									Ball_X_Motion = Ball_X_Center - down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + down_sine_val*radius/1000;
									end
								else if (index > 30 && index < 46)
									begin
									Ball_X_Motion = Ball_X_Center - down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - down_sine_val*radius/1000;
									end
								else if (index >= 46)
									begin
									Ball_X_Motion = Ball_X_Center + down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - down_sine_val*radius/1000;
									end
							end
						end
				 endcase
					/*
					7:		//right key
						begin
							if (index == 31)
							begin
								next_index = 1;
								
								if((Ball_Y_Pos <= Ball_Y_Center && (index < 16 || index > 30)) || (Ball_X_Pos <= Ball_X_Center && (index < 16 || index > 30))) //Ball_X_Pos < Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - zero_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - zero_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos < Ball_Y_Center && 16 <= index && index < 30) || (Ball_X_Pos > Ball_X_Center && index > 16 && index < 30))//Ball_X_Pos >= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + zero_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - zero_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos >= Ball_Y_Center && (index < 16 || index > 30)) || (Ball_X_Pos > Ball_X_Center && (index < 16 || index > 30)))//Ball_X_Pos > Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + zero_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + zero_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos > Ball_Y_Center && 16 <= index && index < 30) || (Ball_X_Pos < Ball_X_Center && index > 16 && index < 30)) //Ball_X_Pos <= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - zero_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + zero_sine_val*radius/1000;
									end


							end
							else
							begin
								next_index = index + 1;
								if((Ball_Y_Pos <= Ball_Y_Center && (index < 16 || index > 30)) || (Ball_X_Pos <= Ball_X_Center && (index < 16 || index > 30))) //if(Ball_Y_Pos <= Ball_Y_Center && index < 16)//Ball_X_Pos < Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - up_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos < Ball_Y_Center && 16 <= index && index < 30) || (Ball_X_Pos > Ball_X_Center && index > 16 && index < 30))//else if (Ball_Y_Pos < Ball_Y_Center && index >= 16) //Ball_X_Pos >= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - up_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos >= Ball_Y_Center && (index < 16 || index > 30)) || (Ball_X_Pos > Ball_X_Center && (index < 16 || index > 30)))//else if (Ball_Y_Pos >= Ball_Y_Center && index < 16) //Ball_X_Pos > Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + up_sine_val*radius/1000;
									end
								else if ((Ball_Y_Pos > Ball_Y_Center && 16 <= index && index < 30) || (Ball_X_Pos < Ball_X_Center && index > 16 && index < 30))//else if (Ball_Y_Pos > Ball_Y_Center && index >= 16) //Ball_X_Pos <= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - up_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + up_sine_val*radius/1000;
									end
							end
							
						end
					4:		//left key
					
						begin
							if (index == 1)
							begin
								next_index = 31;
								
								if(Ball_Y_Pos < Ball_Y_Center && index <=16) // Ball_X_Pos <= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos <= Ball_Y_Center && index >16) //Ball_X_Pos > Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos > Ball_Y_Center && index <=16) //Ball_X_Pos >= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos >= Ball_Y_Center && index >16) //Ball_X_Pos < Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
									end

							end
							else
							begin
								next_index = index - 1;
								if(Ball_Y_Pos < Ball_Y_Center && Ball_X_Pos <= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - down_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos <= Ball_Y_Center && Ball_X_Pos > Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center - down_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos > Ball_Y_Center && Ball_X_Pos >= Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center + down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + down_sine_val*radius/1000;
									end
								else if (Ball_Y_Pos >= Ball_Y_Center && Ball_X_Pos < Ball_X_Center)
									begin
									Ball_X_Motion = Ball_X_Center - down_cosine_val*radius/1000;
									Ball_Y_Motion = Ball_Y_Center + down_sine_val*radius/1000;
									end
							end
					
							
						end
				 endcase
					*/
					/*
					7:		//right key
						begin
							if (index == 31)
							begin
								next_index = 1;
								if(Ball_Y_Pos < Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center + zero_cosine_val*radius/1000;
								else if(Ball_Y_Pos > Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center - zero_cosine_val*radius/1000;
								if(Ball_X_Pos < Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center - zero_sine_val*radius/1000;
								else if(Ball_Y_Pos > Ball_Y_Center)
									Ball_Y_Motion = Ball_Y_Center + zero_sine_val*radius/1000;
								if (Ball_X_Pos == Ball_X_Center)
									begin
									if (Ball_Y_Pos < Ball_Y_Center)
										begin
										//decrease x & y
										Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
										end
									else
										begin
										//increase x & y
										Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
										end
									end
								if (Ball_Y_Pos == Ball_Y_Center)
								begin
									if (Ball_X_Pos < Ball_X_Center)
										//increase y, decrease x
										begin
										Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
										end
									else
										//decrease y, increase x
										begin
										Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
										Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
										end
								end
							end
							else
							begin
								next_index = index + 1;
								if(Ball_Y_Pos < Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center + up_cosine_val*radius/1000;
								else if(Ball_Y_Pos > Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center - up_cosine_val*radius/1000;
								if(Ball_X_Pos < Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center - up_sine_val*radius/1000;
								else if(Ball_X_Pos > Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center + up_sine_val*radius/1000;
							end
							
						end
					4:		//left key
					
						begin
							if (index == 1)
							begin
								next_index = 31;
								if(Ball_Y_Pos < Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
								else if(Ball_Y_Pos > Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
								if(Ball_X_Pos < Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
								else if(Ball_X_Pos > Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
								if (Ball_X_Pos == Ball_X_Center)
									begin
									if (Ball_Y_Pos < Ball_Y_Center)
										begin
										//decrease x & y
										Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
										end
									else
										begin
										//increase x & y
										Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
										end
									end
								if (Ball_Y_Pos == Ball_Y_Center)
								begin
									if (Ball_X_Pos < Ball_X_Center)
										//increase y, decrease x
										begin
										Ball_X_Motion = Ball_X_Center + last_cosine_val*radius/1000;
										Ball_Y_Motion = Ball_Y_Center + last_sine_val*radius/1000;
										end
									else
										//decrease y, increase x
										begin
										Ball_Y_Motion = Ball_Y_Center - last_sine_val*radius/1000;
										Ball_X_Motion = Ball_X_Center - last_cosine_val*radius/1000;
										end
								end
							end
							else
							begin
								next_index = index - 1;
								if(Ball_Y_Pos < Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center - down_cosine_val*radius/1000;
								else if(Ball_Y_Pos > Ball_Y_Center)
									Ball_X_Motion = Ball_X_Center + down_cosine_val*radius/1000;
								if(Ball_X_Pos < Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center + down_sine_val*radius/1000;
								else if(Ball_X_Pos > Ball_X_Center)
									Ball_Y_Motion = Ball_Y_Center - down_sine_val*radius/1000;

							end
					
							
						end
				 endcase	*/	
				/*
				 case (keycode)
					default:
						begin
							Ball_X_Motion = Ball_X_Center + cosine_val * radius/1000;
							Ball_Y_Motion = Ball_Y_Center + sine_val * radius/1000;
						end
					7:		//right key
						begin
							prev_index = index;
							//defaults??
							if (index == 59)
							begin
								next_index = 1;
								Ball_X_Motion = Ball_X_Center + (zero_cosine_val) * radius/1000;
								Ball_Y_Motion = Ball_Y_Center + (zero_sine_val) * radius/1000;
							end
							else 
							begin
								next_index = index + 1;
								Ball_X_Motion = Ball_X_Center + (up_cosine_val) * radius / 1000;
								Ball_Y_Motion = Ball_Y_Center + (up_sine_val) * radius / 1000;
							end
						end
				 4:		//left key
						begin
							prev_index = index;
							if (index == 1)
							begin
								next_index = 59;
								Ball_X_Motion = Ball_X_Center + (last_cosine_val) * radius/1000;
								Ball_Y_Motion = Ball_Y_Center + (last_sine_val) * radius/1000;
							end
							else
							begin
								next_index = index - 1;
								Ball_X_Motion = Ball_X_Center + (down_cosine_val)* radius/1000;
								Ball_Y_Motion = Ball_Y_Center + (down_sine_val) * radius/1000;
							end
							
						end
				 endcase
				 */
				/*
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
				 */
				 
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
			Ball_Y_Pos = Ball_Y_Motion;  // Update ball position
			Ball_X_Pos = Ball_X_Motion;
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
