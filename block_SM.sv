module block_SM (input Clk, Reset, Run,
					  output logic [2:0] block_ready);

		enum logic [3:0] {RESET, BLOCK1, BLOCK2, BLOCK3, BLOCK4, BLOCK5} state, next_state;
		
		always_ff @ (posedge Clk or posedge Reset) begin
			if (Reset) begin
				state <= RESET;
			end
			else begin
				state <= next_state;
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					if (Run)
						next_state = BLOCK1;
				end
				BLOCK1:
					next_state = BLOCK2;
				BLOCK2:
					next_state = BLOCK3;
				BLOCK3:
					next_state = BLOCK4;
				BLOCK4:
					next_state = BLOCK5;
			endcase
		end
		
		always_comb begin
			block_ready = 0;
			case (state)
					BLOCK1:
						block_ready = 1;
					BLOCK2:
						block_ready = 2;
					BLOCK3:
						block_ready = 3;
					BLOCK4:
						block_ready = 4;
					BLOCK5:	
						block_ready = 5;
			endcase
		end
		
endmodule
