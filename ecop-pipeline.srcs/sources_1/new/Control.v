`timescale 1ns / 1ps

module Control
    (op, funct, zf, InstMRw, ALUOpA, ALUOpB, ExtType, ALUOp, MemRw, RegWr, RegWDst, RegWSrc, PCSrc, RegWrDep, MemRot);

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
    output reg [1:0] RegWDst;
    output reg [1:0] RegWSrc;
    output reg [2:0] PCSrc;
    output reg [1:0] RegWrDep;
    output reg [1:0] MemRot;

    always @(*) begin
        case (op)
            6'b000000: begin {InstMRw, ExtType, MemRw, RegWSrc, RegWr, RegWDst, MemRot} <= 
                             {   1'b0,    1'b0,  1'b0,   2'b00,  1'b1,   2'b00,  2'b00};
                       case (funct)
                            6'b000000: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b1,   1'b0, 3'b010, 3'b000,    2'b00};
                            // jr
                            6'b001000: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b011, 3'b100,    2'b00};
                            // movn
                            6'b001011: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b011, 3'b000,    2'b01};
                            6'b100000: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b000, 3'b000,    2'b00};
                            6'b100010: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b001, 3'b000,    2'b00};
                            6'b100100: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b100, 3'b000,    2'b00};
                            6'b100101: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b011, 3'b000,    2'b00};
                            // slt
                            6'b101010: {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b110, 3'b000,    2'b00};
                            default:   {ALUOpA, ALUOpB,  ALUOp,  PCSrc, RegWrDep} <=
                                       {  1'b0,   1'b0, 3'b000, 3'b000,    2'b00};
                       endcase end
            6'b000001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b110, 1'b0,    2'b00,  1'b0,   2'b00, 3'b101,    2'b00,  2'b00};
            6'b000010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,    2'b00,  1'b0,   2'b00, 3'b010,    2'b00,  2'b00};
            // jal
            6'b000011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,    2'b10,  1'b1,   2'b10, 3'b010,    2'b00,  2'b00};
            6'b000100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,    2'b00,  1'b0,   2'b00, 3'b110,    2'b00,  2'b00};
            6'b000101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,    2'b00,  1'b0,   2'b00, 3'b101,    2'b00,  2'b00};
            // addi rs rt I
            6'b001000: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000,  1'b0,   2'b00,  1'b1,   2'b01, 3'b000,    2'b10,  2'b00};
            6'b001001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,    2'b00,  1'b1,   2'b01, 3'b000,    2'b00,  2'b00};
            6'b001010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b110, 1'b0,    2'b00,  1'b1,   2'b01, 3'b000,    2'b00,  2'b00};
            6'b001100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b100, 1'b0,    2'b00,  1'b1,   2'b01, 3'b000,    2'b00,  2'b00};
            6'b001101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b011, 1'b0,    2'b00,  1'b1,   2'b01, 3'b000,    2'b00,  2'b00};
            6'b100011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,    2'b01,  1'b1,   2'b01, 3'b000,    2'b00,  2'b00};
            // lhu rs rt I
            6'b100101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000,  1'b0,   2'b01,  1'b1,   2'b01, 3'b000,    2'b00,  2'b01};
            6'b101011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b1,    2'b00,  1'b0,   2'b00, 3'b000,    2'b00,  2'b00};
            6'b111111: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,    2'b00,  1'b0,   2'b00, 3'b011,    2'b00,  2'b00};
            default:   {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst,  PCSrc, RegWrDep, MemRot} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,    2'b00,  1'b0,   2'b00, 3'b000,    2'b00,  2'b00};
        endcase
    end

endmodule
