`timescale 1ns / 1ps

module RegStack #(parameter id_width = 5,
                   parameter data_width = 32)
                  (reset,
                  reg0,
                   reg1,
                   regw,
                   wr,
                   dataw,
                   data0,
                   data1,
                   clk);
    
    localparam id_count = 2 ** id_width;
    
    input  [id_width - 1   : 0] reg0;
    input  [id_width - 1   : 0] reg1;
    input  [id_width - 1   : 0] regw;
    input                       wr;
    input  [data_width - 1 : 0] dataw;
    output [data_width - 1 : 0] data0;
    output [data_width - 1 : 0] data1;
    input                       clk;
    input                       reset;
    
    reg [data_width - 1:0] rstack[0 : id_count - 1];
    
    initial begin
        for (integer i = 0; i < id_count; i = i+1) begin
            rstack[i] <= 0;
        end
    end

    assign data0 = rstack[reg0];
    assign data1 = rstack[reg1];
    
    always @(negedge clk) begin // or negedge reset
        if (!reset) begin
            if (wr && (regw != 0)) begin
                rstack[regw] <= dataw;
            end
        end
        else begin
            for (integer i = 0; i < id_count; i = i+1) begin
                rstack[i] <= 0;
            end
        end
    end
endmodule
