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

/*
module decoder(
    input  [3:0] regAdr,
    input        rst,
    input        clk_AdrLatch,
    input        enable_output,
    output reg [10:0] registerSelect
);

reg [3:0] latchedAddr;

always @(posedge clk_AdrLatch or posedge rst) begin
    if (rst)
        latchedAddr <= 4'b0;
    else
        latchedAddr <= regAdr;
end

always @(*) begin
    if (!enable_output)
        registerSelect = 11'b0;
    else begin
        registerSelect = 11'b0; // default

        case (latchedAddr)
            4'b0000: registerSelect[0] = 1'b1;  // CTRL0
            4'b0001: registerSelect[1] = 1'b1;  // CTRL1
            4'b0010: registerSelect[2] = 1'b1;  // CTRL2
            4'b1000: registerSelect[3] = 1'b1;  // DATA1
            4'b1001: registerSelect[4] = 1'b1;  // DATA2
            4'b1010: registerSelect[5] = 1'b1;  // DATA3
            4'b1011: registerSelect[6] = 1'b1;  // DATA4
            4'b1100: registerSelect[7] = 1'b1;  // DATA5
            4'b1101: registerSelect[8] = 1'b1;  // DATA6
            4'b1110: registerSelect[9] = 1'b1;  // DATA7
            4'b1111: registerSelect[10] = 1'b1; // DATA8
            default: registerSelect = 11'b0;    // unused addresses
        endcase
    end
end

endmodule*/
