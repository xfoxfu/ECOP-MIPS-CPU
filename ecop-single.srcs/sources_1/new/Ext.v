`timescale 1ns / 1ps

module Ext #(parameter width = 16)
            (imm,
             sign,
             extv);
    
    input  [width - 1 : 0] imm;
    input                    sign;
    output [width*2 - 1 : 0] extv;
    
    assign extv[width*2 - 1: width] = { width{sign & imm[width-1]} };
    assign extv[width - 1:0]        = imm;
endmodule
