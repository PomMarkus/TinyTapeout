/*
	enabler module: passes input to output when enable is high
*/

`default_nettype none
`ifndef __ENABLE__
`define __ENABLE__

module enabler (
    input  wire [7:0] d,    // input byte
    input  wire       en,   // enable
    output wire [7:0] q     // output byte
);

    assign q = en ? d : 8'b0;

endmodule

`endif
`default_nettype wire