`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2020 02:23:50 PM
// Design Name: 
// Module Name: floprc
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


module floprc #(parameter WIDTH=8)(
    input wire clk,rst,clear,
    input [WIDTH-1:0]d,
    output reg[WIDTH-1:0] q
    );
    always@(posedge clk,posedge rst)begin
        if(rst)begin
            q<=0;
        end else if(clear)begin
            q<=0;
        end else begin
            q<=d;
        end
    end        
endmodule
