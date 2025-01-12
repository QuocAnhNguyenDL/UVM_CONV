`timescale 1ns / 1ps

module conv #(parameter COL = 5, BIT_WIDTH = 8, IN_WIDTH = 8, OUT_WIDTH = 32) (
    input clk, en,
    input [0:(BIT_WIDTH*25)-1] kernel,
    input [IN_WIDTH-1:0] in1, in2, in3, in4, in5,
    output[OUT_WIDTH-1:0] conv_result
);
    
    reg [IN_WIDTH-1:0] m55[COL][COL];
    integer i;
    
    always_ff @(posedge clk)
    begin
        if(en) begin
            for(i = COL-1 ; i > 0 ; i = i-1)
            begin
                m55[0][i] <= m55[0][i-1]; 
                m55[1][i] <= m55[1][i-1]; 
                m55[2][i] <= m55[2][i-1]; 
                m55[3][i] <= m55[3][i-1];   
                m55[4][i] <= m55[4][i-1];
            end
            
            m55[0][0] <= in1;
            m55[1][0] <= in2;
            m55[2][0] <= in3;
            m55[3][0] <= in4;
            m55[4][0] <= in5;
        end
    end 
   
    reg [OUT_WIDTH-1:0] mul[0:COL*COL-1], tmp[0:22];
    genvar x,y;
    
    generate
        for(x = 0; x < COL ; x = x+1) begin
            for(y = 0 ; y < COL; y = y+1)
            begin
                assign mul[COL*x+y] = m55[x][y] * kernel[((4-y)*8 + 40*x):((4-y)*8 + 40*x+7)];
            end
        end
        
        for(x = 0; x < 12; x = x+1) assign tmp[x] = mul[2*x] + mul[2*x+1];
        
        for(x = 12; x < 18; x = x+1) assign tmp[x] = tmp[2*(x-12)] + tmp[2*(x-12)+1];
        
        for(x = 18; x < 21; x = x+1) assign tmp[x] = tmp[2*(x-18)+12] + tmp[2*(x-18)+13];
        
        assign tmp[21] = tmp[18] + tmp[19];
        assign tmp[22] = tmp[20] + mul[24];
    endgenerate
  
    assign conv_result = tmp[21] + tmp[22];
endmodule