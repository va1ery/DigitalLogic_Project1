module Magic(input CLK, output [9:0]LED_array);
	integer clock_count;
	reg [13:0]light_register = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1};
	reg shift_flag;
	always@(posedge CLK)
	begin
		if(clock_count < 10000000)
			clock_count = clock_count+1;
		else
			clock_count = 0;
	end
	
	always@(clock_count)
	begin
		if(clock_count == 0)
		begin
			if(shift_flag == 0)
				light_register[13:0] = light_register[13:0] << 1;
			else
				light_register[13:0] = light_register[13:0] >> 1;
		end
	end
	
	always@(light_register)
	begin
		if(light_register[13] == 1)
			shift_flag = 1;
		else if(light_register[0] == 1)
			shift_flag = 0;
	end
	
	assign LED_array[9:0] = light_register[11:2];
	
endmodule
