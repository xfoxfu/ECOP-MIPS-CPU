`timescale 1ns / 1ps

module Mux4#(parameter width = 32)
           (in00,
            in01,
            in10,
            in11,
            s,
            out);

    input      [width-1:0] in00;
    input      [width-1:0] in01;
    input      [width-1:0] in10;
    input      [width-1:0] in11;
    input            [1:0] s;
    output reg [width-1:0] out;
    
    always @(*) begin
        case (s)
            2'b00: out    <= in00;
            2'b01: out    <= in01;
            2'b10: out    <= in10;
            2'b11: out    <= in11;
            default: out  <= in00;
        endcase
    end
    
endmodule
    
