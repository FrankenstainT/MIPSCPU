`timescale 1ns / 1ps

module exception(
    input wire rst,
    input wire[7:0] except,
    input wire adel,ades,
    input wire[31:0] cp0_status,cp0_cause,
    output reg[31:0] excepttype
);
    // get excepttype
    always@(*)begin
        if(rst) begin
            excepttype <= 32'b0;
        end else begin
            excepttype <= 32'b0;
            // interrupt set by software
            if( ((cp0_cause[15:8] & cp0_status[15:8]) != 8'b0) && // unshielded hardware or software interrupt
                (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1)) begin// 
                    excepttype <= 32'h00000001;
            end else if(except[7] == 1'b1 || adel) begin  //load i or m ex
                excepttype <= 32'h00000004;
            end else if(ades) begin                       //store m ex
                excepttype <= 32'h00000005;
            end else if(except[6] == 1'b1) begin          //syscall
                excepttype <= 32'h00000008;
            end else if(except[5] == 1'b1) begin          //break
                excepttype <= 32'h00000009;
            end else if(except[4] == 1'b1) begin          // eret
                excepttype <= 32'h0000000e;
            end else if(except[3] == 1'b1) begin          //reserved i
                excepttype <= 32'h0000000a;
            end else if(except[2] == 1'b1) begin          //overflow
                excepttype <= 32'h0000000c;
            end
        end
    end
endmodule