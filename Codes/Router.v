`timescale 1ns / 1ps

module Router #(parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 2, 
                parameter MESH_SIZE = 2, parameter X_cord = 0, parameter Y_cord = 0)
(
    input clk, rst,

    // Inputs from 5 directions (N, S, E, W, PE)
    input i_valid_N, i_valid_S, i_valid_E, i_valid_W, i_valid_PE,
    input [DATA_WIDTH+2*ADDR_WIDTH-1:0] i_data_N, i_data_S, i_data_E, i_data_W, i_data_PE,

    // Outputs to 5 directions (N, S, E, W, PE)
    output reg o_valid_N, o_valid_S, o_valid_E, o_valid_W, o_valid_PE,
    output reg [DATA_WIDTH+2*ADDR_WIDTH-1:0] o_data_N, o_data_S, o_data_E, o_data_W, o_data_PE
);

// Extract destination address
wire [ADDR_WIDTH-1:0] dest_x, dest_y;
assign dest_x = selected_data[DATA_WIDTH+ADDR_WIDTH-1:DATA_WIDTH];
assign dest_y = selected_data[DATA_WIDTH+2*ADDR_WIDTH-1:DATA_WIDTH+ADDR_WIDTH];

// Compute torus wrap-around distances
wire signed [ADDR_WIDTH:0] x_offset, y_offset;
assign x_offset = dest_x - X_cord;
assign y_offset = dest_y - Y_cord;

// Wrap-around logic for torus
wire wrap_x = (x_offset == MESH_SIZE-1) || (x_offset == -(MESH_SIZE-1));
wire wrap_y = (y_offset == MESH_SIZE-1) || (y_offset == -(MESH_SIZE-1));

// Priority selection logic (Choose PE, then N/S, then E/W)
reg [DATA_WIDTH+2*ADDR_WIDTH-1:0] selected_data;
reg selected_valid;
always @(*) begin
    if (i_valid_PE) begin
        selected_data = i_data_PE;
        selected_valid = i_valid_PE;
    end else if (i_valid_N || i_valid_S) begin  // Accept only from N or S (vertical)
        if (i_valid_N) begin
            selected_data = i_data_N;
            selected_valid = i_valid_N;
        end else begin
            selected_data = i_data_S;
            selected_valid = i_valid_S;
        end
    end else if (i_valid_E || i_valid_W) begin  // Accept only from E or W (horizontal)
        if (i_valid_E) begin
            selected_data = i_data_E;
            selected_valid = i_valid_E;
        end else begin
            selected_data = i_data_W;
            selected_valid = i_valid_W;
        end
    end else begin
        selected_data = 0;
        selected_valid = 0;
    end
end

// XY Routing with Torus Support
always @(posedge clk or posedge rst) begin
    if (rst) begin
        o_valid_N <= 0; o_valid_S <= 0; o_valid_E <= 0; o_valid_W <= 0; o_valid_PE <= 0;
        o_data_N <= 0;  o_data_S <= 0;  o_data_E <= 0;  o_data_W <= 0;  o_data_PE <= 0;
    end 
    else if (selected_valid) begin
        if (dest_x == X_cord && dest_y == Y_cord) begin
            // Data belongs to this router, send to PE
            o_valid_PE <= 1; 
            o_data_PE <= selected_data;
        end else if (x_offset > 0 || wrap_x) begin
            // Route to East (wrap if needed)
            o_valid_E <= 1; 
            o_data_E <= selected_data;
        end else if (x_offset < 0 || wrap_x) begin
            // Route to West (wrap if needed)
            o_valid_W <= 1; 
            o_data_W <= selected_data;
        end else if (y_offset > 0 || wrap_y) begin
            // Route to South (wrap if needed)
            o_valid_S <= 1; 
            o_data_S <= selected_data;
        end else if (y_offset < 0 || wrap_y) begin
            // Route to North (wrap if needed)
            o_valid_N <= 1; 
            o_data_N <= selected_data;
        end
    end else begin
        // No valid input
        o_valid_N <= 0; o_valid_S <= 0; o_valid_E <= 0; o_valid_W <= 0; o_valid_PE <= 0;
    end
end

endmodule
