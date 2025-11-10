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
    // Absichtlich Latch: always_latch
    always_latch begin
        if (rst)
            q = 8'b0;   // reset
        else if (en)
            q = d;      // transparent
        // kein else nötig: q hält automatisch den Wert
    end
endmodule

`endif
`default_nettype wire
