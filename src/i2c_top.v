module i2c_top(
    input  wire SDA,   // I2C data line (also data input)
    input  wire SCL,   // I2C clock
    input  wire rst,   // global reset
    output wire ACK_enable_out,      // for master
    output wire [7:0] data,          // current byte received
    output wire [10:0] registerSelect
);

    wire start; //CHANGED: 2 lines instead of 1
    wire stop;
    wire i2c_started;
    wire [28:0] step;
    wire [7:0] ff_clk;
    wire enable_output;
    // wire [3:0] regAdr; //CHANGED: unused 

    //----------------------------------------------------------
    // Detect Start and Stop conditions
    //----------------------------------------------------------
    I2C_active i2c_detect(
        .SDA(SDA),
        .SCL(SCL),
        .reset(rst),
        .Start(start),
        .Stop(stop)
    );

    // Address match check (7-bit address 0x47 + write)
    wire addr_match = (data[7:1] == 7'b1000111);
    wire rw_write   = (data[0] == 1'b0);
    wire addr_nack  = (step[9] & ~addr_match);  // if step 9 and address wrong → stop

    //----------------------------------------------------------
    // RS latch: stays active between Start and Stop
    //----------------------------------------------------------
    rs_latch latch_active(
        .S(start),
        .R(stop | rst | step[28] | addr_nack),
        .Q(i2c_started),
        .Qn()
    );


    //----------------------------------------------------------
    // Stepper: counts 1..28 while I²C active
    //----------------------------------------------------------
    stepper_onehot_28 stepper(
        .clk(SCL),
        .rst(rst | stop | ~i2c_started),
        .step(step)
    );

    //----------------------------------------------------------
    // DFF bank captures SDA at each step
    //----------------------------------------------------------
    assign ff_clk = step[8:1] | step[17:10] | step[26:19];  
    // reuse same DFFs — only one active pulse at a time

    DFFx8 dff(
        .rst(rst | addr_nack),
        .data_in(SDA),
        .ff_clock(ff_clk),
        .data(data)
    );

    //----------------------------------------------------------
    // Extract register address after step 17
    //----------------------------------------------------------
    //----------------------------------------------------------
    // Latch register address after second byte is fully received
    //----------------------------------------------------------
    // always @(posedge rst) begin
    //         regAdr_reg <= 4'b0;
    // end
    
    // always @(posedge step[17] ) begin       // latch at end of second byte
    //         regAdr_reg <= data[7:4];
    // end

    //----------------------------------------------------------
    // Enable decoder only at final step (27)
    //----------------------------------------------------------
    assign enable_output = step[27];

    //----------------------------------------------------------
    // Decoder selects the destination register
    //----------------------------------------------------------
    decoder dec(
        .regAdr(data[3:0]),
        .rst(rst | addr_nack),
        .clk_AdrLatch(step[17]), // latch address at end of second byte
        .enable_output(enable_output),
        .registerSelect(registerSelect)
    );

    //----------------------------------------------------------
    // ACK logic:
    // - Step 8: address matched + write (R/W=0)
    // - Step 18: after reg address byte
    // - Step 27: final ACK
    //----------------------------------------------------------
    // wire addr_match = (data[6:0] == 7'b1110001); // address 0x47 (1000111x)
    // wire rw_write   = (data[7] == 1'b0);

    assign ACK_enable_out =
        ((step[9] & addr_match & rw_write) |  // after address
         (step[18]) |                          // after reg addr
         (step[27])) & SCL;                    // after data

endmodule
