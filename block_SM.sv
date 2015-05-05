module block_SM (input Clk, Reset, Run,
					  input end_level [0:12],
					  input [7:0] keycode,
					  output logic block_ready [0:9],
					  output logic rect_ready [0:2],
					  output logic level_one, level_two,
					  output logic [9:0] seconds);

		enum logic [4:0] {RESET, LEVEL1, LEVEL2, MID1TO2, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5, BLOCK6, BLOCK7, BLOCK8, BLOCK9, BLOCK10, BLOCK11, BLOCK12, BLOCK13} state, next_state;
		
		reg [27:0] counter;
		//logic [9:0] seconds;
		
		always_ff @ (posedge Clk or posedge Reset) begin
			if (Reset) begin
				state <= RESET;
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
				else
					counter <= counter + 1;
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					if (Run || keycode == 40)
						next_state <= LEVEL1;
				end
				LEVEL1: begin
					if (seconds == 1)
						next_state <= BLOCK1;
				end
				BLOCK1: begin
					if (seconds == 3)
						next_state <= BLOCK2;
				end
				BLOCK2: begin
					if (seconds == 5)
						next_state <= BLOCK3;
				end
				BLOCK3: begin
					if (seconds == 7)
						next_state <= BLOCK4;
				end
				BLOCK4: begin
					if (seconds == 9)
						next_state <= BLOCK5;
				end
				BLOCK5: begin
					if (seconds == 11)
						next_state <= BLOCK6;
				end
				BLOCK6: begin
					if (seconds == 13)
						next_state <= BLOCK7;
				end
				BLOCK7: begin
					if (seconds == 15)
						next_state <= BLOCK8;
				end
				BLOCK8: begin
					if (seconds == 17)
						next_state <= BLOCK9;
				end
				BLOCK9: begin
					if (seconds == 19)
						next_state <= BLOCK10;
				end
				BLOCK10: begin
					if (end_level[9])
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
					if (seconds == 7)
						next_state <= BLOCK12;
				end
				BLOCK12: begin
					if (seconds == 9)
						next_state <= BLOCK13;
				end
				BLOCK13: begin
					
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
			level_one = 0;
			level_two = 0;
			case (state)
					RESET:
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
					/*
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
					*/
						for (int i = 0; i < 6; i++) begin
							block_ready[i] = ~end_level[i];
						end
						block_ready[6] = 1;
					end
					BLOCK8: begin
					/*
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
					*/
						for (int i = 0; i < 7; i++) begin
							block_ready[i] = ~end_level[i];
						end
						block_ready[7] = 1;
					end
					BLOCK9: begin
						/*
						block_ready[0] = 1;
						block_ready[1] = 1;
						block_ready[2] = 1;
						block_ready[3] = 1;
						block_ready[4] = 1;
						block_ready[5] = 1;
						block_ready[6] = 1;
						block_ready[7] = 1;
						*/
						for (int i = 0; i < 8; i++) begin
							block_ready[i] = ~end_level[i];
						end
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
			endcase
		end
		
endmodule
