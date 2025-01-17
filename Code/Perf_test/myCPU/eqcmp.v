`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2020 09:06:05 PM
// Design Name: 
// Module Name: eqcmp
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
`include "defines.vh"
`include "defines2.vh"

module eqcmp(
    input wire[31:0]a,b,
    input[5:0] op,// new
    input[4:0] rt, // new
    output y
    );
    assign y=(op==`EXE_BEQ)?(a==b):
            (op==`EXE_BNE)?(a!=b):
            (op==`EXE_BGTZ)?((a[31]==1'b0)&&(a!=`ZeroWord)):
            (op==`EXE_BLEZ)?((a[31]==1'b1)||(a==`ZeroWord)):
            ((op==`EXE_REGIMM_INST)&&((rt==`EXE_BGEZ)||(rt==`EXE_BGEZAL)))?(a[31]==1'b0):
            ((op==`EXE_REGIMM_INST)&&((rt==`EXE_BLTZ)||(rt==`EXE_BLTZAL)))?(a[31]==1'b1):1'b0;
endmodule
