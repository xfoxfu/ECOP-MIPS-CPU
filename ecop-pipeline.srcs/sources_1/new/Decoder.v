`timescale 1ns / 1ps

module Decoder(inst,
               op,
               funct,
               rs,
               rt,
               rd,
               immed,
               jaddr,
               sa);
    
    input  [31:0] inst;
    output [5:0]  op;
    output [5:0]  funct;
    output [4:0]  rs;
    output [4:0]  rt;
    output [4:0]  rd;
    output [15:0] immed;
    output [27:0] jaddr;
    output [4:0]  sa;
    
    assign op    = inst[31:26];
    assign funct = inst[5:0];
    assign rs    = inst[25:21];
    assign rt    = inst[20:16];
    assign rd    = inst[15:11];
    assign immed = inst[15:0];
    assign jaddr = {inst[25:0], 2'b00};
    assign sa    = inst[10:6];
    
endmodule
