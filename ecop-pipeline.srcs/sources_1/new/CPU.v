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

    ////////// IF Stage //////////
    
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [31:0] next_pc; // written by pcmux
    reg [27:0] if_jaddr;
    reg [31:0] if_immed_ext;
    reg [2:0] if_pcSrc;
    reg if_zf;
    reg if_jr;

    always @(negedge Clk) begin
        if_pcSrc <= ex_pcSrc;
        if_zf <= zf;
        if_jr <= rs_v;
        if_jaddr <= ex_jaddr;
        if_immed_ext <= ex_immed_ext;
    end
    
    PC mod_pc(.Clk(Clk), .Reset(Reset), .PC(pc), .PC4(pc4), .NextPC(next_pc));
    PCMux mod_mux_pc(.PC4(pc4), .J(if_jaddr), .B(if_immed_ext), .Jr(if_jr), .Sw(if_pcSrc), .Zf(if_zf), .NextPC(next_pc));

    ////////// ID stage //////////

    reg [31:0] id_pc;
    reg id_zf;

    always @(negedge Clk) begin
        id_pc <= pc;
        id_zf <= zf;
    end

    wire [31:0] inst;
    
    Memory #(.FILE("inst.mem")) mod_inst_mem(.clk(Clk), .rw(0), .addr(id_pc), .din(0), .dout(inst));
    
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
    wire aluOpA;
    wire aluOpB;
    wire extType;
    wire [2:0] aluOp;
    wire memRw;
    wire regWr;
    wire regWDst;
    wire regWSrc;
    wire [2:0] pcSrc;
    
    Control mod_ctrl(op, funct, id_zf, instMRw, aluOpA, aluOpB, extType, aluOp, memRw, regWr, regWDst, regWSrc, pcSrc);

    wire [31:0] immed_ext;
    Ext mod_ext(.imm(immed), .sign(extType), .extv(immed_ext));

    ////////// EX Stage //////////

    reg [4:0] ex_rs;
    reg [4:0] ex_rt;
    reg [4:0] ex_rd;
    reg [4:0] ex_sa;
    reg [31:0] ex_immed_ext;
    reg ex_aluOpA;
    reg ex_aluOpB;
    reg [2:0] ex_aluOp;
    reg [2:0] ex_pcSrc; // pass IF
    reg [27:0] ex_jaddr; // pass IF
    reg ex_memRw; // pass MEM
    reg ex_regWSrc; // pass WB
    reg ex_regWDst; // pass WB
    reg ex_regWr; // pass WB
    reg [31:0] ex_pc; // debug

    always @(negedge Clk) begin
        ex_rs <= rs;
        ex_rt <= rt;
        ex_rd <= rd;
        ex_sa <= sa;
        ex_immed_ext <= immed_ext;
        ex_aluOpA <= aluOpA;
        ex_aluOpB <= aluOpB;
        ex_aluOp <= aluOp;
        ex_pcSrc <= pcSrc; // pass IF
        ex_jaddr <= jaddr; // pass IF
        ex_memRw <= memRw; // pass MEM
        ex_regWSrc <= regWSrc; // pass WB
        ex_regWDst <= regWDst; // pass WB
        ex_regWr <= regWr; // pass WB
        ex_pc <= id_pc; // debug
    end
    
    wire [4:0]  mux_rd_rt;
    wire [31:0] mux_alu_mem; // written by mux
    wire [31:0] rs_v;
    wire [31:0] rt_v;
    wire defer_regWr;
    
    RegStack mod_rs(.reset(Reset), .reg0(ex_rs), .reg1(ex_rt), .regw(mux_rd_rt), .wr(defer_regWr), .dataw(mux_alu_mem), .data0(rs_v), .data1(rt_v), .clk(Clk));
        
    wire [31:0] mux_reg_sa;
    wire [31:0] mux_rt_imm;
    
    Mux2 mod_mux_reg_sa(.in0(rs_v), .in1({0, ex_sa}), .s(ex_aluOpA), .out(mux_reg_sa));
    Mux2 mod_mux_rt_imm(.in0(rt_v), .in1(ex_immed_ext), .s(ex_aluOpB), .out(mux_rt_imm));
    
    wire [31:0] alu_res;
    wire sf;
    
    ALU mod_alu(.aluop(ex_aluOp), .lhs(mux_reg_sa), .rhs(mux_rt_imm), .result(alu_res), .zero(zf), .sign(sf));

    ////////// MEM Stage //////////

    reg [31:0] mem_alu_res;
    reg [31:0] mem_rt_v;
    reg mem_memRw;
    reg mem_regWSrc; // pass WB
    reg mem_regWDst; // pass WB
    reg mem_regWr; // pass WB
    reg [4:0] mem_rd; // pass WB
    reg [4:0] mem_rt; // pass WB
    reg [31:0] mem_pc; // debug

    always @(negedge Clk) begin
        mem_alu_res <= alu_res;
        mem_rt_v <= rt_v;
        mem_memRw <= ex_memRw;
        mem_regWSrc <= ex_regWSrc; // pass WB
        mem_regWDst <= ex_regWDst; // pass WB
        mem_regWr <= ex_regWr; // pass WB
        mem_rd <= ex_rd; // pass WB
        mem_rt <= ex_rt; // pass WB
        mem_pc <= ex_pc;
    end
    
    wire [31:0] mem_v;
    
    Memory #(.FILE("data.mem")) mod_data_mem(.clk(Clk), .rw(mem_memRw), .addr(mem_alu_res), .din(mem_rt_v), .dout(mem_v));

    ////////// WB Stage //////////

    reg [31:0] wb_alu_res;
    reg [31:0] wb_mem_v;
    reg wb_regWSrc;
    reg wb_regWDst;
    reg wb_regWr;
    reg [4:0] wb_rd;
    reg [4:0] wb_rt;
    reg [31:0] wb_pc; // debug

    always @(negedge Clk) begin
        wb_alu_res <= mem_alu_res;
        wb_mem_v <= mem_v;
        wb_regWSrc <= mem_regWSrc;
        wb_regWDst <= mem_regWDst;
        wb_regWr <= mem_regWr;
        wb_rd <= mem_rd;
        wb_rt <= mem_rt;
        wb_pc <= mem_pc;
    end

    assign defer_regWr = wb_regWr;
    
    Mux2 #(5) mod_mux_rd_rt(.in0(wb_rd), .in1(wb_rt), .s(wb_regWDst), .out(mux_rd_rt));
    Mux2 mod_mux_alu_mem(.in0(wb_alu_res), .in1(wb_mem_v), .s(wb_regWSrc), .out(mux_alu_mem));
    
endmodule
