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
    assign MemVal = data_peek;

    ////////// IF Stage //////////
    
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [31:0] next_pc; // written by pcmux
    wire [31:0] if_epc;
    wire [27:0] if_jaddr;
    wire [31:0] if_immed_ext;
    wire [2:0] if_pcSrc;
    wire if_zf;
    wire [31:0] if_jr;

    always @(negedge Clk) begin
        // if_pc <= (^ex_pc !== 1'bX) ? ex_pc : pc;
        // if_pcSrc <= ex_pcSrc;
        // if_zf <= zf;
        // if_jr <= rs_v;
        // if_jaddr <= ex_jaddr;
        // if_immed_ext <= ex_immed_ext;
    end
    
    PC mod_pc(.Clk(Clk), .Reset(Reset), .PC(pc), .PC4(pc4), .NextPC(next_pc));
    PCMux mod_mux_pc(.PC4(pc4), .EPC(if_epc), .J(if_jaddr), .B(if_immed_ext), .Jr(if_jr), .Sw(if_pcSrc), .Zf(if_zf), .NextPC(next_pc));

    wire [31:0] inst;
    wire [31:0] inst_peek;
    
    Memory #(.FILE("inst.mem")) mod_inst_mem(.clk(Clk), .rw(0), .addr(pc), .din(0), .dout(inst), .peek(inst_peek));

    ////////// ID stage //////////

    reg [31:0] id_pc;
    reg [31:0] id_inst;
    reg id_zf;

    initial begin
        id_pc <= 0;
        id_inst <= 0;
    end

    always @(negedge Clk) begin
        id_pc <= pc;
        id_inst <= inst;
        id_zf <= zf;
    end
    
    wire [5:0]  op;
    wire [5:0]  funct;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [15:0] immed;
    wire [27:0] jaddr;
    wire [4:0]  sa;
    
    Decoder mod_id(id_inst, op, funct, rs, rt, rd, immed, jaddr, sa);
    
    wire zf; // written by alu
    wire instMRw;
    wire aluOpA;
    wire aluOpB;
    wire extType;
    wire [2:0] aluOp;
    wire memRw;
    wire regWr;
    wire [1:0] regWDst;
    wire [1:0] regWSrc;
    wire [2:0] pcSrc;
    wire [1:0] regWrDep;
    wire [1:0] memRot;
    
    Control mod_ctrl(op, funct, id_zf, instMRw, aluOpA, aluOpB, extType, aluOp, memRw, regWr, regWDst, regWSrc, pcSrc, regWrDep, memRot);

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
    reg [1:0] ex_memRot; // pass MEM
    reg [1:0] ex_regWSrc; // pass WB
    reg [1:0] ex_regWDst; // pass WB
    reg ex_regWr; // pass WB
    reg [31:0] ex_pc; // debug
    reg [1:0] ex_regWrDep; // pass WB

    initial begin
        ex_pc <= 0;
        ex_memRw <= 0;
        ex_regWr <= 0;
    end

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
        ex_memRot <= memRot; // pass MEM
        ex_regWSrc <= regWSrc; // pass WB
        ex_regWDst <= regWDst; // pass WB
        ex_regWr <= regWr; // pass WB
        ex_pc <= id_pc; // debug
        ex_regWrDep <= regWrDep; // pass WB
    end
    
    wire [4:0]  mux_reg_dst;
    wire [31:0] mux_reg_data; // written by mux
    wire [31:0] rs_v;
    wire [31:0] rt_v;
    wire defer_regWr;
    
    RegStack mod_rs(.reset(Reset), .reg0(ex_rs), .reg1(ex_rt), .regw(mux_reg_dst), .wr(defer_regWr), .dataw(mux_reg_data), .data0(rs_v), .data1(rt_v), .clk(Clk));
        
    wire [31:0] mux_alu_opa;
    wire [31:0] mux_alu_opb;
    
    Mux2 mod_mux_alu_opa(.in0(rs_v), .in1({0, ex_sa}), .s(ex_aluOpA), .out(mux_alu_opa));
    Mux2 mod_mux_alu_opb(.in0(rt_v), .in1(ex_immed_ext), .s(ex_aluOpB), .out(mux_alu_opb));
    
    wire [31:0] alu_res;
    wire sf;
    wire of;
    
    ALU mod_alu(.aluop(ex_aluOp), .lhs(mux_alu_opa), .rhs(mux_alu_opb), .result(alu_res), .zero(zf), .sign(sf), .overflow(of));

    assign if_epc = ex_pc;
    assign if_jaddr = ex_jaddr;
    assign if_pcSrc = ex_pcSrc;
    assign if_zf = zf;
    assign if_jr = rs_v;
    assign if_immed_ext = ex_immed_ext;

    ////////// MEM Stage //////////

    reg [31:0] mem_alu_res;
    reg [31:0] mem_rt_v;
    reg mem_memRw;
    reg [1:0] mem_memRot;
    reg [1:0] mem_regWSrc; // pass WB
    reg [1:0] mem_regWDst; // pass WB
    reg mem_regWr; // pass WB
    reg [4:0] mem_rd; // pass WB
    reg [4:0] mem_rt; // pass WB
    reg [31:0] mem_pc; // debug
    reg [1:0] mem_regWrDep; // pass WB
    reg mem_of; // pass WB

    initial begin
        mem_memRw <= 0;
        mem_regWr <= 0;
        mem_pc <= 0;
    end

    always @(negedge Clk) begin
        mem_alu_res <= alu_res;
        mem_rt_v <= rt_v;
        mem_memRw <= ex_memRw;
        mem_memRot <= ex_memRot;
        mem_regWSrc <= ex_regWSrc; // pass WB
        mem_regWDst <= ex_regWDst; // pass WB
        mem_regWr <= ex_regWr; // pass WB
        mem_rd <= ex_rd; // pass WB
        mem_rt <= ex_rt; // pass WB
        mem_pc <= ex_pc; // debug
        mem_regWrDep <= ex_regWrDep; // pass WB
        mem_of <= of; // pass WB
    end
    
    wire [31:0] raw_mem_v;
    wire [31:0] mem_v;
    wire [31:0] data_peek;
    
    Memory #(.FILE("data.mem"), .SIZE(16)) mod_data_mem(.clk(Clk), .rw(mem_memRw), .addr(mem_alu_res), .din(mem_rt_v), .dout(raw_mem_v), .peek(data_peek));
    MemRotate mod_mem_rot(mem_memRot, raw_mem_v, mem_v);

    ////////// WB Stage //////////

    reg [31:0] wb_alu_res;
    reg [31:0] wb_mem_v;
    reg [31:0] wb_rt_v;
    reg [1:0] wb_regWSrc;
    reg [1:0] wb_regWDst;
    reg wb_regWr;
    reg [4:0] wb_rd;
    reg [4:0] wb_rt;
    reg [31:0] wb_pc; // debug
    reg [1:0] wb_regWrDep;
    reg wb_yield_regWr;
    reg wb_of;

    initial begin
        wb_regWr <= 0;
        wb_yield_regWr <= 0;
    end

    always @(negedge Clk) begin
        wb_alu_res <= mem_alu_res;
        wb_mem_v <= mem_v;
        wb_rt_v <= mem_rt_v;
        wb_regWSrc <= mem_regWSrc;
        wb_regWDst <= mem_regWDst;
        wb_regWr <= mem_regWr;
        wb_rd <= mem_rd;
        wb_rt <= mem_rt;
        wb_pc <= mem_pc;
        wb_regWrDep <= mem_regWrDep;
        wb_of <= mem_of;

        case (mem_regWrDep)
            2'b00: wb_yield_regWr <= mem_regWr;
            2'b01: wb_yield_regWr <= mem_regWr && (mem_rt_v != 0);
            2'b10: wb_yield_regWr <= mem_regWr && (mem_of != 1);
            2'b11: wb_yield_regWr <= mem_regWr; // unused
            default: wb_yield_regWr <= mem_regWr;
        endcase
    end

    assign defer_regWr = wb_yield_regWr;
    
    Mux4 #(5) mod_mux_reg_dst(.in00(wb_rd), .in01(wb_rt), .in10(5'b11111), .in11(0), .s(wb_regWDst), .out(mux_reg_dst));
    Mux4 mod_mux_reg_data(.in00(wb_alu_res), .in01(wb_mem_v), .in10(wb_pc+4), .in11(0), .s(wb_regWSrc), .out(mux_reg_data));
    
endmodule
