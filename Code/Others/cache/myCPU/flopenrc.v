module flopenrc#(parameter N=8)(
    input clk,rst,en,clear,
    input[N-1:0]d,
    output reg[N-1:0]q
);
    always@(posedge clk)begin
        if(rst)begin
            q<=0;
        end else if(clear)begin
            q<=0;
        end else if(en)begin
            q<=d;
        end
    end
endmodule