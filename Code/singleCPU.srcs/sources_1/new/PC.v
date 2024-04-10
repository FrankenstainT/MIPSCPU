`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 09:48:47 AM
// Design Name: 
// Module Name: PC
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

// pc current pc
// npc next pc
// inst_ce valid enable, output reg inst_ce
module PC#(parameter N=32)
    (input clk,input rst,input en,input [N-1:0] npc, output reg [N-1:0] pc);
always@(posedge clk,posedge rst)begin
    if(rst)begin
        //inst_ce<=0;
        pc<=0;
    end
    else if(en)begin
        //inst_ce<=1;
        pc<=npc;
    end
end
endmodule
