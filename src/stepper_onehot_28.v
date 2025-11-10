/*
	counter with decoder to one-hot stepper output


`default_nettype none
`ifndef __STEPPER_ONEHOT_28__
`define __STEPPER_ONEHOT_28__


module stepper_onehot_28(
    input  wire clk,
    input  wire rst,
    output reg [28:0] step
);

    reg [4:0] cnt; // 5-bit counter, counts 0..28

    // Counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 5'd0;
        else if (cnt == 5'd28)
            cnt <= 5'd0;   // wrap around after 28
        else
            cnt <= cnt + 1;
    end

    // One-hot decoder
    always @(*) begin
        step = 29'b0;      // default all 0 //CHANGED: 28 to 29
        step[cnt] = 1'b1;
    end

endmodule

`endif
`default_nettype wire
*/


/*
    Optimized 28-step one-hot stepper driver
*/

`default_nettype none
`ifndef __STEPPER_ONEHOT_28_OPT__
`define __STEPPER_ONEHOT_28_OPT__

module stepper_onehot_28(
    input  wire clk,
    input  wire rst,
    output reg [28:0] step
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            step <= 29'b00000000000000000000000000001; // start with step 0
        else
            step <= {step[27:0], step[28]}; // rotate left
    end

endmodule

`endif
`default_nettype wire
