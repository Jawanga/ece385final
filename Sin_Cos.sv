module Sin_Cos ( input clk,	input [0:5] index,
					output int signed sine, cosine);
					
	always @ (posedge clk)
	case (index)
6'd1:begin
sine <= 0;
cosine <= 1000;
end
6'd2:begin
sine <= 105;
cosine <= 995;
end
6'd3:begin
sine <= 208;
cosine <= 979;
end
6'd4:begin
sine <= 310;
cosine <= 952;
end
6'd5:begin
sine <= 407;
cosine <= 914;
end
6'd6:begin
sine <= 500;
cosine <= 867;
end
6'd7:begin
sine <= 588;
cosine <= 810;
end
6'd8:begin
sine <= 670;
cosine <= 744;
end
6'd9:begin
sine <= 744;
cosine <= 670;
end
6'd10:begin
sine <= 810;
cosine <= 588;
end
6'd11:begin
sine <= 867;
cosine <= 501;
end
6'd12:begin
sine <= 914;
cosine <= 407;
end
6'd13:begin
sine <= 952;
cosine <= 310;
end
6'd14:begin
sine <= 979;
cosine <= 208;
end
6'd15:begin
sine <= 995;
cosine <= 105;
end
6'd16:begin
sine <= 1000;
cosine <= 1;
end
6'd17:begin
sine <= 995;
cosine <= 105;
end
6'd18:begin
sine <= 979;
cosine <= 208;
end
6'd19:begin
sine <= 952;
cosine <= 310;
end
6'd20:begin
sine <= 914;
cosine <= 407;
end
6'd21:begin
sine <= 867;
cosine <= 501;
end
6'd22:begin
sine <= 810;
cosine <= 588;
end
6'd23:begin
sine <= 744;
cosine <= 670;
end
6'd24:begin
sine <= 670;
cosine <= 744;
end
6'd25:begin
sine <= 588;
cosine <= 810;
end
6'd26:begin
sine <= 500;
cosine <= 867;
end
6'd27:begin
sine <= 407;
cosine <= 914;
end
6'd28:begin
sine <= 310;
cosine <= 952;
end
6'd29:begin
sine <= 208;
cosine <= 979;
end
6'd30:begin
sine <= 105;
cosine <= 995;
end
6'd31:begin
sine <= 0;
cosine <= 1000;
end
6'd32:begin
sine <= 105;
cosine <= 995;
end
6'd33:begin
sine <= 208;
cosine <= 979;
end
6'd34:begin
sine <= 310;
cosine <= 952;
end
6'd35:begin
sine <= 407;
cosine <= 914;
end
6'd36:begin
sine <= 500;
cosine <= 867;
end
6'd37:begin
sine <= 588;
cosine <= 810;
end
6'd38:begin
sine <= 670;
cosine <= 744;
end
6'd39:begin
sine <= 744;
cosine <= 670;
end
6'd40:begin
sine <= 810;
cosine <= 588;
end
6'd41:begin
sine <= 867;
cosine <= 501;
end
6'd42:begin
sine <= 914;
cosine <= 407;
end
6'd43:begin
sine <= 952;
cosine <= 310;
end
6'd44:begin
sine <= 979;
cosine <= 208;
end
6'd45:begin
sine <= 995;
cosine <= 105;
end
6'd46:begin
sine <= 1000;
cosine <= 1;
end
6'd47:begin
sine <= 995;
cosine <= 105;
end
6'd48:begin
sine <= 979;
cosine <= 208;
end
6'd49:begin
sine <= 952;
cosine <= 310;
end
6'd50:begin
sine <= 914;
cosine <= 407;
end
6'd51:begin
sine <= 867;
cosine <= 501;
end
6'd52:begin
sine <= 810;
cosine <= 588;
end
6'd53:begin
sine <= 744;
cosine <= 670;
end
6'd54:begin
sine <= 670;
cosine <= 744;
end
6'd55:begin
sine <= 588;
cosine <= 810;
end
6'd56:begin
sine <= 500;
cosine <= 867;
end
6'd57:begin
sine <= 407;
cosine <= 914;
end
6'd58:begin
sine <= 310;
cosine <= 952;
end
6'd59:begin
sine <= 208;
cosine <= 979;
end
6'd60:begin
sine <= 105;
cosine <= 995;
end
6'd61:begin
sine <= 0;
cosine <= 1000;
end
	endcase
endmodule