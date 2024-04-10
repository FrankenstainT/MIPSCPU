`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:20:09
// Design Name: 
// Module Name: regfile
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


module regfile(
	input wire clk,
	input rst,
	input wire we3,// write enable
	input wire[4:0] ra1,ra2,wa3,// read address rs rt rd 
	input wire[31:0] wd3,// write data
	output wire[31:0] rd1,rd2,reg1,reg2,reg3,reg4,reg31//,v0//,a1// read data
	//output reg[31:0] rf[31:0]
    );
	reg [31:0] rf[31:0];
	always @(posedge clk) #2 begin
		if(rst)begin
			for(integer i=0;i<32;i=i+1)begin
				rf[i]<=0;
			end
		end
		else if(we3) begin
			 rf[wa3] <= wd3;
		end
	end
	assign rd1 = (ra1 != 0) ? rf[ra1] : 32'b0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 32'b0;
	assign reg1=rf[1];
	assign reg2=rf[2];
	assign reg3=rf[3];
	assign reg4=rf[4];
	assign reg31=rf[31];
	//assign a1=rf[5];
endmodule
