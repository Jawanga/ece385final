module block_SM (input Clk, Reset, Run,
					  input Collision [0:1],
					  input end_level [0:29],
					  input [7:0] keycode,
					  output logic block_ready [0:17],
					  output logic rect_ready [0:11],
					  output logic title, pstart, level_one, level_two, restart, level_final, win, hidden,
					  output logic [9:0] seconds);

		enum logic [5:0] {RESET, LEVEL1, LEVEL2, FINAL, WIN, MID1TO2, MID2TOFINAL, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5, BLOCK6, BLOCK7, BLOCK8, BLOCK9, BLOCK10, BLOCK11, BLOCK12, BLOCK13, BLOCK14, BLOCK15,
								BLOCK16, BLOCK17, BLOCK18, BLOCK19, BLOCK20, BLOCK21, BLOCK22, BLOCK23, BLOCK24, BLOCK25, BLOCK26, BLOCK27, BLOCK28, BLOCK29, BLOCK30} state, next_state;
		
		logic [27:0] counter;
		logic [27:0] pstart_counter;
		logic [27:0] hidden_counter;
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
				if (state == FINAL) begin
					hidden <= 0;
					hidden_counter <= 0;
				end
				
				if (hidden_counter == 25000000) begin
					hidden <= ~hidden;
					hidden_counter <= 0;
				end
				
				else
					hidden_counter <= hidden_counter + 1;
				
				if (state == BLOCK10 || state == BLOCK20 || state == BLOCK30) begin
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
						next_state <= LEVEL2;
					else if (seconds == 6)
						next_state <= BLOCK12;
				end
				BLOCK12: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 7)
						next_state <= BLOCK13;
				end
				BLOCK13: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 8)
						next_state <= BLOCK14;
				end
				BLOCK14: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 9)
						next_state <= BLOCK15;
				end
				BLOCK15: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 10)
						next_state <= BLOCK16;
				end
				BLOCK16: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 11)
						next_state <= BLOCK17;
				end
				BLOCK17: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 12)
						next_state <= BLOCK18;
				end
				BLOCK18: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 13)
						next_state <= BLOCK19;
				end
				BLOCK19: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (seconds == 14)
						next_state <= BLOCK20;
				end
				BLOCK20: begin
					if (Collision[0] || Collision[1])
						next_state <= LEVEL2;
					else if (end_level[19])
						next_state <= MID2TOFINAL;
				end
				MID2TOFINAL: begin
					if (seconds == 3)
						next_state <= FINAL;
				end
				FINAL: begin
					if (seconds == 5)
						next_state <= BLOCK21;
				end
				BLOCK21: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 6)
						next_state <= BLOCK22;
				end
				BLOCK22: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 7)
						next_state <= BLOCK23;
				end
				BLOCK23: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 8)
						next_state <= BLOCK24;
				end
				BLOCK24: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 9)
						next_state <= BLOCK25;
				end
				BLOCK25: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 10)
						next_state <= BLOCK26;
				end
				BLOCK26: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 11)
						next_state <= BLOCK27;
				end
				BLOCK27: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 12)
						next_state <= BLOCK28;
				end
				BLOCK28: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 13)
						next_state <= BLOCK29;
				end
				BLOCK29: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (seconds == 14)
						next_state <= BLOCK30;
				end
				BLOCK30: begin
					if (Collision[0] || Collision[1])
						next_state <= FINAL;
					else if (end_level[29])
						next_state <= WIN;
				end
				WIN: begin
					if (seconds == 5)
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
			level_final = 0;
			win = 0;
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
					MID2TOFINAL: begin
						level_final = 1;
					end
					BLOCK21: begin
						block_ready[14] = 1;
					end
					BLOCK22: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
					end
					BLOCK23: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
					end
					BLOCK24: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
					end
					BLOCK25: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
					end
					BLOCK26: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
						block_ready[16] = 1;
					end
					BLOCK27: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
						block_ready[16] = 1;
						rect_ready[9] = 1;
					end
					BLOCK28: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
						block_ready[16] = 1;
						rect_ready[9] = 1;
						rect_ready[10] = 1;
					end
					BLOCK29: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
						block_ready[16] = 1;
						rect_ready[9] = 1;
						rect_ready[10] = 1;
						rect_ready[11] = 1;
					end
					BLOCK30: begin
						block_ready[14] = 1;
						rect_ready[6] = 1;
						rect_ready[7] = 1;
						block_ready[15] = 1;
						rect_ready[8] = 1;
						block_ready[16] = 1;
						rect_ready[9] = 1;
						rect_ready[10] = 1;
						rect_ready[11] = 1;
						block_ready[17] = 1;
					end
					WIN: begin
						win = 1;
				   end
					
			endcase
			
		end
		
endmodule
