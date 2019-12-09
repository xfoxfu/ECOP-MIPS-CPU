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
    output reg [1:0] PCSrc;

    // A B C D E F
    // 0 1 2 3 4 5

    /* wire is_op0 = !op[0] && !op[1] && !op[2] && !op[3] && !op[4] && !op[5];

    assign InstMRw = 0;
    // sa = 1, rs = 0
    assign ALUOpA = is_op0 && !funct[0] && !funct[1] && !funct[2] && !funct[3] && !funct[4] && !funct[5];
    // imm = 1, rt = 0
    assign ALUOpB = op[2] || op[4];
    // zero = 1, sign = 0
    assign ExtType = op[2] && !op[4];
    assign ALUOp[2] = is_op0 ? (!funct[3] && !funct[5]) : (!op[0]);
    assign ALUOp[1] = is_op0 ? (!funct[0] || funct[5]) : ((op[3] && op[5]) || (!op[3] && !op[5]) || (!op[0] && !op[2]));
    assign ALUOp[0] = is_op0 ? (funct[5] || funct[4]) : ((op[3] && op[5]) || (!op[0] && !op[2]));

    assign MemRw = */

    always @(*) begin
        case (op)
            6'b000000: begin {InstMRw, ExtType, MemRw, RegWSrc, RegWr, RegWDst, PCSrc} <= 
                             {   1'b0,    1'b0,  1'b0,    1'b0,  1'b1,    1'b0, 2'b00};
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
            6'b000001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b110, 1'b0,     1'b0,  1'b0,    1'b0,     1'b0,      !zf};
            6'b000010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,     1'b1,     1'b0};
            6'b000100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,     1'b0,  1'b0,    1'b0,     1'b0,       zf};
            6'b000101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b1, 3'b111, 1'b0,     1'b0,  1'b0,    1'b0,     1'b0,      !zf};
            6'b001001: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,     1'b0,  1'b1,    1'b1,     1'b0,     1'b0};
            6'b001010: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b110, 1'b0,     1'b0,  1'b1,    1'b1,     1'b0,     1'b0};
            6'b001100: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b100, 1'b0,     1'b0,  1'b1,    1'b1,     1'b0,     1'b0};
            6'b001101: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b0, 3'b011, 1'b0,     1'b0,  1'b1,    1'b1,     1'b0,     1'b0};
            6'b100011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b0,     1'b1,  1'b1,    1'b1,     1'b0,     1'b0};
            6'b101011: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b1,    1'b1, 3'b000, 1'b1,     1'b0,  1'b0,    1'b0,     1'b0,     1'b0};
            6'b111111: {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,     1'b1,     1'b1};
            default:   {InstMRw, ALUOpA, ALUOpB, ExtType,  ALUOp, MemRw, RegWSrc, RegWr, RegWDst, PCSrc[1], PCSrc[0]} <= 
                       {   1'b0,    1'b0,  1'b0,    1'b0, 3'b000, 1'b0,     1'b0,  1'b0,    1'b0,     1'b0,     1'b0};
        endcase
    end

endmodule
