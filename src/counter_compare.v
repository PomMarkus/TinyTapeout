/*
	20-bit counter with compare match output


`default_nettype none
`ifndef __COUNTER_COMPARE__
`define __COUNTER_COMPARE__


module counter_compare #(
    parameter WIDTH = 20
)(
    input  wire clk,
    input  wire rst,
    input  wire [WIDTH-1:0] compare,  // compare value input
    output reg  [WIDTH-1:0] count,    // counter output
    output wire compare_match          // pulse output
);

    // Compare match pulse: goes HIGH for one clk cycle when count >= compare-1
    assign compare_match = (compare != 0) ? (count >= compare - 1) : (count == {WIDTH{1'b1}});

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else
            count <= (compare == 0) ? (count + 1) : ((count >= compare - 1) ? 0 : count + 1);
    end

endmodule


`endif
`default_nettype wire
*/

/*
	20-bit counter with compare match output - new version
*/

`default_nettype none
`ifndef __COUNTER_COMPARE__
`define __COUNTER_COMPARE__

module counter_compare #(
    parameter WIDTH = 20
)(
    input  wire clk,
    input  wire rst,
    input  wire [WIDTH-1:0] compare,  // compare value
    output reg  [WIDTH-1:0] count,
    output wire compare_match
);

reg [WIDTH-1:0] compare_prev;
wire overflow;

// Overflow erzeugt, wenn Zähler das Compare erreicht
assign overflow = (count + 1 == compare);

// Counter-Logik
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count        <= 0;
        compare_prev <= 0;
    end else if (compare != compare_prev) begin
        count        <= 0;            // neuer Compare → Zähler reset
        compare_prev <= compare;
    end else if (compare == 0) begin
        count <= count + 1;           // free-running bei compare=0
    end else if (overflow) begin
        count <= 0;                    // normaler Overflow
    end else begin
        count <= count + 1;
    end
end

assign compare_match = overflow;

endmodule

`endif
`default_nettype wire
