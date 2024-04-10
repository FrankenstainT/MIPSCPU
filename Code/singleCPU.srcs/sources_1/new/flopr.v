`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2020 02:36:19 PM
// Design Name: 
// Module Name: flopr
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


module flopr#(parameter N=8)(
    input clk,rst,
    input[N-1:0] d,
    output reg[N-1:0]q
    );
    always@(posedge clk, posedge rst)begin
        if(rst)begin
            q<=0;
        end else begin
            q<=d;
        end
    end
endmodule
