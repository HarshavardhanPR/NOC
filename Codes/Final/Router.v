module Router #(parameter DATA_WIDTH = 16, ADDR_WIDTH = 2) (
    input clk, rst,
    input i_valid_PE, i_valid_N, i_valid_S, i_valid_E, i_valid_W,
    input [DATA_WIDTH+2*ADDR_WIDTH-1:0] i_data_PE, i_data_N, i_data_S, i_data_E, i_data_W,
    output reg o_valid_PE, o_valid_N, o_valid_S, o_valid_E, o_valid_W,
    output reg [DATA_WIDTH+2*ADDR_WIDTH-1:0] o_data_PE, o_data_N, o_data_S, o_data_E, o_data_W
);

    wire [ADDR_WIDTH-1:0] dest_x = i_data_PE[DATA_WIDTH+ADDR_WIDTH-1:DATA_WIDTH];
    wire [ADDR_WIDTH-1:0] dest_y = i_data_PE[DATA_WIDTH+2*ADDR_WIDTH-1:DATA_WIDTH+ADDR_WIDTH];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_valid_PE <= 0; o_valid_N <= 0; o_valid_S <= 0;
            o_valid_E <= 0; o_valid_W <= 0;
            o_data_PE <= 0; o_data_N <= 0; o_data_S <= 0;
            o_data_E <= 0; o_data_W <= 0;
        end else begin
            if (i_valid_PE) begin
                if (dest_x > 1) begin
                    o_valid_E <= 1;
                    o_data_E  <= i_data_PE;
                end else if (dest_x < 1) begin
                    o_valid_W <= 1;
                    o_data_W  <= i_data_PE;
                end else if (dest_y > 1) begin
                    o_valid_N <= 1;
                    o_data_N  <= i_data_PE;
                end else if (dest_y < 1) begin
                    o_valid_S <= 1;
                    o_data_S  <= i_data_PE;
                end else begin
                    o_valid_PE <= 1;
                    o_data_PE  <= i_data_PE;
                end
            end
        end
    end

endmodule
