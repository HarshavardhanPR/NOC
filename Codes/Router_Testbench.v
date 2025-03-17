`timescale 1ns / 1ps

module Router_Testbench;

    // Parameters
    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = 2;
    parameter MESH_SIZE = 2;
    
    // Clock & Reset
    reg clk, rst;

    // Router Inputs
    reg i_valid_N, i_valid_S, i_valid_E, i_valid_W, i_valid_PE;
    reg [DATA_WIDTH+2*ADDR_WIDTH-1:0] i_data_N, i_data_S, i_data_E, i_data_W, i_data_PE;

    // Router Outputs
    wire o_valid_N, o_valid_S, o_valid_E, o_valid_W, o_valid_PE;
    wire [DATA_WIDTH+2*ADDR_WIDTH-1:0] o_data_N, o_data_S, o_data_E, o_data_W, o_data_PE;

    // Instantiate Router
    Router #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MESH_SIZE(MESH_SIZE), .X_cord(1), .Y_cord(1)) router_inst (
        .clk(clk),
        .rst(rst),
        .i_valid_N(i_valid_N), .i_valid_S(i_valid_S), .i_valid_E(i_valid_E), .i_valid_W(i_valid_W), .i_valid_PE(i_valid_PE),
        .i_data_N(i_data_N), .i_data_S(i_data_S), .i_data_E(i_data_E), .i_data_W(i_data_W), .i_data_PE(i_data_PE),
        .o_valid_N(o_valid_N), .o_valid_S(o_valid_S), .o_valid_E(o_valid_E), .o_valid_W(o_valid_W), .o_valid_PE(o_valid_PE),
        .o_data_N(o_data_N), .o_data_S(o_data_S), .o_data_E(o_data_E), .o_data_W(o_data_W), .o_data_PE(o_data_PE)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Simulation Process
    initial begin
        clk = 0;
        rst = 1;
        i_valid_N = 0; i_valid_S = 0; i_valid_E = 0; i_valid_W = 0; i_valid_PE = 0;
        i_data_N = 0; i_data_S = 0; i_data_E = 0; i_data_W = 0; i_data_PE = 0;

        #20 rst = 0;
        $display("\n*** Router Simulation Started ***\n");

        // Test North Input
        #50 i_valid_N = 1;
            i_data_N = {2'b01, 2'b00, 16'hAAAA};
        #10 i_valid_N = 0;

        // Test South Input
        #50 i_valid_S = 1;
            i_data_S = {2'b00, 2'b01, 16'hBBBB};
        #10 i_valid_S = 0;

        // Test East Input
        #50 i_valid_E = 1;
            i_data_E = {2'b01, 2'b01, 16'hCCCC};
        #10 i_valid_E = 0;

        // Test West Input
        #50 i_valid_W = 1;
            i_data_W = {2'b10, 2'b01, 16'hDDDD};
        #10 i_valid_W = 0;

        // Test PE Input
        #50 i_valid_PE = 1;
            i_data_PE = {2'b11, 2'b10, 16'hEEEE};
        #10 i_valid_PE = 0;

        // Wait and End
        #200;
        $display("\n*** Router Simulation Complete ***\n");
        $stop;
    end

    initial begin
        $monitor("Time=%0d | clk=%b | o_valid_N=%b | o_valid_S=%b | o_valid_E=%b | o_valid_W=%b | o_valid_PE=%b",
                 $time, clk, o_valid_N, o_valid_S, o_valid_E, o_valid_W, o_valid_PE);
    end

endmodule
