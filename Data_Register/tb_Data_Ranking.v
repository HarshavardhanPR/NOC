`timescale 1ns / 1ps

module tb_Data_Ranking;

    reg clk;
    reg reset;
    reg [3:0] input_valid;
    reg [31:0] age_of_data;
    reg [31:0] input_data;
    wire [31:0] ranked_data;

    // Instantiate the Data Ranking module
    Data_Ranking uut (
        .clk(clk),
        .reset(reset),
        .input_valid(input_valid),
        .age_of_data(age_of_data),
        .input_data(input_data),
        .ranked_data(ranked_data)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        input_valid = 4'b1111;
        age_of_data = {8'd40, 8'd30, 8'd20, 8'd10}; // 40, 30, 20, 10
        input_data = {8'hD4, 8'hB2, 8'hC3, 8'hA1}; // Corresponding data

        #10 reset = 1; // Release reset
        #50 $finish;   // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Ranked Data: %h", $time, ranked_data);
    end

endmodule
