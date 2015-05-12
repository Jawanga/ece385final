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
							  input			[9:0] BlockX [0:17], BlockY [0:17], Block_size [0:17], DrawX, DrawY,
							  input			block_ready [0:17],
							  input			[9:0] RectX [0:11], RectY[0:11], Rect_size[0:11],
							  input			rect_ready [0:11],
							  input			level_one, level_two, title, win, pstart, level_final, hidden,
							  input			blue_paint [0:29], orange_paint [0:29],
                       output logic [7:0]  Red, Green, Blue);
    
    logic ball_red_on, ball_blue_on, block_on [0:17];
	 logic blocks_on;

	 logic rect_on [0:11];
	 
	 logic L_on;
	 logic [10:0] L_X = 230;
	 logic [10:0] L_Y = 80;
	 logic [10:0] L_size_X = 8;
	 logic [10:0] L_size_Y = 16;
	 
	 logic E_on;
	 logic [10:0] E_X = 250;
	 logic [10:0] E_Y = 80;
	 logic [10:0] E_size_X = 8;
	 logic [10:0] E_size_Y = 16;
	 
	 logic V_on;
	 logic [10:0] V_X = 270;
	 logic [10:0] V_Y = 80;
	 logic [10:0] V_size_X = 8;
	 logic [10:0] V_size_Y = 16;
	 
	 logic E2_on;
	 logic [10:0] E2_X = 290;
	 logic [10:0] E2_Y = 80;
	 logic [10:0] E2_size_X = 8;
	 logic [10:0] E2_size_Y = 16;
	 
	 logic L2_on;
	 logic [10:0] L2_X = 310;
	 logic [10:0] L2_Y = 80;
	 logic [10:0] L2_size_X = 8;
	 logic [10:0] L2_size_Y = 16;
	 
	 logic O_on;
	 logic [10:0] O_X = 360;
	 logic [10:0] O_Y = 80;
	 logic [10:0] O_size_X = 8;
	 logic [10:0] O_size_Y = 16;
	 
	 logic N_on;
	 logic [10:0] N_X = 380;
	 logic [10:0] N_Y = 80;
	 logic [10:0] N_size_X = 8;
	 logic [10:0] N_size_Y = 16;
	 
	 logic E3_on;
	 logic [10:0] E3_X = 400;
	 logic [10:0] E3_Y = 80;
	 logic [10:0] E3_size_X = 8;
	 logic [10:0] E3_size_Y = 16;
	 
	 logic T_on;
	 logic [10:0] T_X = 360;
	 logic [10:0] T_Y = 80;
	 logic [10:0] T_size_X = 8;
	 logic [10:0] T_size_Y = 16;
	 
	 logic W_on;
	 logic [10:0] W_X = 380;
	 logic [10:0] W_Y = 80;
	 logic [10:0] W_size_X = 8;
	 logic [10:0] W_size_Y = 16;
	 
	 logic O2_on;
	 logic [10:0] O2_X = 400;
	 logic [10:0] O2_Y = 80;
	 logic [10:0] O2_size_X = 8;
	 logic [10:0] O2_size_Y = 16;
	 
	 logic H_on;
	 logic [10:0] H_X = 360;
	 logic [10:0] H_Y = 80;
	 logic [10:0] H_size_X = 8;
	 logic [10:0] H_size_Y = 16;
	 
	 logic T2_on;
	 logic [10:0] T2_X = 340;
	 logic [10:0] T2_Y = 80;
	 logic [10:0] T2_size_X = 8;
	 logic [10:0] T2_size_Y = 16;
	 
	 logic R_on;
	 logic [10:0] R_X = 380;
	 logic [10:0] R_Y = 80;
	 logic [10:0] R_size_X = 8;
	 logic [10:0] R_size_Y = 16;
	 
	 logic E4_on;
	 logic [10:0] E4_X = 400;
	 logic [10:0] E4_Y = 80;
	 logic [10:0] E4_size_X = 8;
	 logic [10:0] E4_size_Y = 16;
	 
	 logic E5_on;
	 logic [10:0] E5_X = 420;
	 logic [10:0] E5_Y = 80;
	 logic [10:0] E5_size_X = 8;
	 logic [10:0] E5_size_Y = 16;
	 
	 logic title_on;
	 logic [10:0] title_X = 300;
	 logic [10:0] title_Y = 80;
	 logic [10:0] title_size_X = 41;
	 logic [10:0] title_size_Y = 16;
	 
	 logic pstart_on;
	 logic [10:0] pstart_X = 265;
	 logic [10:0] pstart_Y = 235;
	 logic [10:0] pstart_size_X = 110;
	 logic [10:0] pstart_size_Y = 16;
	 
	 logic win_on;
	 logic [10:0] win_X = 290;
	 logic [10:0] win_Y = 235;
	 logic [10:0] win_size_X = 65;
	 logic [10:0] win_size_Y = 16;
	 
	 logic [10:0] sprite_addr;
	 logic [0:7] sprite_data;
	 logic [3:0] title_addr;
	 logic [0:40] title_data;
	 logic [3:0] pstart_addr;
	 logic [0:109] pstart_data;
	 logic [3:0] win_addr;
	 logic [0:64] win_data;
	 
	 font_rom sprite(.addr(sprite_addr), .data(sprite_data));
	 title_rom title_screen(.addr(title_addr), .data(title_data));
	 pstart_rom press_start(.addr(pstart_addr), .data(pstart_data));
	 win_rom winner(.addr(win_addr), .data(win_data));
	 
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
	 int BlockDistX [0:17], BlockDistY [0:17];
	 int RectDistX [0:11], RectDistY[0:11];
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
	 assign BlockDistX[5] = DrawX - BlockX[5];
	 assign BlockDistY[5] = DrawY - BlockY[5];
	 assign BlockDistX[6] = DrawX - BlockX[6];
	 assign BlockDistY[6] = DrawY - BlockY[6];
	 assign BlockDistX[7] = DrawX - BlockX[7];
	 assign BlockDistY[7] = DrawY - BlockY[7];
	 assign BlockDistX[8] = DrawX - BlockX[8];
	 assign BlockDistY[8] = DrawY - BlockY[8];
	 assign BlockDistX[9] = DrawX - BlockX[9];
	 assign BlockDistY[9] = DrawY - BlockY[9];
	 assign BlockDistX[10] = DrawX - BlockX[10];
	 assign BlockDistY[10] = DrawY - BlockY[10];
	 assign BlockDistX[11] = DrawX - BlockX[11];
	 assign BlockDistY[11] = DrawY - BlockY[11];
	 assign BlockDistX[12] = DrawX - BlockX[12];
	 assign BlockDistY[12] = DrawY - BlockY[12];
	 assign BlockDistX[13] = DrawX - BlockX[13];
	 assign BlockDistY[13] = DrawY - BlockY[13];
	 assign BlockDistX[14] = DrawX - BlockX[14];
	 assign BlockDistY[14] = DrawY - BlockY[14];
	 assign BlockDistX[15] = DrawX - BlockX[15];
	 assign BlockDistY[15] = DrawY - BlockY[15];
	 assign BlockDistX[16] = DrawX - BlockX[16];
	 assign BlockDistY[16] = DrawY - BlockY[16];
	 assign BlockDistX[17] = DrawX - BlockX[17];
	 assign BlockDistY[17] = DrawY - BlockY[17];
	 
	 assign RectDistX[0] = DrawX - RectX[0];
	 assign RectDistY[0] = DrawY - RectY[0];
	 assign RectDistX[1] = DrawX - RectX[1];
	 assign RectDistY[1] = DrawY - RectY[1];
	 assign RectDistX[2] = DrawX - RectX[2];
	 assign RectDistY[2] = DrawY - RectY[2];
	 assign RectDistX[3] = DrawX - RectX[3];
	 assign RectDistY[3] = DrawY - RectY[3];
	 assign RectDistX[4] = DrawX - RectX[4];
	 assign RectDistY[4] = DrawY - RectY[4];
	 assign RectDistX[5] = DrawX - RectX[5];
	 assign RectDistY[5] = DrawY - RectY[5];
	 assign RectDistX[6] = DrawX - RectX[6];
	 assign RectDistY[6] = DrawY - RectY[6];
	 assign RectDistX[7] = DrawX - RectX[7];
	 assign RectDistY[7] = DrawY - RectY[7];
	 assign RectDistX[8] = DrawX - RectX[8];
	 assign RectDistY[8] = DrawY - RectY[8];
	 assign RectDistX[9] = DrawX - RectX[9];
	 assign RectDistY[9] = DrawY - RectY[9];
	 assign RectDistX[10] = DrawX - RectX[10];
	 assign RectDistY[10] = DrawY - RectY[10];
	 assign RectDistX[11] = DrawX - RectX[11];
	 assign RectDistY[11] = DrawY - RectY[11];
	 
    assign BlueSize = Ball_size[0];
	 assign RedSize = Ball_size[1];
	 
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
		for (int i = 0; i < $size(BlockDistX); i++) begin
		  if ( (BlockDistX[i] <= Block_size[i]) && (BlockDistY[i] <= Block_size[i]) )
				block_on[i] = 1'b1;
		  else
				block_on[i] = 1'b0;
		end
	 end
	/*
	always_comb
	begin:Collision_block
		Collision = 1'b0;
		for (int k = 0; k < $size(BlockDistX); k++) begin
			if ((ball_blue_on && block_on[k]) || (ball_red_on && block_on[k])) begin
				Collision = 1'b1;
			end
		end
	end
	*/
	
	 always_comb
	 begin:Rect_on_proc
		for (int j = 0; j < $size(RectDistX); j++) begin
			if ((RectDistX[j] <= Rect_size[j]) && (RectDistY[j] <= Rect_size[j]/4))
				rect_on[j] = 1'b1;
			else
				rect_on[j] = 1'b0;
		end
	 end
	 
	 always_comb
	 begin:lvl1_on_proc
			L_on = 1'b0;
			E_on = 1'b0;
			V_on = 1'b0;
			E2_on = 1'b0;
			L2_on = 1'b0;
			O_on = 1'b0;
			N_on = 1'b0;
			E3_on = 1'b0;
			T_on = 1'b0;
			W_on = 1'b0;
			O2_on = 1'b0;
			T2_on = 1'b0;
			H_on = 1'b0;
			R_on = 1'b0;
			E4_on = 1'b0;
			E5_on = 1'b0;
			title_on = 1'b0;
			pstart_on = 1'b0;
			win_on = 1'b0;
			sprite_addr = 10'b0;
			title_addr = 4'b0;
			pstart_addr = 4'b0;
			win_addr = 4'b0;
			
		if(DrawX >= title_X && DrawX < title_X + title_size_X && DrawY >= title_Y && DrawY < title_Y + title_size_Y && title) begin
			title_on = 1'b1;
			title_addr = (DrawY - title_Y);
		end
		else if(DrawX >= pstart_X && DrawX < pstart_X + pstart_size_X && DrawY >= pstart_Y && DrawY < pstart_Y + pstart_size_Y && title && pstart) begin
			pstart_on = 1'b1;
			pstart_addr = (DrawY - pstart_Y);
		end
		else if(DrawX >= win_X && DrawX < win_X + win_size_X && DrawY >= win_Y && DrawY < win_Y + win_size_Y && win) begin
			win_on = 1'b1;
			win_addr = (DrawY - win_Y);
		end
		else if (DrawX >= L_X && DrawX < L_X + L_size_X && DrawY >= L_Y && DrawY < L_Y + L_size_Y && (level_one || level_two || level_final)) begin
			L_on = 1'b1;
			sprite_addr = (DrawY - L_Y + 16*'h4c);
		end
		else if (DrawX >= E_X && DrawX < E_X + E_size_X && DrawY >= E_Y && DrawY < E_Y + E_size_Y && (level_one || level_two || level_final)) begin
			E_on = 1'b1;
			sprite_addr = (DrawY - E_Y + 16*'h45);
		end
		else if (DrawX >= V_X && DrawX < V_X + V_size_X && DrawY >= V_Y && DrawY < V_Y + V_size_Y && (level_one || level_two || level_final)) begin
			V_on = 1'b1;
			sprite_addr = (DrawY - V_Y + 16*'h56);
		end
		else if (DrawX >= E2_X && DrawX < E2_X + E2_size_X && DrawY >= E2_Y && DrawY < E2_Y + E2_size_Y && (level_one || level_two || level_final)) begin
			E2_on = 1'b1;
			sprite_addr = (DrawY - E2_Y + 16*'h45);
		end
		else if (DrawX >= L2_X && DrawX < L2_X + L2_size_X && DrawY >= L2_Y && DrawY < L2_Y + L2_size_Y && (level_one || level_two || level_final)) begin
			L2_on = 1'b1;
			sprite_addr = (DrawY - L2_Y + 16*'h4c);
		end
		else if (DrawX >= O_X && DrawX < O_X + O_size_X && DrawY >= O_Y && DrawY < O_Y + O_size_Y && level_one) begin
			O_on = 1'b1;
			sprite_addr = (DrawY - O_Y + 16*'h4f);
		end
		else if (DrawX >= N_X && DrawX < N_X + N_size_X && DrawY >= N_Y && DrawY < N_Y + N_size_Y && level_one) begin
			N_on = 1'b1;
			sprite_addr = (DrawY - N_Y + 16*'h4e);
		end
		else if (DrawX >= E3_X && DrawX < E3_X + E3_size_X && DrawY >= E3_Y && DrawY < E3_Y + E3_size_Y && level_one) begin
			E3_on = 1'b1;
			sprite_addr = (DrawY - E3_Y + 16*'h45);
		end
		else if (DrawX >= T_X && DrawX < T_X + T_size_X && DrawY >= T_Y && DrawY < T_Y + T_size_Y && level_two) begin
			T_on = 1'b1;
			sprite_addr = (DrawY - T_Y + 16*'h54);
		end
		else if (DrawX >= W_X && DrawX < W_X + W_size_X && DrawY >= W_Y && DrawY < W_Y + W_size_Y && level_two) begin
			W_on = 1'b1;
			sprite_addr = (DrawY - W_Y + 16*'h57);
		end
		else if (DrawX >= O2_X && DrawX < O2_X + O2_size_X && DrawY >= O2_Y && DrawY < O2_Y + O2_size_Y && level_two) begin
			O2_on = 1'b1;
			sprite_addr = (DrawY - O2_Y + 16*'h4f);
		end
		else if (DrawX >= T2_X && DrawX < T2_X + T2_size_X && DrawY >= T2_Y && DrawY < T2_Y + T2_size_Y && level_final) begin
			T2_on = 1'b1;
			sprite_addr = (DrawY - T2_Y + 16*'h54);
		end
		else if (DrawX >= H_X && DrawX < H_X + H_size_X && DrawY >= H_Y && DrawY < H_Y + H_size_Y && level_final) begin
			H_on = 1'b1;
			sprite_addr = (DrawY - H_Y + 16*'h48);
		end
		else if (DrawX >= R_X && DrawX < R_X + R_size_X && DrawY >= R_Y && DrawY < R_Y + R_size_Y && level_final) begin
			R_on = 1'b1;
			sprite_addr = (DrawY - R_Y + 16*'h52);
		end
		else if (DrawX >= E4_X && DrawX < E4_X + E4_size_X && DrawY >= E4_Y && DrawY < E4_Y + E4_size_Y && level_final) begin
			E4_on = 1'b1;
			sprite_addr = (DrawY - E4_Y + 16*'h45);
		end
		else if (DrawX >= E5_X && DrawX < E5_X + E5_size_X && DrawY >= E5_Y && DrawY < E5_Y + E5_size_Y && level_final) begin
			E5_on = 1'b1;
			sprite_addr = (DrawY - E5_Y + 16*'h45);
		end
	end
       
    always_comb
    begin:RGB_Display
		
		Red = 8'h4f - DrawX[9:3];
		Green = 8'h00;
		Blue = 8'h44;
		
		if (DrawX < 150 || DrawX > 490) begin
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
		
		for (int i = 0; i < $size(block_on); i++) begin
			if (block_on[i] && block_ready[i])
			begin
			
				if (blue_paint[i]) begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'hff;
				end
				else if (orange_paint[i]) begin
					Red = 8'hff;
					Green = 8'ha5;
					Blue = 8'h00;
				end
				else begin
					if (i >= 14 && i <= 17) begin
						if (hidden) begin
							Red = 8'h4f - DrawX[9:3];
							Green = 8'h00;
							Blue = 8'h44;
						end
						else begin
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						end
					end
					else begin
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
					end
				end
			
			/*
			Red = 8'hff;
			Green = 8'h00;
			Blue = 8'hff;
			*/
			end
		end
		
		for (int i = 0; i < $size(rect_on); i++) begin
			if (rect_on[i] && rect_ready[i])
			begin
			
				if (blue_paint[i+14]) begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'hff;
				end
				else if (orange_paint[i+14]) begin
					Red = 8'hff;
					Green = 8'ha5;
					Blue = 8'h00;
				end
				else begin
					if (i >= 6 && i <= 11) begin
						if (hidden) begin
							Red = 8'h4f - DrawX[9:3];
							Green = 8'h00;
							Blue = 8'h44;
						end
						else begin
							Red = 8'hff;
							Green = 8'h00;
							Blue = 8'hff;
						end
					end
					else begin
						Red = 8'hff;
						Green = 8'h00;
						Blue = 8'hff;
					end
				end
			
			/*
			Red = 8'hff;
			Green = 8'h00;
			Blue = 8'hff;
			*/
			end
		end
		
		if (ball_red_on == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'ha5;
			Blue = 8'h00;
		end
		
		if (ball_blue_on == 1'b1)
        begin 
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
		end
		
		if ((title_on == 1'b1) && title_data[DrawX - title_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((pstart_on == 1'b1) && pstart_data[DrawX - pstart_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((win_on == 1'b1) && win_data[DrawX - win_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((L_on == 1'b1) && sprite_data[DrawX - L_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((E_on == 1'b1) && sprite_data[DrawX - E_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((V_on == 1'b1) && sprite_data[DrawX - V_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((E2_on == 1'b1) && sprite_data[DrawX - E2_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((L2_on == 1'b1) && sprite_data[DrawX - L2_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((O_on == 1'b1) && sprite_data[DrawX - O_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((N_on == 1'b1) && sprite_data[DrawX - N_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((E3_on == 1'b1) && sprite_data[DrawX - E3_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((T_on == 1'b1) && sprite_data[DrawX - T_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((W_on == 1'b1) && sprite_data[DrawX - W_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((O2_on == 1'b1) && sprite_data[DrawX - O2_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((T2_on == 1'b1) && sprite_data[DrawX - T2_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((H_on == 1'b1) && sprite_data[DrawX - H_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((R_on == 1'b1) && sprite_data[DrawX - R_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		
		if ((E4_on == 1'b1) && sprite_data[DrawX - E4_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
			
		if ((E5_on == 1'b1) && sprite_data[DrawX - E5_X] == 1'b1)
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
    end
    
endmodule
