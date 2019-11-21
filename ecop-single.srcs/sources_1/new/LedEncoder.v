`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/11/18 20:34:11
// Design Name:
// Module Name: LedEncoder
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


module LedEncoder(input [3:0] Number,
                  output reg [6:0] LedCode);

always @(Number) begin
    case (Number)
        4'h0: LedCode    <= 7'b0000001;
        4'h1: LedCode    <= 7'b1001111;
        4'h2: LedCode    <= 7'b0010010;
        4'h3: LedCode    <= 7'b0000110;
        4'h4: LedCode    <= 7'b1001100;
        4'h5: LedCode    <= 7'b0100100;
        4'h6: LedCode    <= 7'b0100000;
        4'h7: LedCode    <= 7'b0001111;
        4'h8: LedCode    <= 7'b0000000;
        4'h9: LedCode    <= 7'b0000100;
        4'hA: LedCode    <= 7'b0001000;
        4'hb: LedCode    <= 7'b1100000;
        4'hc: LedCode    <= 7'b1110010;
        4'hd: LedCode    <= 7'b1000010;
        4'hE: LedCode    <= 7'b0110000;
        4'hF: LedCode    <= 7'b0111000;
        default: LedCode <= 7'b1111111;
    endcase
end
endmodule
