module block_SM (input Clk, Reset, Run,
					  input Collision [0:1],
					  input end_level [0:19],
					  input [7:0] keycode,
					  output logic block_ready [0:13],
					  output logic rect_ready [0:5],
					  output logic title, pstart, level_one, level_two, restart,
					  output logic [9:0] seconds);

		enum logic [4:0] {RESET, LEVEL1, LEVEL2, MID1TO2, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5, BLOCK6, BLOCK7, BLOCK8, BLOCK9, BLOCK10, BLOCK11, BLOCK12, BLOCK13, BLOCK14, BLOCK15,
								BLOCK16, BLOCK17, BLOCK18, BLOCK19, BLOCK20} state, next_state;
		
		logic [27:0] counter;
		logic [27:0] pstart_counter;
		//logic [9:0] seconds;
		
		initial begin
			state = RESET;
			next_state = RESET;
		end
		
		always_ff @ (posedge Clk or posedge Reset or posedge Collision[0] or posedge Collision[1]) begin
			if (Reset) begin
				state <= RESET;
				counter <= 0;
				seconds <= 0;
			end
			else if (Collision[0] || Collision[1]) begin
				state <= next_state;
				counter <= 0;
				seconds <= 0;
			end
			else begin
				state <= next_state;
				if (state == BLOCK10) begin
					seconds <= 0;
					counter <= 0;
				end
				else if (counter == 50000000 && state != RESET)
				begin
					counter <= 0;
					seconds <= seconds + 1;
				end
				else if (state == RESET) begin
					if (pstart_counter == 50000000) begin
						pstart <= ~pstart;
						pstart_counter <= 0;
						end
					else
						pstart_counter <= pstart_counter + 1;
					seconds <= 0;
					counter <= 0;
				end
				else
					counter <= counter + 1;
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					if (keycode == 40)
						next_state <= LEVEL1;
				end
				LEVEL1: begin
					if (seconds == 1)
						next_state <= BLOCK1;
				end
				BLOCK1: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 3)
						next_state <= BLOCK2;
				end
				BLOCK2: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 5)
						next_state <= BLOCK3;
				end
				BLOCK3: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 7)
						next_state <= BLOCK4;
				end
				BLOCK4: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 9)
						next_state <= BLOCK5;
				end
				BLOCK5: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 11)
						next_state <= BLOCK6;
				end
				BLOCK6: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 13)
						next_state <= BLOCK7;
				end
				BLOCK7: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 15)
						next_state <= BLOCK8;
				end
				BLOCK8: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 17)
						next_state <= BLOCK9;
				end
				BLOCK9: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (seconds == 19)
						next_state <= BLOCK10;
				end
				BLOCK10: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK1;
					else if (end_level[9])
						next_state <= MID1TO2;
				end
				MID1TO2: begin
					if (seconds == 3)
						next_state <= LEVEL2;
				end
				LEVEL2: begin
					if (seconds == 5)
						next_state <= BLOCK11;
				end
				BLOCK11: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 7)
						next_state <= BLOCK12;
				end
				BLOCK12: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 9)
						next_state <= BLOCK13;
				end
				BLOCK13: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 11)
						next_state <= BLOCK14;
				end
				BLOCK14: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 13)
						next_state <= BLOCK15;
				end
				BLOCK15: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 15)
						next_state <= BLOCK16;
				end
				BLOCK16: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 17)
						next_state <= BLOCK17;
				end
				BLOCK17: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 19)
						next_state <= BLOCK18;
				end
				BLOCK18: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 21)
						next_state <= BLOCK19;
				end
				BLOCK19: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (seconds == 23)
						next_state <= BLOCK20;
				end
				BLOCK20: begin
					if (Collision[0] || Collision[1])
						next_state <= BLOCK11;
					else if (end_level[19])
						next_state <= RESET;
				end
					
			endcase
		end
		
		always_comb begin
			for (int i = 0; i < $size(block_ready); i++) begin
				block_ready[i] = 0;
			end
			for (int i = 0; i < $size(rect_ready); i++) begin
				rect_ready[i] = 0;
			end
			title = 0;
			level_one = 0;
			level_two = 0;
			restart = 0;
			case (state)
					RESET: begin
						title = 1;
						restart = 1;
					end
					LEVEL1:
						level_one = 1;
					BLOCK1:
						block_ready[0] = 1;
					BLOCK2: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
					end
					BLOCK3: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
					end
					BLOCK4: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
					end
					BLOCK5: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
					end
					BLOCK6: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
					end
					BLOCK7: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
					end
					BLOCK8: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
						block_ready[7] = 1;
					end
					BLOCK9: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
						block_ready[7] = 1;
						block_ready[8] = 1;
					end
					BLOCK10: begin
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
						block_ready[7] = 1;
						block_ready[8] = 1;
						block_ready[9] = 1;
					end
					MID1TO2: begin
						level_two = 1;
					end
					BLOCK11: begin
						rect_ready[0] = 1;
					end
					BLOCK12: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
					end
					BLOCK13: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
					end
					BLOCK14: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
					end
					BLOCK15: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
					end
					BLOCK16: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
						rect_ready[3] = 1;
					end
					BLOCK17: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
						rect_ready[3] = 1;
						block_ready[12] = 1;
					end
					BLOCK18: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
						rect_ready[3] = 1;
						block_ready[12] = 1;
						rect_ready[4] = 1;
					end
					BLOCK19: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
						rect_ready[3] = 1;
						block_ready[12] = 1;
						rect_ready[4] = 1;
						rect_ready[5] = 1;
					end
					BLOCK20: begin
						rect_ready[0] = 1;
						rect_ready[1] = 1;
						rect_ready[2] = 1;
						block_ready[10] = 1;
						block_ready[11] = 1;
						rect_ready[3] = 1;
						block_ready[12] = 1;
						rect_ready[4] = 1;
						rect_ready[5] = 1;
						block_ready[13] = 1;
					end
					
			endcase
			
		end
		
endmodule
