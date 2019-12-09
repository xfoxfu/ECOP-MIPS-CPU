`timescale 1ns / 1ps

module ALU #(parameter width = 32)
            (aluop,
             lhs,
             rhs,
             result,
             zero,
             sign);
    
    input  [2 : 0]           aluop;
    input  [width-1 : 0]     lhs;
    input  [width-1 : 0]     rhs;
    output reg [width-1 : 0] result;
    output reg               zero;
    output reg               sign;
    
    always @(*)
    begin
        case (aluop)
            3'b000 : result <= lhs + rhs;
            3'b001 : result <= lhs - rhs;
            3'b010 : result <= rhs << lhs;
            3'b011 : result <= lhs | rhs;
            3'b100 : result <= lhs & rhs;
            3'b101 : result <= lhs < rhs;
            3'b110 : result <= (lhs < rhs && lhs[width-1] == rhs[width-1]) ||
                              (lhs[width-1] == 1 && rhs[width-1] == 0);
            3'b111 : result <= lhs ^ rhs;
            default : ;
        endcase
        
        zero = !result;
        sign = result[31];
        $display("alu result = %b", result);
    end
endmodule
