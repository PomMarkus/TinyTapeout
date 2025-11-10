/*
    I2C Start/Stop condition detector


`default_nettype none
`ifndef __I2C_ACTIVE__
`define __I2C_ACTIVE__

module I2C_active(
    input  wire SDA,
    input  wire SCL,
    input  wire rst,
    output reg  Start,
    output reg  Stop
);

reg SDA_prev;

// Latch SDA on SCL high
always @(posedge SCL or posedge rst) begin
    if (rst)
        SDA_prev <= 1'b1;
    else
        SDA_prev <= SDA;
end

// Detect Start/Stop based on SDA transition while SCL high
always @(posedge SCL or posedge rst) begin
    if (rst) begin
        Start <= 0;
        Stop  <= 0;
    end else begin
        Start <= (SDA_prev & ~SDA); // falling edge while SCL high
        Stop  <= (~SDA_prev & SDA); // rising edge while SCL high
    end
end

endmodule
`endif
`default_nettype wire
*/


/*
    I2C Start/Stop condition detector
*/

`timescale 1ns/1ps
`default_nettype none
`ifndef __I2C_ACTIVE__
`define __I2C_ACTIVE__

module I2C_active(
    input  wire SDA,    // I2C data line
    input  wire SCL,    // I2C clock line
    input  wire rst,  // Asynchronous reset
    output wire Start,  // Start condition
    output wire Stop    // Stop condition
);

    // D-Latch: transparent when SCL is low
    reg Q;
    
/* verilator lint_off LATCH */
    always @(*) begin
        if (rst)
            Q = 1'b0;
        else if (~SCL)
            Q = SDA;      // Latch follows SDA when SCL is low
        // else: hold previous Q
    end
/* verilator lint_on LATCH */

    // Combinational Start/Stop detection
    assign Start = SCL & ~SDA &  Q;
    assign Stop  = SCL &  SDA & ~Q;

endmodule

`endif
`default_nettype wire

