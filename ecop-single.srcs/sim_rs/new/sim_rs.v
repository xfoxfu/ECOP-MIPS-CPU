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


module sim_rs();
    
    parameter IW = 5;
    parameter DW = 32;
    
    reg [IW-1:0] reg0;
    reg [IW-1:0] reg1;
    reg [IW-1:0] regw;
    reg wr;
    reg [DW-1:0] dataw;
    wire [DW-1:0] data0;
    wire [DW-1:0] data1;
    reg clk;
    
    reg_stack rs(reg0, reg1, regw, wr, dataw, data0, data1, clk);
    
    initial begin
        clk   <= 0;
        reg0  <= 0;
        reg1  <= -2;
        regw  <= -1;
        wr    <= 1;
        dataw <= 32'h12345678;
        forever begin
            #10 clk <= ~clk;
        end
    end
    
    always @(posedge clk) begin
        reg0 <= reg0 + 1;
        reg1 <= reg1 + 1;
        regw <= regw + 1;
    end
endmodule
