module MeshNoC #(parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 2) (
    input clk, rst
);

genvar x, y;
generate
    for (x = 0; x < 2; x = x + 1) begin : X_Loop
        for (y = 0; y < 2; y = y + 1) begin : Y_Loop
            Router #(DATA_WIDTH, ADDR_WIDTH) router_inst (
                .clk(clk), .rst(rst)
            );
        end
    end
endgenerate

endmodule
