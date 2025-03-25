`timescale 1ns / 1ps

module Testbench;
    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = 2;

    reg clk, rst;
    integer sim_time = 1000;

    // Instantiate NoC
    MeshNoC #(DATA_WIDTH, ADDR_WIDTH) mesh_noc (.clk(clk), .rst(rst));

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #20 rst = 0;

        $display("\n*** Starting Simulation ***\n");

        // Inject packets at PE(0,0) targeting PE(1,1)
        #50 mesh_noc.router_inst[0][0].i_valid_PE = 1'b1;
            mesh_noc.router_inst[0][0].i_data_PE = {2'b00, 2'b11, 16'hA5A5};

        // Inject packets at PE(1,1) targeting PE(0,0)
        #50 mesh_noc.router_inst[1][1].i_valid_PE = 1'b1;
            mesh_noc.router_inst[1][1].i_data_PE = {2'b11, 2'b00, 16'h5A5A};

        #500;
        
        // Stop Simulation
        $display("\n*** Simulation Complete ***\n");
        $stop;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0d | clk=%b | rst=%b | PE(0,0) Data=%h | PE(1,1) Data=%h",
                 $time, clk, rst, 
                 mesh_noc.router_inst[0][0].o_data_PE, 
                 mesh_noc.router_inst[1][1].o_data_PE);
    end

endmodule
