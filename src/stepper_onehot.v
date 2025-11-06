module stepper_onehot(
	input wire clk,
	input wire rst,
	output reg [8:0] step
);

	reg [3:0] cnt; // 4-bit counter, counts 0..8
	
	//Counter
	always @(posedge clk or posedge rst) begin
		if (rst)
			cnt <= 4'b0;
		else if (cnt == 4'd8)
			cnt <= 4'b0;	// wrap around after 8
		else
			cnt <= cnt + 1;
	end
	
	//One-hot decoder
	always @(*) begin
		step = 9'b0;	//default all 0
		step[cnt] = 1'b1;
	end

endmodule
