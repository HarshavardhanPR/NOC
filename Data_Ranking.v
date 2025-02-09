module Data_Ranking (
    input wire clk,
    input wire reset,
    input wire [3:0] input_valid,    // 4-bit valid signals from four ports
    input wire [31:0] age_of_data,   // 4 x 8-bit age values (concatenated)
    input wire [31:0] input_data,    // 4 x 8-bit data values (concatenated)
    output reg [31:0] ranked_data    // 4 x 8-bit ranked data (concatenated)
);

    integer i, j;
    reg [7:0] age[3:0];
    reg [7:0] data[3:0];
    reg [7:0] temp_age, temp_data;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            ranked_data <= 32'd0;
        end else begin
            // Extract individual 8-bit values from concatenated 32-bit buses
            age[0] = age_of_data[7:0];
            age[1] = age_of_data[15:8];
            age[2] = age_of_data[23:16];
            age[3] = age_of_data[31:24];

            data[0] = input_data[7:0];
            data[1] = input_data[15:8];
            data[2] = input_data[23:16];
            data[3] = input_data[31:24];

            // Sorting algorithm (Bubble Sort) based on age
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < 3 - i; j = j + 1) begin
                    if (age[j] > age[j+1]) begin
                        // Swap ages
                        temp_age = age[j];
                        age[j] = age[j+1];
                        age[j+1] = temp_age;

                        // Swap corresponding data
                        temp_data = data[j];
                        data[j] = data[j+1];
                        data[j+1] = temp_data;
                    end
                end
            end

            // Concatenate sorted data back into a 32-bit bus
            ranked_data = {data[3], data[2], data[1], data[0]};
        end
    end

endmodule
