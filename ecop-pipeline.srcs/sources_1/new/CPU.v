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
           output [31:0] MemVal,
           output Clear);
    
    assign Pc = pc;
    assign NextPc = next_pc;
    assign RsId = rs;
    assign RsVal = rs_v;
    assign RtId = rt;
    assign RtVal = rt_v;
    assign AluVal = alu_res;
    assign MemVal = data_peek;
    assign Clear = clear;

    ////////// IF Stage //////////
    
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [31:0] next_pc; // written by pcmux
    wire [31:0] IF_epc;
    wire [27:0] IF_jaddr;
    wire [31:0] IF_immed_ext;
    wire [2:0] IF_pc_src_sel;
    wire IF_zf;
    wire [31:0] IF_jr;
    wire clear;

    PC mod_pc(.Clk(Clk), .Reset(Reset), .PC(pc), .PC4(pc4), .NextPC(next_pc));
    PCMux mod_mux_pc(.PC4(pc4), .EPC(IF_epc), .J(IF_jaddr), .B(IF_immed_ext), .Jr(IF_jr), .Sw(IF_pc_src_sel), .Zf(IF_zf), .NextPC(next_pc), .Branched(clear));

    wire [31:0] inst;
    wire [31:0] inst_peek;
    
    Memory #(.FILE("inst.mem")) mod_inst_mem(.clk(Clk), .rw(0), .addr(pc), .din(0), .dout(inst), .peek(inst_peek));

    ////////// ID stage //////////

    reg [31:0] ID_pc;
    reg [31:0] ID_inst;

    initial begin
        ID_pc <= 0;
        ID_inst <= 0;
    end

    always @(negedge Clk) begin
        if (clear == 1) begin
            ID_pc <= -1;
            ID_inst <= 0;
        end else begin
            ID_pc <= pc;
            ID_inst <= inst;
        end
    end
    
    wire [5:0]  op;
    wire [5:0]  funct;
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [15:0] immed;
    wire [27:0] jaddr;
    wire [4:0]  sa;
    
    Decoder mod_id(ID_inst, op, funct, rs, rt, rd, immed, jaddr, sa);
    
    wire zf; // written by alu
    wire inst_mem_rw;
    wire alu_opa_sel;
    wire alu_opb_sel;
    wire ext_type;
    wire [2:0] alu_op;
    wire mem_rw;
    wire reg_wr;
    wire [1:0] reg_w_dst_sel;
    wire [1:0] reg_w_src_sel;
    wire [2:0] pc_src_sel;
    wire [1:0] reg_wr_dep;
    wire [1:0] mem_rot;
    
    Control mod_ctrl(op, funct, inst_mem_rw, alu_opa_sel, alu_opb_sel, ext_type, alu_op, mem_rw, reg_wr, reg_w_dst_sel, reg_w_src_sel, pc_src_sel, reg_wr_dep, mem_rot);

    wire [31:0] immed_ext;
    Ext mod_ext(.imm(immed), .sign(ext_type), .extv(immed_ext));

    wire [4:0]  mux_reg_dst;
    wire [4:0]  defer_reg_dst;
    wire [31:0] defer_reg_data; // written by mux
    wire [31:0] rs_v;
    wire [31:0] rt_v;
    wire defer_reg_wr;
        
    wire [31:0] alu_opa_v;
    wire [31:0] alu_opb_v;

    RegStack mod_rs(.reset(Reset), .reg0(rs), .reg1(rt), .regw(defer_reg_dst), .wr(defer_reg_wr), .dataw(defer_reg_data), .data0(rs_v), .data1(rt_v), .clk(Clk));

    Mux2 mod_alu_opa_v(.in0(rs_v), .in1({0, sa}), .s(alu_opa_sel), .out(alu_opa_v));
    Mux2 mod_alu_opb_v(.in0(rt_v), .in1(immed_ext), .s(alu_opb_sel), .out(alu_opb_v));

    Mux4 #(5) mod_reg_dst(.in00(rd), .in01(rt), .in10(5'b11111), .in11(0), .s(reg_w_dst_sel), .out(mux_reg_dst));

    ////////// EX Stage //////////

    reg [31:0] EX_alu_op;
    reg [31:0] EX_alu_opa_v;
    reg [31:0] EX_alu_opb_v;
    reg [31:0] EX_rt_v; // pass MEM
    reg [2:0] EX_pc_src_sel; // pass IF
    reg [27:0] EX_jaddr; // pass IF
    reg [31:0] EX_immed_ext; // pass IF
    reg EX_mem_rw; // pass MEM
    reg [1:0] EX_mem_rot; // pass MEM
    reg [1:0] EX_reg_w_src_sel; // pass WB
    reg EX_reg_wr; // pass WB
    reg [31:0] EX_pc; // debug
    reg [1:0] EX_reg_wr_dep; // pass WB
    reg [4:0] EX_reg_dst; // pass WB

    initial begin
        EX_pc <= 0;
        EX_mem_rw <= 0;
        EX_reg_wr <= 0;
    end

    always @(negedge Clk) begin
        if (clear == 1) begin
            EX_mem_rw <= 0;
            EX_reg_wr <= 0;
            EX_pc <= -1;
            EX_pc_src_sel <= 0;
        end else begin
            EX_alu_op <= alu_op;
            EX_alu_opa_v <= alu_opa_v;
            EX_alu_opb_v <= alu_opb_v;
            EX_rt_v <= rt_v; // pass MEM
            EX_pc_src_sel <= pc_src_sel; // pass IF
            EX_jaddr <= jaddr; // pass IF
            EX_immed_ext <= immed_ext; // pass IF
            EX_mem_rw <= mem_rw; // pass MEM
            EX_mem_rot <= mem_rot; // pass MEM
            EX_reg_w_src_sel <= reg_w_src_sel; // pass WB
            EX_reg_wr <= reg_wr; // pass WB
            EX_pc <= ID_pc; // debug
            EX_reg_wr_dep <= reg_wr_dep; // pass WB
            EX_reg_dst <= mux_reg_dst; // pass WB
        end
    end
    
    wire [31:0] alu_res;
    wire sf;
    wire of;
    
    ALU mod_alu(.aluop(EX_alu_op), .lhs(EX_alu_opa_v), .rhs(EX_alu_opb_v), .result(alu_res), .zero(zf), .sign(sf), .overflow(of));

    assign IF_epc = EX_pc;
    assign IF_jaddr = EX_jaddr;
    assign IF_pc_src_sel = EX_pc_src_sel;
    assign IF_zf = zf;
    assign IF_jr = rs_v;
    assign IF_immed_ext = EX_immed_ext;

    ////////// MEM Stage //////////

    reg [31:0] MEM_alu_res;
    reg [31:0] MEM_rt_v;
    reg MEM_mem_rw;
    reg [1:0] MEM_mem_rot;
    reg [1:0] MEM_reg_w_src_sel; // pass WB
    reg MEM_reg_wr; // pass WB
    reg [31:0] MEM_pc; // debug
    reg [1:0] MEM_reg_wr_dep; // pass WB
    reg MEM_of; // pass WB
    reg [4:0] MEM_reg_dst; // pass WB

    initial begin
        MEM_mem_rw <= 0;
        MEM_reg_wr <= 0;
        MEM_pc <= 0;
    end

    always @(negedge Clk) begin
        MEM_alu_res <= alu_res;
        MEM_rt_v <= EX_rt_v;
        MEM_mem_rw <= EX_mem_rw;
        MEM_mem_rot <= EX_mem_rot;
        MEM_reg_w_src_sel <= EX_reg_w_src_sel; // pass WB
        MEM_reg_wr <= EX_reg_wr; // pass WB
        MEM_pc <= EX_pc; // debug
        MEM_reg_wr_dep <= EX_reg_wr_dep; // pass WB
        MEM_of <= of; // pass WB
        MEM_reg_dst <= EX_reg_dst; // pass WB
    end
    
    wire [31:0] raw_mem_v;
    wire [31:0] mem_v;
    wire [31:0] data_peek;
    
    Memory #(.FILE("data.mem"), .SIZE(16)) mod_data_mem(.clk(Clk), .rw(MEM_mem_rw), .addr(MEM_alu_res), .din(MEM_rt_v), .dout(raw_mem_v), .peek(data_peek));
    MemRotate mod_mem_rot(MEM_mem_rot, raw_mem_v, mem_v);

    ////////// WB Stage //////////

    reg [31:0] WB_alu_res;
    reg [31:0] WB_mem_v;
    reg [31:0] WB_rt_v;
    reg [1:0] WB_reg_w_src_sel;
    reg WB_reg_wr;
    reg [31:0] WB_pc; // debug
    reg [1:0] WB_reg_wr_dep;
    reg WB_yield_reg_wr;
    reg WB_of;
    reg [4:0] WB_reg_dst;

    initial begin
        WB_reg_wr <= 0;
        WB_yield_reg_wr <= 0;
    end

    always @(negedge Clk) begin
        WB_alu_res <= MEM_alu_res;
        WB_mem_v <= mem_v;
        WB_rt_v <= MEM_rt_v;
        WB_reg_w_src_sel <= MEM_reg_w_src_sel;
        WB_reg_wr <= MEM_reg_wr;
        WB_pc <= MEM_pc;
        WB_reg_wr_dep <= MEM_reg_wr_dep;
        WB_of <= MEM_of;
        WB_reg_dst <= MEM_reg_dst;

        case (MEM_reg_wr_dep)
            2'b00: WB_yield_reg_wr <= MEM_reg_wr;
            2'b01: WB_yield_reg_wr <= MEM_reg_wr && (MEM_rt_v != 0);
            2'b10: WB_yield_reg_wr <= MEM_reg_wr && (MEM_of != 1);
            2'b11: WB_yield_reg_wr <= MEM_reg_wr; // unused
            default: WB_yield_reg_wr <= MEM_reg_wr;
        endcase
    end

    assign defer_reg_wr = WB_yield_reg_wr;
    assign defer_reg_dst = WB_reg_dst;
    
    Mux4 mod_mux_reg_data(.in00(WB_alu_res), .in01(WB_mem_v), .in10(WB_pc+4), .in11(0), .s(WB_reg_w_src_sel), .out(defer_reg_data));
    
endmodule
