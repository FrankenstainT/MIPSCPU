`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 08:57:29 AM
// Design Name: 
// Module Name: sign_extend
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

// signed extend and unsigned (for immediate instrution) extend
module sign_extend(input wire[15:0] a,input wire[1:0] type, output wire[31:0] y);
assign y=(type==2'b11)?{{16{1'b0}},a}:{{16{a[15]}},a};
endmodule
