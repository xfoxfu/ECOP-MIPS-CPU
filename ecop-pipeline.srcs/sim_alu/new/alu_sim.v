`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/11/07 15:51:41
// Design Name:
// Module Name: alu_sim
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


module alu_sim();
    
    parameter width = 32;
    
    reg [2 : 0] aluop;
    reg [width-1 : 0] lhs;
    reg [width-1 : 0] rhs;
    wire [width-1 : 0] result;
    wire               zero;
    wire               sign;
    
    alu alu(aluop, lhs, rhs, result, zero, sign);
    
    initial begin
        aluop = 0;
        lhs   = 32'ha735e5c5;
        rhs   = 32'h51dad59c;
        #10
        aluop = 1;
        lhs   = 32'h67223c6e;
        rhs   = 32'h5c3551e9;
        #10
        aluop = 2;
        lhs   = 32'h2f708438;
        rhs   = 32'h3662b37b;
        #10
        aluop = 3;
        lhs   = 32'hc4eda08e;
        rhs   = 32'h3e97ba12;
        #10
        aluop = 4;
        lhs   = 32'h4db65c12;
        rhs   = 32'h06339de7;
        #10
        aluop = 5;
        lhs   = 32'ha4e72867;
        rhs   = 32'hcd960d57;
        #10
        aluop = 6;
        lhs   = 32'h32bc5a07;
        rhs   = 32'h71ff173a;
        #10
        aluop = 7;
        lhs   = 32'he37acaf4;
        rhs   = 32'h951c2efb;
    end
endmodule
