module 'tt_um_pommarkus_i2c_slave (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path (SDA/SCL etc.)
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // design enable
    input  wire       clk,      // system clock
    input  wire       rst_n     // active low reset
);

    wire rst = ~rst_n;

    // -----------------------------
    // I2C top signals
    // -----------------------------
    wire [7:0] i2c_data;
    wire [10:0] registerSelect;
    wire ACK_enable;

    // SDA/SCL mapped to IO[0] and IO[1]
    wire SDA = uio_in[0];
    wire SCL = uio_in[1];

    i2c_top i2c_inst (
        .SDA(SDA),
        .SCL(SCL),
        .rst(rst),
        .data(i2c_data),
        .registerSelect(registerSelect),
        .ACK_enable_out(ACK_enable)
    );

    // -----------------------------
    // Core top module
    // -----------------------------
    wire [7:0] core_uo_out;

    top_module core_inst (
        .clk(clk),
        .rst(rst),
        .data(i2c_data),
        .register_select(registerSelect),
        .ui_in(ui_in),
        .uo_out(core_uo_out)
    );

    assign uo_out = core_uo_out;

    // -----------------------------
    // IO outputs (tri-state SDA driven during ACK)
    // -----------------------------
    assign uio_out = {7'b0, ACK_enable & ena};  // only uio_out[0] drives SDA
    assign uio_oe  = {7'b0, ACK_enable & ena};  // output enable for SDA

    // -----------------------------
    // Unused signals to prevent warnings
    // -----------------------------
    wire _unused = &{ena, clk, rst, 1'b0};

endmodule

