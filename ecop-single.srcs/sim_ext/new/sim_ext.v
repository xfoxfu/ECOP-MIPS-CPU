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


module sim_ext();

    parameter width = 32;

    reg [width/2-1:0] in;
    reg sign;
    wire [width-1:0] out;
    ext ext(in, sign, out);

    always begin
        in <= 16'h7F42;
        sign <= 0;
        #10;
        in <= 16'hFF42;
        sign <= 0;
        #10;
        in <= 16'hFF42;
        sign <= 1;
        #10;
        in <= 16'h8042;
        sign <= 1;
        #10;
    end
endmodule
