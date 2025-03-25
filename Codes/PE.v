`timescale 1ns / 1ps

module PE #(
    parameter DATA_WIDTH = 16, 
    parameter ADDR_WIDTH = 2
)(
    input clk, rst,
    input i_valid_from_router,
    input [DATA_WIDTH + 2*ADDR_WIDTH - 1:0] i_data_from_router, // Incoming data packet
    output reg o_valid_to_router,
    output reg [DATA_WIDTH + 2*ADDR_WIDTH - 1:0] o_data_to_router // Outgoing data packet
);

// Always pass input directly to output
always @(posedge clk or posedge rst) begin
    if (rst) begin
        o_valid_to_router <= 1'b0;
        o_data_to_router <= 0;
    end 
    else begin
        o_valid_to_router <= i_valid_from_router; // Pass valid signal
        o_data_to_router <= i_data_from_router;   // Pass input data as output
    end
end

endmodule
