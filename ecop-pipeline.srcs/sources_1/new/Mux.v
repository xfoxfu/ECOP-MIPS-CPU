`timescale 1ns / 1ps

module Mux2#(parameter width = 32)
           (in0,
             in1,
             s,
             out);
    
    input      [width-1:0] in0;
    input      [width-1:0] in1;
    input                  s;
    output reg [width-1:0] out;
    
    always @(*) begin
        case (s)
            1'b0: out    <= in0;
            1'b1: out    <= in1;
            default: out <= in0;
        endcase
    end
    
endmodule
    
