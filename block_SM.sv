module block_SM (input Clk, Reset, Run,
					  output logic block_ready [0:4]);

		enum logic [3:0] {RESET, READY, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5} state, next_state;
		
		reg [27:0] counter;
		
		always_ff @ (posedge Clk or posedge Reset) begin
			if (Reset) begin
				state <= RESET;
				counter <= 0;
			end
			else begin
				state <= next_state;
				counter <= counter + 1;
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					if (Run)
						next_state <= READY;
				end
				READY: begin
					if (counter == 0)
						next_state <= BLOCK1;
				end
				BLOCK1: begin
					if (counter == 50000000)
						next_state <= BLOCK2;
				end
				BLOCK2: begin
					if (counter == 100000000)
						next_state <= BLOCK3;
				end
				BLOCK3: begin
					if (counter == 150000000)
						next_state <= BLOCK4;
				end
				BLOCK4: begin
					if (counter == 200000000)
						next_state <= BLOCK5;
				end
			endcase
		end
		
		always_comb begin
			for (int i = 0; i < 5; i++) begin
				block_ready[i] = 0;
			end
			case (state)
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
			endcase
		end
		
endmodule
