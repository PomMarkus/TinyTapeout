module DFFx8(
    input  wire        rst,
    input  wire        data_in,
    input  wire [7:0]  ff_clock,
    output reg  [7:0]  data
);

    always @(posedge ff_clock[7] or posedge rst) if (rst) data[0] <= 0; else data[0] <= data_in;
    always @(posedge ff_clock[6] or posedge rst) if (rst) data[1] <= 0; else data[1] <= data_in;
    always @(posedge ff_clock[5] or posedge rst) if (rst) data[2] <= 0; else data[2] <= data_in;
    always @(posedge ff_clock[4] or posedge rst) if (rst) data[3] <= 0; else data[3] <= data_in;
    always @(posedge ff_clock[3] or posedge rst) if (rst) data[4] <= 0; else data[4] <= data_in;
    always @(posedge ff_clock[2] or posedge rst) if (rst) data[5] <= 0; else data[5] <= data_in;
    always @(posedge ff_clock[1] or posedge rst) if (rst) data[6] <= 0; else data[6] <= data_in;
    always @(posedge ff_clock[0] or posedge rst) if (rst) data[7] <= 0; else data[7] <= data_in;

endmodule
