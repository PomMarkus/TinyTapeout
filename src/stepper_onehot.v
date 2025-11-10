`default_nettype none
`ifndef __STEPPER_ONEHOT__
`define __STEPPER_ONEHOT__

module stepper_onehot(
    input wire clk,
    input wire rst,
    output reg [8:0] step
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            step <= 9'b000000001;  // Start mit LSB = 1
        else
			if (step[8])
				step <= 9'b000000010; // reset to step 1
			else
            	step <= {step[7:0], step[8]}; // rotate left
    end

endmodule

`endif
`default_nettype wire
