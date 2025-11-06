module enable (
    input  wire [7:0] d,    // input byte
    input  wire       en,   // enable
    output wire [7:0] q     // output byte
);

    assign q = en ? d : 8'b0;

endmodule
