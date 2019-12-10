module StageIdEx(input Clk,
                 input InstMRwIn,
                 input ALUOpAIn,
                 input ALUOpBIn,
                 input ExtTypeIn,
                 input [2:0] ALUOpIn,
                 input MemRwIn,
                 input RegWrIn,
                 input RegWDstIn,
                 input RegWSrcIn,
                 input [1:0] PCSrcIn,
                 output reg InstMRwOut,
                 output reg ALUOpAOut,
                 output reg ALUOpBOut,
                 output reg ExtTypeOut,
                 output reg [2:0] ALUOpOut,
                 output reg MemRwOut,
                 output reg RegWrOut,
                 output reg RegWDstOut,
                 output reg RegWSrcOut,
                 output reg [1:0] PCSrcOut,
                 );
    
    always @(negedge Clk) begin
        InstMRwOut <= InstMRwIn;
        ALUOpAOut  <= ALUOpAIn;
        ALUOpBOut  <= ALUOpBIn;
        ExtTypeOut <= ExtTypeIn;
        ALUOpOut   <= ALUOpIn;
        MemRwOut   <= MemRwIn;
        RegWrOut   <= RegWrIn;
        RegWDstOut <= RegWDstIn;
        RegWSrcOut <= RegWSrcIn;
        PCSrcOut   <= PCSrcIn;
    end
    
endmodule // StageIdEx
