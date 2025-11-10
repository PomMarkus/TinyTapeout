module D_Latch(
    input  wire d,
    input  wire e,      // enable (transparent when high)
    input  wire reset,  // active high async reset
    output reg  Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(*) begin
        if (reset)
            Q = 1'b0;
        else if (e)
            Q = d;
    end
endmodule
