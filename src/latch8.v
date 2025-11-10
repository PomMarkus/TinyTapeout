/*
	enable module: passes input to output when enable is high
*/

`default_nettype none
`ifndef __LATCH8__
`define __LATCH8__

module latch8 (
    input  wire        en,   // enable: transparent when high
    input  wire        rst,  // asynchronous reset (active high)
    input  wire [7:0]  d,    // data input
    output reg  [7:0]  q     // latched output
);

/* verilator lint_off UNOPTFLAT */
/* verilator lint_off LATCH */
    always @(*) begin
        if (rst)
            q = 8'b0;
        else if (en)
            q = d;
    end
/* verilator lint_on UNOPTFLAT */
/* verilator lint_on LATCH */

endmodule

`endif
`default_nettype wire