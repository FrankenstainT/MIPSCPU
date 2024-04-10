`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 11:42:39 AM
// Design Name: 
// Module Name: Adder1
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


module Adder#(parameter N=32)
            (input[N-1:0] a, input[N-1:0] b,output [N-1:0] s);
      assign s=a+b;
endmodule
