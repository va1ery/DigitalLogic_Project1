//Alex Johnson ECEN 2350 Spring 2018
//module to do comparison logic on 4x2 or 8 bit inputs, resulting in a 4 bit output
module Comparison(input [1:0]select, input [7:0]z, output [3:0]result);
	wire [3:0]x;
	wire [3:0]y;
	assign y[3:0] = z[3:0];
	assign x[3:0] = z[7:4];
	
	//equals assignment, making it 4 bits even though 1 is need so that it can be sent to the multiplexor
	reg [3:0]equal_out;
	always@(x,y)
	begin
		if(x[3:0] == y[3:0]) equal_out[0] = 1;
		else equal_out[0] = 0;
	end
	
	//greater than assignment, making it 4 bits even though 1 is need so that it can be sent to the multiplexor
	reg [3:0]greater_out;
	always@(x,y)
	begin
		if(x[3:0] > y[3:0]) greater_out[0] = 1;
		else greater_out[0] = 0;
	end
	
	//less than assignment, making it 4 bits even though 1 is need so that it can be sent to the multiplexor
	reg [3:0]less_out;
	always@(x,y)
	begin
		if(x[3:0] < y[3:0]) less_out[0] = 1;
		else less_out[0] = 0;
	end
	
	//use the result of the greater than assignment to generate the maximum of the two numbers
	wire [3:0]max_out;
	assign max_out[3:0] = ({greater_out[0],greater_out[0],greater_out[0],greater_out[0]} & x[3:0])
		| ({~greater_out[0],~greater_out[0],~greater_out[0],~greater_out[0]} & y[3:0]);
	
	//concaninating the 4 different results together to be sent through the multiplexor
	wire [3:0]temp_result;
	assign temp_result[0] = {equal_out[0],greater_out[0],less_out[0],max_out[0]};
	
	genvar i;
	generate
		for(i=1; i<4; i=i+1) begin: temp_assignment
			assign temp_result[i] = {1'b0,1'b0,1'b0,max_out[i]};
		end
	endgenerate

	//use a 4 bit multiplexor to output the proper output
	MUX output_mux({equal_out[3:0],greater_out[3:0],less_out[3:0],max_out[3:0]},~select[1:0],result[3:0]);
	defparam output_mux.n = 4;

endmodule
