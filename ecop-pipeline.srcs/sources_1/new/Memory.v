`timescale 1ns / 1ps

module Memory #(parameter AW = 32,
                parameter DW = 32,
                parameter FILE = "test.mem",
                parameter SIZE = 512)
               (clk,
                rw,
                addr,
                din,
                dout,
                peek);
    
    localparam BW = 8;
    
    input           clk;
    input           rw;
    input  [AW-1:0] addr;
    input  [DW-1:0] din;
    output [DW-1:0] dout;
    output reg [DW-1:0] peek;
    
    (* ram_style = "block" *) reg [BW-1:0] data[0:SIZE-1];
    
    initial begin
        $display("read from %s", FILE);
        $readmemh(FILE, data);
        peek <= 0;
    end

    assign dout[31:24] = data[addr];
    assign dout[23:16] = data[addr + 1];
    assign dout[15: 8] = data[addr + 2];
    assign dout[7: 0]  = data[addr + 3];
    
    always @(negedge clk) begin
        if (rw == 1'b1) begin
            data[addr]   <= din[31:24];
            data[addr+1] <= din[23:16];
            data[addr+2] <= din[15: 8];
            data[addr+3] <= din[7: 0];
            
            if(addr == 0)
                peek[31:24] <= din[7:0];
            else if(addr == 4)
                peek[23:16] <= din[7:0];
            else if(addr == 8)
                peek[15:8] <= din[7:0];
            else if(addr == 12)
                peek[7:0] <= din[7:0];
        end
    end
endmodule
