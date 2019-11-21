module sim_mem();
    
    reg [31:0] din;
    wire [31:0] dout;
    reg clk;
    reg [31:0] addr;
    reg rw;
    
    Memory #(.FILE("test.mem")) mem(clk, rw, addr, din, dout);
    
    initial begin
        clk  <= 0;
        addr <= 0;
        rw   <= 0;
        forever begin
            #1 clk <= ~clk;
        end
    end
    
    always @(posedge clk) begin
        addr <= addr + 1;
        rw   <= ~rw;
        din  <= 32'h32FF420B;
    end
    
endmodule // sim_mem
