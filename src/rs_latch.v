module rs_latch(
    input  S,
    input  R,
    output reg Q,
    output Qn
);

assign Qn = ~Q;  // Qn is always complement of Q

always @(*) begin
    if (S & ~R)
        Q = 1;        // Set
    else if (~S & R)
        Q = 0;        // Reset
    // else if S=0 and R=0 -> hold Q
    // else if S=1 and R=1 -> hold Q
end

endmodule
