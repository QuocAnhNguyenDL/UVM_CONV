
`timescale 1ns / 1ps

module valid_data(
    input clk, 
    output valid
    );
    
    parameter IMG_SIZE = 32;
    parameter S2_SIZE = 28;
    
    reg S2;
    reg [10:0] count_clk = 0;
    reg start = 0;
    reg [4:0] count_S2 = 0; //each 28 cycle, skip 4
    
    always_ff @(posedge clk)
    begin
        if(count_clk == IMG_SIZE * 4 + 4) //132 = 32*4 + 4
        begin
            start <= 1'b1;
            S2 <= 1'b1;
            count_S2 <= 5;
        end
        if(count_clk == IMG_SIZE * IMG_SIZE) //1025 = 32*32+5 
        begin
            start <= 1'b0;
            S2 <= 1'b0;
        end
        if(count_clk < IMG_SIZE * IMG_SIZE) count_clk = count_clk + 1;
    end
    
    always_ff @(posedge clk)
    begin
        if(start == 1'b1)
        begin
            if(count_S2 >=4) 
            begin
                S2 <= 1'b1;
            end
            else 
            begin
                S2 <= 1'b0;
            end
            
            if(count_S2 < 31) count_S2 <= count_S2 + 1;
            else count_S2 <= 4'b0;
        end
    end
    
    assign valid = S2;
endmodule
