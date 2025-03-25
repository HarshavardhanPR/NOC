`timescale 1ns / 1ps

module PE_Testbench;

    // Parameters
    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = 2;

    // Signals
    reg clk, rst;
    reg i_valid_from_router;
    reg [DATA_WIDTH + 2*ADDR_WIDTH - 1:0] i_data_from_router;
    wire o_valid_to_router;
    wire [DATA_WIDTH + 2*ADDR_WIDTH - 1:0] o_data_to_router;

    // Instantiate PE module
    PE #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) pe_inst (
        .clk(clk),
        .rst(rst),
        .i_valid_from_router(i_valid_from_router),
        .i_data_from_router(i_data_from_router),
        .o_valid_to_router(o_valid_to_router),
        .o_data_to_router(o_data_to_router)
    );

    // Clock Generation (10ns period → 100MHz)
    always #5 clk = ~clk;

    // Simulation Process
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        i_valid_from_router = 0;
        i_data_from_router = 0;

        // Apply Reset
        #20 rst = 0;
        $display("\n*** PE Simulation Started ***\n");

        // Test Case 1: Send a valid packet
        #50 i_valid_from_router = 1;
            i_data_from_router = 20'h65A5A; // 20-bit data (2-bit source, 2-bit dest, 16-bit payload)

        // Deactivate after 50ns
        #50 i_valid_from_router = 0;
            i_data_from_router = 0;

        // Test Case 2: Send another packet
        #100 i_valid_from_router = 1;
             i_data_from_router = 20'h5A5A5; // Another test packet

        #50 i_valid_from_router = 0;

        // End Simulation
        #200;
        $display("\n*** PE Simulation Complete ***\n");
        $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time=%0d | clk=%b | rst=%b | i_valid=%b | i_data=%h | o_valid=%b | o_data=%h",
                 $time, clk, rst, i_valid_from_router, i_data_from_router, o_valid_to_router, o_data_to_router);
    end

endmodule
