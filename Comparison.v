module Comparison(input [1:0]select, input [7:0]z, output [3:0]result);
	wire [3:0]x;
	wire [3:0]y;
	assign x[3:0] = z[3:0];
	assign y[3:0] = z[7:4];
	
	reg [3:0]equal_out;
	always@(x,y)
	begin
		if(x[3:0] == y[3:0]) equal_out[0] = 1;
		else equal_out[0] = 0;
	end
	
	reg [3:0]greater_out;
	always@(x,y)
	begin
		if(x[3:0] > y[3:0]) greater_out[0] = 1;
		else greater_out[0] = 0;
	end
	
	reg [3:0]less_out;
	always@(x,y)
	begin
		if(x[3:0] < y[3:0]) less_out[0] = 1;
		else less_out[0] = 0;
	end
	
	wire [3:0]max_out;
	assign max_out[3:0] = ({greater_out[0],greater_out[0],greater_out[0],greater_out[0]} & x[3:0])
		| ({~greater_out[0],~greater_out[0],~greater_out[0],~greater_out[0]} & y[3:0]);
	
	wire [3:0]temp_result;
	assign temp_result[0] = {equal_out[0],greater_out[0],less_out[0],max_out[0]};
	
	genvar i;
	generate
		for(i=1; i<4; i=i+1) begin: temp_assignment
			assign temp_result[i] = {1'b0,1'b0,1'b0,max_out[i]};
		end
	endgenerate

	MUX output_mux(temp_result[3:0],~select[1:0],result[3:0]);
	defparam output_mux.n = 4;

endmodule
