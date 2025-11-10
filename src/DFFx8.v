/*
	8 D flip-flops with individual clocks
*/

`default_nettype none
`ifndef __DFF8__
`define __DFF8__

module DFFx8(
    input  wire        clk,
    input  wire        rst,
    input  wire        data_in,
    input  wire [7:0]  ff_enable,
    output reg  [7:0]  data
);

always @(negedge clk or posedge rst) begin
    if (rst)
        data <= 8'b0;
    else begin
        if (ff_enable[7]) data[0] <= data_in;
        if (ff_enable[6]) data[1] <= data_in;
        if (ff_enable[5]) data[2] <= data_in;
        if (ff_enable[4]) data[3] <= data_in;
        if (ff_enable[3]) data[4] <= data_in;
        if (ff_enable[2]) data[5] <= data_in;
        if (ff_enable[1]) data[6] <= data_in;
        if (ff_enable[0]) data[7] <= data_in;
    end
end

endmodule

`endif
`default_nettype wire