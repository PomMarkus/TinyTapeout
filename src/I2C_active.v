module I2C_active(
    input  wire SDA,
    input  wire SCL,
    input  wire reset,
    output reg  Start,
    output reg  Stop
);

    reg SDA_prev;

    always @(posedge SDA or negedge SDA or posedge reset) begin
        if (reset) begin
            SDA_prev <= 1'b1;
            Start    <= 0;
            Stop     <= 0;
        end else begin
            // Only trigger when SCL is high
            if (SCL) begin
                Start <= (SDA_prev & ~SDA); // falling edge
                Stop  <= (~SDA_prev & SDA); // rising edge
            end else begin
                Start <= 0;
                Stop  <= 0;
            end

            // Latch previous SDA
            SDA_prev <= SDA;
        end
    end

endmodule
