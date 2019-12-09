`timescale 1ns / 1ps

module Control
    (op, funct, zf, InstMRw, ALUOpA, ALUOpB, ExtType, ALUOp, MemRw, RegWr, RegWDst, RegWSrc, PCSrc);

    input      [5:0] op;
    input      [5:0] funct;
    input            zf;
    output reg InstMRw;
    output reg ALUOpA;
    output reg ALUOpB;
    output reg ExtType;
    output reg [2:0] ALUOp;
    output reg MemRw;
    output reg RegWr;
    output reg RegWDst;
    output reg RegWSrc;
    output reg [2:0] PCSrc;

    always @(*) begin
        case (op)
            6'b000000: begin {InstMRw, ExtType, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                             {   1'b0,    1'b0,  1'b0,    1'b0,  1'b1,    1'b0, 3'b000};
                       case (funct)
                           6'b000000: {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b1,   1'b0, 3'b010};
                           6'b100000: {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b0,   1'b0, 3'b000};
                           6'b100010: {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b0,   1'b0, 3'b001};
                           6'b100100: {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b0,   1'b0, 3'b100};
                           6'b100101: {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b0,   1'b0, 3'b011};
                           default:    {ALUOpA, ALUOpB,  ALUOp} <=
                                      {  1'b0,   1'b0, 3'b000};
                       endcase end
            6'b000001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b110, 1'b0,     1'b0,  1'b0,    1'b0,  3'b101};
            6'b000010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,  3'b010};
            6'b000100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,     1'b0,  1'b0,    1'b0,  3'b110};
            6'b000101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,     1'b0,  1'b0,    1'b0,  3'b101};
            6'b001001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,     1'b0,  1'b1,    1'b1,  3'b000};
            6'b001010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b110, 1'b0,     1'b0,  1'b1,    1'b1,  3'b000};
            6'b001100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b100, 1'b0,     1'b0,  1'b1,    1'b1,  3'b000};
            6'b001101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b011, 1'b0,     1'b0,  1'b1,    1'b1,  3'b000};
            6'b100011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,     1'b1,  1'b1,    1'b1,  3'b000};
            6'b101011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b1,     1'b0,  1'b0,    1'b0,  3'b000};
            6'b111111: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,  3'b011};
            default:   {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,  3'b000};
        endcase
    end

endmodule
