module params #(
    parameter BIT_WIDTH = 8,
    parameter SIZE = 26,                  // Size of the parameter array
    parameter FILE = "kernel_c1.list"     // Path to the kernel data file
)(
    input clk,                            // Clock input
    input read,                           // Read control signal
    output reg [0:BIT_WIDTH*SIZE-1] read_out  // Output register to hold the read data
);

    reg [BIT_WIDTH-1:0] weights [0:SIZE-1];

    initial begin
        $readmemh(FILE, weights); 
    end

    reg [15:0] i;

    always_ff @(posedge clk) begin
        if (read) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                read_out[i*BIT_WIDTH +: BIT_WIDTH] <= weights[i];
            end
        end
    end

endmodule