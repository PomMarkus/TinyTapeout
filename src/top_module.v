module top_module (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  data,
    input  wire [10:0] register_select, // 11-bit register trigger
    input  wire [7:0]  ui_in,           // direct passthrough input
    output wire [7:0]  uo_out
);

    // =========================================
    // 11 identical latches (CTRL0–CTRL2, DATA1–DATA8)
    // =========================================
    wire [7:0] reg_data [10:0]; // 11x 8-bit register array

    genvar i;
    generate
        for (i = 0; i < 11; i=i+1) begin : REG_LATCHES
            latch8 l (
                .en(register_select[i]),
                .rst(rst),
                .d(data),
                .q(reg_data[i])
            );
        end
    endgenerate

    // =========================================
    // Aliases for readability
    // =========================================
    wire [7:0] ctrl0 = reg_data[0];
    wire [7:0] ctrl1 = reg_data[1];
    wire [7:0] ctrl2 = reg_data[2];

    // CHANGED: Unused wires removed

    // wire [7:0] data1 = reg_data[3];
    // wire [7:0] data2 = reg_data[4];
    // wire [7:0] data3 = reg_data[5];
    // wire [7:0] data4 = reg_data[6];
    // wire [7:0] data5 = reg_data[7];
    // wire [7:0] data6 = reg_data[8];
    // wire [7:0] data7 = reg_data[9];
    // wire [7:0] data8 = reg_data[10];

    // =========================================
    // Counter + Compare Logic
    // =========================================
    wire [19:0] compare_value;
    wire [19:0] count;
    wire        cmp_match;

    assign compare_value = {ctrl2, ctrl1, ctrl0[7:4]}; // 20-bit compare value

    counter_compare #(.WIDTH(20)) counter (
        .clk(clk),
        .rst(rst),
        .compare(compare_value),
        .count(count),
        .compare_match(cmp_match)
    );

    // =========================================
    // Stepper
    // =========================================
    wire [8:0] step;

    // Reset stepper if CTRL0[1] == 0
    wire stepper_rst = ~ctrl0[1];

    stepper_onehot stepper (
        .clk(cmp_match),
        .rst(stepper_rst),
        .step(step)
    );

    // =========================================
    // Enable modules for Data1–Data8
    // =========================================
    wire [7:0] enabled_data [7:0];

    generate
        for (i = 0; i < 8; i=i+1) begin : ENABLES
            enable en_mod (
                .d(reg_data[i+3]),  // DATA1–DATA8
                .en(step[i+1]),     // step[0] is unused
                .q(enabled_data[i])
            );
        end
    endgenerate

    // =========================================
    // Direct passthrough (CTRL0[0])
    // =========================================
    wire [7:0] passthrough;
    enable direct_en (
        .d(ui_in),
        .en(ctrl0[0]),
        .q(passthrough)
    );

    // =========================================
    // Final Output — OR of all enabled signals
    // =========================================
    assign uo_out = passthrough |
                    enabled_data[0] |
                    enabled_data[1] |
                    enabled_data[2] |
                    enabled_data[3] |
                    enabled_data[4] |
                    enabled_data[5] |
                    enabled_data[6] |
                    enabled_data[7];

endmodule


/*module top_module (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  data,
    input  wire [10:0] register_select, // 11-bit register trigger
    input  wire [7:0]  ui_in,           // direct passthrough input
    output wire [7:0]  uo_out
);

    // ========================
    // Latches for Data1-Data8
    // ========================
    wire [7:0] data_latch[7:0]; // outputs of latches

    genvar i;
    generate
        for (i = 0; i < 8; i=i+1) begin : DATA_LATCHES
            latch8 l (
                .en(register_select[i]),
                .rst(rst),
                .d(data),
                .q(data_latch[i])
            );
        end
    endgenerate

    // ========================
    // Latches for CTRL0, CTRL1, CTRL2
    // ========================
    wire [7:0] ctrl0, ctrl1, ctrl2;

    latch8 l_ctrl0(.en(register_select[8]), .rst(rst), .d(data), .q(ctrl0));
    latch8 l_ctrl1(.en(register_select[9]), .rst(rst), .d(data), .q(ctrl1));
    latch8 l_ctrl2(.en(register_select[10]), .rst(rst), .d(data), .q(ctrl2));

    // ========================
    // Counter compare
    // ========================
    wire [19:0] compare_value;
    wire [19:0] count;
    wire        cmp_match;

    assign compare_value = {ctrl2, ctrl1, ctrl0[7:4]}; // 20-bit compare

    counter_compare #(.WIDTH(20)) counter (
        .clk(clk),
        .rst(rst),
        .compare(compare_value),
        .count(count),
        .compare_match(cmp_match)
    );

    // ========================
    // Stepper
    // ========================
    wire [8:0] step;

    // Reset stepper if CTRL0[1] low
    wire stepper_rst = (ctrl0[1] == 1'b0) ? 1'b1 : 1'b0;

    stepper_onehot stepper (
        .clk(cmp_match),
        .rst(stepper_rst),
        .step(step)
    );

    // ========================
    // Enable modules for Data1-Data8
    // ========================
    wire [7:0] enabled_data[7:0];

    generate
        for (i = 0; i < 8; i=i+1) begin : ENABLES
            enable en_mod (
                .d(data_latch[i]),
                .en(step[i+1]), // step 0 is unused
                .q(enabled_data[i])
            );
        end
    endgenerate

    // ========================
    // Direct passthrough (CTRL0[0])
    // ========================
    wire [7:0] passthrough;
    enable direct_en(
        .d(ui_in),
        .en(ctrl0[0]),
        .q(passthrough)
    );

    // ========================
    // Output OR all enabled signals
    // ========================
    assign uo_out = passthrough |
                    enabled_data[0] |
                    enabled_data[1] |
                    enabled_data[2] |
                    enabled_data[3] |
                    enabled_data[4] |
                    enabled_data[5] |
                    enabled_data[6] |
                    enabled_data[7];

endmodule*/
