//Alex Johnson ECEN 2350 Spring 2018
//module to display the nightrider LED sequence on the 10 LEDs
module Magic(input CLK, output [9:0]LED_array);
	integer clock_count;
	reg [13:0]light_register = 13'b00000000000111;
	reg shift_flag;
	always@(posedge CLK)
	begin
		//create a count of the clock that resets every 5000000 positive edges
		if(clock_count < 2500000)
			clock_count = clock_count+1;
		else
			clock_count = 0;
		//check to see if the register is at it's edge to switch direction
		if(light_register[13] == 1)
			shift_flag = 1;
		else if(light_register[0] == 1)
			shift_flag = 0;
		//shift the register in the currect direction
		if(clock_count == 1)
		begin
			if(shift_flag == 1)
				light_register[13:0] = light_register[13:0] >> 1;
			else
				light_register[13:0] = light_register[13:0] << 1;
		end
	end
	
	assign LED_array[9:0] = light_register[11:2];
	
endmodule
