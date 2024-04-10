`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2021 11:23:33 AM
// Design Name: 
// Module Name: mux4
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


module mux4 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] a,b,c,d,
    input [1:0] s,
    output [WIDTH-1:0] y
    );
    assign y=(s==2'b00)?a:
            (s==2'b01)?b:
            (s==2'b10)?c:
            (s==2'b11)?d:0;
endmodule
