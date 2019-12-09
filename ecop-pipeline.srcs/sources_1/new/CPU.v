`timescale 1ns / 1ps

module CPU(input Clk,
           input Reset,
           output [31:0] Pc,
           output [31:0] NextPc,
           output [31:0] RsId,
           output [31:0] RsVal,
           output [31:0] RtId,
           output [31:0] RtVal,
           output [31:0] AluVal,
           output [31:0] MemVal);
    
    assign Pc = pc;
    assign NextPc = next_pc;
    assign RsId = rs;
    assign RsVal = rs_v;
    assign RtId = rt;
    assign RtVal = rt_v;
    assign AluVal = alu_res;
    assign MemVal = mem_v;
    
    // reg clk;
    // reg reset;
    
    // always @(Clk, Reset) begin
    //     clk   <= Clk;
    //     reset <= Reset;
    // end
    
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [31:0] next_pc; // writeen by pcmux
    
    PC mod_pc(.Clk(Clk), .Reset(Reset), .PC(pc), .PC4(pc4), .NextPC(next_pc));
    
    wire [31:0] inst;
    
    Memory #(.FILE("inst.mem")) mod_inst_mem(.clk(Clk), .rw(0), .addr(pc), .din(0), .dout(inst));
    
    wire [5:0]  op;
    wire [5:0]  funct;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [15:0] immed;
    wire [27:0] jaddr;
    wire [4:0]  sa;
    
    Decoder mod_id(inst, op, funct, rs, rt, rd, immed, jaddr, sa);
    
    wire zf; // written by alu
    wire instMRw;
    wire aLUOpA;
    wire aLUOpB;
    wire extType;
    wire [2:0] aLUOp;
    wire memRw;
    wire regWr;
    wire regWDst;
    wire regWSrc;
    wire [1:0] pcSrc;
    
    Control mod_ctrl(op, funct, zf, instMRw, aLUOpA, aLUOpB, extType, aLUOp, memRw, regWr, regWDst, regWSrc, pcSrc);
    
    wire [4:0]  mux_rd_rt;
    wire [31:0] mux_alu_mem; // written by mux
    wire [31:0] rs_v;
    wire [31:0] rt_v;
    
    RegStack mod_rs(.reset(Reset), .reg0(rs), .reg1(rt), .regw(mux_rd_rt), .wr(regWr), .dataw(mux_alu_mem), .data0(rs_v), .data1(rt_v), .clk(Clk));
    
    Mux2 #(5) mod_mux_rd_rt(.in0(rd), .in1(rt), .s(regWDst), .out(mux_rd_rt));
    
    wire [31:0] immed_ext;
    Ext mod_ext(.imm(immed), .sign(extType), .extv(immed_ext));
    
    wire [31:0] mux_reg_sa;
    wire [31:0] mux_rt_imm;
    
    Mux2 mod_mux_reg_sa(.in0(rs_v), .in1({0, sa}), .s(aLUOpA), .out(mux_reg_sa));
    Mux2 mod_mux_rt_imm(.in0(rt_v), .in1(immed_ext), .s(aLUOpB), .out(mux_rt_imm));
    
    wire [31:0] alu_res;
    wire sf;
    
    ALU mod_alu(.aluop(aLUOp), .lhs(mux_reg_sa), .rhs(mux_rt_imm), .result(alu_res), .zero(zf), .sign(sf));
    
    wire [31:0] mem_v;
    
    Memory #(.FILE("data.mem")) mod_data_mem(.clk(Clk), .rw(memRw), .addr(alu_res), .din(rt_v), .dout(mem_v));
    
    Mux2 mod_mux_alu_mem(.in0(alu_res), .in1(mem_v), .s(regWSrc), .out(mux_alu_mem));
    
    PCMux mod_mux_pc(.PC4(pc4), .J(jaddr), .B(immed_ext), .Sw(pcSrc), .NextPC(next_pc));
endmodule
