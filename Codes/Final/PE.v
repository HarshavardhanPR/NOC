module PE #(parameter DATA_WIDTH = 16, ADDR_WIDTH = 2) (
    input clk, rst,
    input i_valid,
    input [DATA_WIDTH+2*ADDR_WIDTH-1:0] i_data,
    output reg o_valid,
    output reg [DATA_WIDTH+2*ADDR_WIDTH-1:0] o_data
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_valid <= 0;
            o_data  <= 0;
        end else begin
            o_valid <= i_valid;
            o_data  <= i_data;
        end
    end

endmodule
