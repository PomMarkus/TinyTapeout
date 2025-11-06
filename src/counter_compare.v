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
