module mode_selector(
    input  R,
    input  S1,
    input  S2,
    input  S3,
    output reg O1,
    output reg O2,
    output reg O3
);

always @(*) begin
    // Output logic simplified using combinational reasoning
    O1 = ~(~(R | S1) & (O2 | O3));   // Equivalent to the gate network
    O2 = ~(~S2 & (O1 | O3));
    O3 = ~(~S3 & (O1 | O2));
end

endmodule
