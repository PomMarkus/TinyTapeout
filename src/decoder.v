/*
	4-bit address decoder with output enable
*/

`default_nettype none
`ifndef __DECODER__
`define __DECODER__

module decoder(
    input  [3:0] regAdr,
    input        rst,
    input        clk_AdrLatch,
    input        enable_output,
    output wire [10:0] registerSelect
);

reg [3:0] latchedAddr;

always @(negedge clk_AdrLatch or posedge rst) begin
    if (rst)
        latchedAddr <= 4'b0;
    else
        latchedAddr <= {regAdr[3:0]};
end

    assign registerSelect[0]  = enable_output & (latchedAddr == 4'b0000); // CTRL0
    assign registerSelect[1]  = enable_output & (latchedAddr == 4'b0001); // CTRL1
    assign registerSelect[2]  = enable_output & (latchedAddr == 4'b0010); // CTRL2
    assign registerSelect[3]  = enable_output & (latchedAddr == 4'b1000); // DATA1
    assign registerSelect[4]  = enable_output & (latchedAddr == 4'b1001); // DATA2
    assign registerSelect[5]  = enable_output & (latchedAddr == 4'b1010); // DATA3
    assign registerSelect[6]  = enable_output & (latchedAddr == 4'b1011); // DATA4
    assign registerSelect[7]  = enable_output & (latchedAddr == 4'b1100); // DATA5
    assign registerSelect[8]  = enable_output & (latchedAddr == 4'b1101); // DATA6
    assign registerSelect[9]  = enable_output & (latchedAddr == 4'b1110); // DATA7
    assign registerSelect[10] = enable_output & (latchedAddr == 4'b1111); // DATA8

endmodule

`endif
`default_nettype wire

