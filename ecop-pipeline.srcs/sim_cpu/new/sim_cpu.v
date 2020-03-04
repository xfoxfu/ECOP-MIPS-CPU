`timescale 1us / 1ps

module sim_cpu();

    reg Clk;
    reg Reset;
    wire [31:0] Pc;
    wire [31:0] NextPc;
    wire [31:0] RsId;
    wire [31:0] RsVal;
    wire [31:0] RtId;
    wire [31:0] RtVal;
    wire [31:0] AluVal;
    wire [31:0] MemVal;
    

    initial begin
        Clk <= 1; Reset <= 1;
        #1 Clk <= 0;
        #1 Reset <= 0;
        forever #1 Clk <= ~Clk;
    end
    
    CPU cpu(.Clk(Clk), .Reset(Reset), .Pc(Pc), .NextPc(NextPc), .RsId(RsId), .RsVal(RsVal), .RtId(RtId), .RtVal(RtVal), .AluVal(AluVal), .MemVal(MemVal));

endmodule // sim_cpu
