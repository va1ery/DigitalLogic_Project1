module Arithmetic(input [1:0]select, input [7:0]z, output COUT, output [7:0]result);
	wire [3:0]x;
	wire [3:0]y;
	assign x[3:0] = z[3:0];
	assign y[3:0] = z[7:4];
	

	//4 bit adder (x+y)
	wire [7:0]add_out;
	wire [4:0]add_carry;
	
	genvar i;
	generate
		for(i=0; i<4; i=i+1) begin: adder
			Full_Adder adder0(add_carry[i],x[i],y[i],add_out[i],add_carry[i+1]);
		end
	endgenerate
	
	//4 bit subtractor (x-y)
	wire [7:0]sub_out;
	wire [4:0]sub_carry;
	
	generate
		for(i=0; i<4; i=i+1) begin: subtractor
			Full_Subtractor(sub_carry, x[i], y[i], sub_out[i], sub_carry[i+1]);
		end
	endgenerate

	//multiply z by 2
	wire [7:0]mult_out;
	assign mult_out[7:0] = z[7:0] << 1;
	
	//divide z by 2
	wire [7:0]div_out;
	assign div_out[7:0] = z[7:0] >> 1;
	
	//concatinated wires to hold the appropriate bit for each of the results together
	wire [3:0]temp_result[7:0];
	generate
		for(i=0; i<4; i=i+1) begin: temp_mux1
			assign temp_result[i] = {add_out[i],sub_out[i],mult_out[i],div_out[i]};
		end
	endgenerate
	generate
		for(i=4; i<8; i=i+1) begin: temp_mux2
			assign temp_result[i] = {4'b0000,4'b0000,mult_out[i],div_out[i]};
		end
	endgenerate
	
	//create a multiplexor to select the appropriate output
	MUX hex_mux({add_out[7:0],sub_out[7:0],mult_out[7:0],div_out[7:0]},~select[1:0],result[7:0]);
	defparam hex_mux.n = 8;
	
	//generate multiplexor for carry LED
	wire [3:0]temp_carry;
	assign temp_carry[3:0] = {z[0],z[7],sub_carry[4],add_carry[4]};
	MUX carry_mux(temp_carry[3:0],select[1:0],COUT);
	defparam carry_mux.n = 1;
	
endmodule

module Full_Subtractor(input BIN, input a, input b, output difference, output BOUT);
	assign difference = a ^ b ^ BIN;
	assign BOUT = (a & ~BIN) | (a & ~b) | (b & BIN);
endmodule

module Full_Adder(input CIN, input a, input b, output sum, output COUT);
	assign sum = CIN ^ a ^ b;
	assign COUT = (a & b) | (a & CIN) | (b & CIN);
endmodule
