`timescale 1ns / 1ps

module TorusNoC_Testbench;

    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = 2;
    parameter MESH_SIZE = 2;

    reg clk, rst;
    reg [(MESH_SIZE*MESH_SIZE)-1:0] valid_PE;
    reg [(MESH_SIZE*MESH_SIZE)*(DATA_WIDTH + 2*ADDR_WIDTH)-1:0] data_PE;
    
    wire [(MESH_SIZE*MESH_SIZE)-1:0] valid_out_PE;
    wire [(MESH_SIZE*MESH_SIZE)*(DATA_WIDTH + 2*ADDR_WIDTH)-1:0] data_out_PE;

    // Instantiate Torus NoC
    TorusNoC #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .MESH_SIZE(MESH_SIZE)) torus_inst (
        .clk(clk), .rst(rst),
        .valid_PE(valid_PE),
        .data_PE(data_PE),
        .valid_out_PE(valid_out_PE),
        .data_out_PE(data_out_PE)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        valid_PE = 0;
        data_PE = 0;
        #20 rst = 0;
        $display("\n*** Torus NoC Simulation Started ***\n");

        #50 valid_PE[0] = 1; data_PE[0*(DATA_WIDTH+2*ADDR_WIDTH) +: (DATA_WIDTH+2*ADDR_WIDTH)] = {2'b01, 2'b01, 16'hAAAA};
        #10 valid_PE[0] = 0;

        #50 valid_PE[1] = 1; data_PE[1*(DATA_WIDTH+2*ADDR_WIDTH) +: (DATA_WIDTH+2*ADDR_WIDTH)] = {2'b10, 2'b00, 16'hBBBB};
        #10 valid_PE[1] = 0;

        #200;
        $stop;
    end
endmodule
