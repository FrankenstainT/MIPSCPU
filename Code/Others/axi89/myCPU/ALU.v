`timescale 10ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2020 06:15:43 PM
// Design Name: 
// Module Name: ALU
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


module ALU(A,B,F,sa,Y,hilo_temp,overflowE);
    parameter N=32;
    input[N-1:0] A;// The first input signal
    input [N-1:0] B;// The second input signal
    input [7:0] F;// Control signal(op) // 2 to 7
    input [4:0] sa;
    output overflowE;
    output [N-1:0] Y;// Result
    output [(N<<1)-1:0] hilo_temp;
    //output zero;
    wire [N-1:0] t; // Temp for frameshift of A
    wire [N-1:0] u; // Temp for frameshift of B
    wire [N-1:0] multA; // Temp for A in signed multiply
    wire [N-1:0] multB; // Temp for B in signed multiply
    wire [N:0] cbitr; // result with carry bit
    // Get frameshift  // make sure positive number is larger than negative number
    assign u=B+(32'b1<<(N-1));
    assign t=A+(32'b1<<(N-1));
    assign multA=((F==`EXE_MULT_OP)&&(A[31]==1'b1))?(~A+1):A;
    assign multB=((F==`EXE_MULT_OP)&&(B[31]==1'b1))?(~B+1):B;
    assign hilo_temp=((F==`EXE_MULT_OP) && (A[31]^B[31]==1'b1))?~(multA*multB)+1:multA*multB;
    // Implement function via assign
    /*assign Y = (F==3'b010)?A+B:
               (F==3'b110)?A-B:
               (F==3'b000)?A&B:
               (F==3'b001)?A|B:
               (F==3'b100)?~A:
               (F==3'b111)?((t<u)?8'b1:8'b0):32'h00;*/
    assign Y =  // logic
                (F==`EXE_AND_OP)?        A&B:
                (F==`EXE_OR_OP)?         A|B:
                (F==`EXE_XOR_OP)?        A^B:
                (F==`EXE_NOR_OP)?        ~(A|B):
                (F==`EXE_ANDI_OP)?       A&B:
                (F==`EXE_XORI_OP)?       A^B:
                (F==`EXE_LUI_OP)?        {B[15:0],16'b0}:
                (F==`EXE_ORI_OP)?        A|B:
                // sll etc
                (F==`EXE_SLL_OP)?        B<<sa:
                (F==`EXE_SRL_OP)?        B>>sa:
                (F==`EXE_SRA_OP)?        ({32{B[31]}}<<(6'd32-{1'b0,sa}))|B>>sa:
                (F==`EXE_SLLV_OP)?       B<<A[4:0]:
                (F==`EXE_SRLV_OP)?       B>>A[4:0]:
                (F==`EXE_SRAV_OP)?       ({32{B[31]}}<<(6'd32-{1'b0,A[4:0]}))|B>>A[4:0]:
                // arithmetic
                (F==`EXE_ADD_OP)?        A+B://(B>~A)?32'b0:
                (F==`EXE_ADDU_OP)?       A+B:
                (F==`EXE_SUB_OP)?        A-B:
                (F==`EXE_SUBU_OP)?       A-B:
                (F==`EXE_SLT_OP)?        (t<u)?1:0:
                (F==`EXE_SLTU_OP)?       (A<B)?1:0:
                (F==`EXE_ADDI_OP)?        A+B:
                (F==`EXE_ADDIU_OP)?       A+B:
                (F==`EXE_SLTI_OP)?        (t<u)?1:0:
                (F==`EXE_SLTIU_OP)?       (A<B)?1:0:
                // lw, sw
                ((F==`EXE_LB_OP)|(F==`EXE_LBU_OP)|(F==`EXE_LH_OP)|(F==`EXE_LHU_OP)|(F==`EXE_LW_OP)|
                (F==`EXE_SB_OP)|(F==`EXE_SH_OP)|(F==`EXE_SW_OP))?A+B:
                // mtc0
                (F==`EXE_MTC0_OP)? B:
                (F==8'b00110101)?  (A[31]?(1+~A):A):     
                //hilo
                /*(F==`EXE_MFHI_OP)?       :
                (F==`EXE_MFLO_OP)?       :
                (F==`EXE_MTHI_OP)?       :
                (F==`EXE_MTLO_OP)?       :*/
                32'b0;
    assign cbitr = ((F==`EXE_ADD_OP)|(F==`EXE_ADDI_OP))? {A[31],A}+{B[31],B}:
                    (F==`EXE_SUB_OP)? {A[31],A}-{B[31],B}:
                    32'b0;
    assign overflowE = ((F==`EXE_ADD_OP)|(F==`EXE_ADDI_OP)|(F==`EXE_SUB_OP))?cbitr[N]^Y[N-1]:
                        1'b0;

    //assign zero=(A-B==0)?1:0;           
    // Implement function via always
    /*always@(*)
    begin
        case(F)
            3'b000:Y=A+B;
            3'b001:Y=A-B;
            3'b010:Y=A&B;
            3'b011:Y=A|B;
            3'b100:Y=~A;
            3'b101:Y=(t<u)?8'b1:8'b0;
            default:Y=A;
        endcase
    end*/
endmodule
