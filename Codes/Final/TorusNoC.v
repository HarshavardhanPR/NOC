module TorusNoC #(parameter DATA_WIDTH = 16, 
                  parameter ADDR_WIDTH = 2, 
                  parameter MESH_SIZE = 2) 
(
    input clk, rst,
    
    // PE Inputs
    input  [(MESH_SIZE*MESH_SIZE)-1:0] valid_PE,
    input  [(MESH_SIZE*MESH_SIZE)*(DATA_WIDTH + 2*ADDR_WIDTH)-1:0] data_PE,
    
    // PE Outputs
    output [(MESH_SIZE*MESH_SIZE)-1:0] valid_out_PE,
    output [(MESH_SIZE*MESH_SIZE)*(DATA_WIDTH + 2*ADDR_WIDTH)-1:0] data_out_PE
);

    localparam TOTAL_PEs = MESH_SIZE * MESH_SIZE;
    
    // Internal connections between routers
    wire [DATA_WIDTH+2*ADDR_WIDTH-1:0] data_N [0:TOTAL_PEs-1];
    wire [DATA_WIDTH+2*ADDR_WIDTH-1:0] data_S [0:TOTAL_PEs-1];
    wire [DATA_WIDTH+2*ADDR_WIDTH-1:0] data_E [0:TOTAL_PEs-1];
    wire [DATA_WIDTH+2*ADDR_WIDTH-1:0] data_W [0:TOTAL_PEs-1];

    wire valid_N [0:TOTAL_PEs-1];
    wire valid_S [0:TOTAL_PEs-1];
    wire valid_E [0:TOTAL_PEs-1];
    wire valid_W [0:TOTAL_PEs-1];

    genvar i, j;
    generate
        for (i = 0; i < MESH_SIZE; i = i + 1) begin : row
            for (j = 0; j < MESH_SIZE; j = j + 1) begin : col
                localparam ID = i * MESH_SIZE + j;

                Router #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) router_inst (
                    .clk(clk),
                    .rst(rst),

                    // PE Interfaces
                    .i_valid_PE(valid_PE[ID]),
                    .i_data_PE(data_PE[(ID)*(DATA_WIDTH+2*ADDR_WIDTH) +: (DATA_WIDTH+2*ADDR_WIDTH)]),
                    .o_valid_PE(valid_out_PE[ID]),
                    .o_data_PE(data_out_PE[(ID)*(DATA_WIDTH+2*ADDR_WIDTH) +: (DATA_WIDTH+2*ADDR_WIDTH)]),

                    // North Connection
                    .i_valid_N(valid_S[(ID+MESH_SIZE) % TOTAL_PEs]),
                    .i_data_N(data_S[(ID+MESH_SIZE) % TOTAL_PEs]),
                    .o_valid_N(valid_N[ID]),
                    .o_data_N(data_N[ID]),

                    // South Connection
                    .i_valid_S(valid_N[(ID+TOTAL_PEs-MESH_SIZE) % TOTAL_PEs]),
                    .i_data_S(data_N[(ID+TOTAL_PEs-MESH_SIZE) % TOTAL_PEs]),
                    .o_valid_S(valid_S[ID]),
                    .o_data_S(data_S[ID]),

                    // East Connection
                    .i_valid_E(valid_W[(ID+1) % MESH_SIZE + (i * MESH_SIZE)]),
                    .i_data_E(data_W[(ID+1) % MESH_SIZE + (i * MESH_SIZE)]),
                    .o_valid_E(valid_E[ID]),
                    .o_data_E(data_E[ID]),

                    // West Connection
                    .i_valid_W(valid_E[(ID+MESH_SIZE-1) % MESH_SIZE + (i * MESH_SIZE)]),
                    .i_data_W(data_E[(ID+MESH_SIZE-1) % MESH_SIZE + (i * MESH_SIZE)]),
                    .o_valid_W(valid_W[ID]),
                    .o_data_W(data_W[ID])
                );
            end
        end
    endgenerate
endmodule
