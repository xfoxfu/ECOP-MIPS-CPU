`timescale 1ns / 1ps

module ClkDiv #(parameter N = 2,
                   parameter WIDTH = 8)
                 (input clk,
                   input rst_n,
                   output reg clk_out);
    
    reg [WIDTH-1 : 0] cnt;
    always @(posedge clk, negedge rst_n)
    begin
        if (!rst_n)
            cnt <= 0;
        else
        begin
            if (cnt == N - 1)
            begin
                cnt <= 0;
            end
            else
            begin
                cnt <= cnt + 1;
            end
        end
    end
    
    always @(posedge clk, negedge rst_n)
    begin
        if (!rst_n)
            clk_out <= 0;
        else
            if (cnt == N - 1) begin
                clk_out <= !clk_out;
            end
    end
    
endmodule
