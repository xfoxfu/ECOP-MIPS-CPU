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
        Clk <= 0;
        Reset <= 1;
        #2 Reset <= 0;
        forever #1 Clk <= ~Clk;
    end
    
    CPU cpu(.Clk(Clk), .Reset(Reset), .Pc(Pc), .NextPc(NextPc), .RsId(RsId), .RsVal(RsVal), .RtId(RtId), .RtVal(RtVal), .AluVal(AluVal), .MemVal(MemVal));

    always @(posedge Clk) begin
        if (Pc == NextPc) 
            $stop;
    end
    
endmodule // sim_cpu