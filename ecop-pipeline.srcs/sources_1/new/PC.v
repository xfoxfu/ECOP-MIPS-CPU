`timescale 1ns / 1ps

module PC(
    input Clk,
    input Reset,
    input [31:0] NextPC,
    output [31:0] PC,
    output [31:0] PC4
    );

    reg [31:0] pc;

    assign PC = pc;
    assign PC4 = pc + 4;

    initial begin
        pc <= 0;
    end

    always @(negedge Clk) begin // or negedge Reset
        if(!Reset)
            pc <= NextPC;
        else
            pc <= 0;
    end

endmodule
