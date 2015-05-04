module block_SM (input Clk, Reset, Run,
					  input end_level,
					  output logic block_ready [0:9],
					  output logic level_one, level_two,
					  output logic [9:0] seconds);

		enum logic [3:0] {RESET, LEVEL1, LEVEL2, MID1TO2, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5, BLOCK6, BLOCK7, BLOCK8, BLOCK9, BLOCK10} state, next_state;
		
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
				if (counter == 50000000 && state != RESET)
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
					if (Run)
						next_state <= LEVEL1;
				end
				LEVEL1: begin
					if (seconds == 1)
						next_state <= BLOCK1;
				end
				BLOCK1: begin
					if (seconds == 2)
						next_state <= BLOCK2;
				end
				BLOCK2: begin
					if (seconds == 3)
						next_state <= BLOCK3;
				end
				BLOCK3: begin
					if (seconds == 4)
						next_state <= BLOCK4;
				end
				BLOCK4: begin
					if (seconds == 5)
						next_state <= BLOCK5;
				end
				BLOCK5: begin
					if (seconds == 6)
						next_state <= BLOCK6;
				end
				BLOCK6: begin
					if (seconds == 7)
						next_state <= BLOCK7;
				end
				BLOCK7: begin
					if (seconds == 8)
						next_state <= BLOCK8;
				end
				BLOCK8: begin
					if (seconds == 9)
						next_state <= BLOCK9;
				end
				BLOCK9: begin
					if (seconds == 10)
						next_state <= BLOCK10;
				end
				BLOCK10: begin
					if (end_level)
						next_state <= MID1TO2;
				end
			endcase
		end
		
		always_comb begin
			for (int i = 0; i < $size(block_ready); i++) begin
				block_ready[i] = 0;
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
			endcase
		end
		
endmodule
