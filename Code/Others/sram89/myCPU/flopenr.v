`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2020 02:41:09 PM
// Design Name: 
// Module Name: flopenr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flopenr#(parameter N=8)(
    input clk,
    input rst,
    input enable,
    input [N-1:0]d,
    output reg[N-1:0]q
    );
    always@(posedge clk)begin
        if(rst)begin
            q<=0;
        end
        else if(enable) begin
            q<=d;
        end
    end
endmodule
