`timescale 1ns / 1ps

module Memory #(parameter AW = 32,
                parameter DW = 32,
                parameter FILE = "test.mem",
                parameter SIZE = 512)
               (clk,
                rw,
                addr,
                din,
                dout);
    
    localparam BW = 8;
    
    input           clk;
    input           rw;
    input  [AW-1:0] addr;
    input  [DW-1:0] din;
    output [DW-1:0] dout;
    
    (* ram_style = "block" *) reg [BW-1:0] data[0:SIZE-1];
    
    initial begin
        $display("read from %s", FILE);
        $readmemh(FILE, data);
    end
    
    /* wire real_addr;
     assign [9:0] real_addr = addr[9:0];
     
     assign dout = (~rw) ? {data[real_addr], data[real_addr+1], data[real_addr+2], data[real_addr+3]} : 0;
     
     always @(negedge clk) begin
     if (rw) begin
     {data[real_addr], data[real_addr+1], data[real_addr+2], data[real_addr+3]} <= din;
     end
     end */
    
    // always @(addr) begin
    //     dout[31:24] <= data[addr];
    //     dout[23:16] <= data[addr + 1];
    //     dout[15: 8] <= data[addr + 2];
    //     dout[7: 0]  <= data[addr + 3];
    //     // if (~rw) begin
    //     //     dout <= {data[addr], data[addr+1], data[addr+2], data[addr+3]};
    //     // end else begin
    //     //     dout <= 0;
    //     // end
    // end
    
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
        end
    end
endmodule
