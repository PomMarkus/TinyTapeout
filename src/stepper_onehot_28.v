module stepper_onehot_28(
    input  wire clk,
    input  wire rst,
    output reg [28:0] step
);

    reg [4:0] cnt; // 5-bit counter, counts 0..28

    // Counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 5'd0;
        else if (cnt == 5'd28)
            cnt <= 5'd0;   // wrap around after 28
        else
            cnt <= cnt + 1;
    end

    // One-hot decoder
    always @(*) begin
        step = 29'b0;      // default all 0 //CHANGED: 28 to 29
        step[cnt] = 1'b1;
    end

endmodule