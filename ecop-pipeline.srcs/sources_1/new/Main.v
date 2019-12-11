`timescale 1ns / 1ps

module Main(input [1:0] Sw,
            output [6:0] Led,
            output reg [3:0] LedSw,
            input Rst,
            input ClkBtn,
            input Clk,
            output Clear);

wire [31:0] PcDisp;
wire [31:0] NextPcDisp;
wire [31:0] Pc;
wire [31:0] NextPc;
wire [31:0] RsId;
wire [31:0] RsVal;
wire [31:0] RtId;
wire [31:0] RtVal;
wire [31:0] AluVal;
wire [31:0] MemVal;
wire [31:0] MemData;
wire cpu_clk;

ButtonStabilizer stab(.Clk(Clk), .PushButton(ClkBtn), .ButtonState(cpu_clk));
CPU cpu(.Clk(cpu_clk), .Reset(Rst), .Pc(Pc), .NextPc(NextPc), 
    .RsId(RsId), .RsVal(RsVal), .RtId(RtId), .RtVal(RtVal), .AluVal(AluVal), .MemVal(MemVal), .MemData(MemData), .Clear(Clear));

assign PcDisp = Pc;
assign NextPcDisp = NextPc;

wire disp_clk;

ClkDiv#(50000, 19) div2(.clk(Clk), .rst_n(1), .clk_out(disp_clk));

reg [3:0] disp_bit;
reg [1:0] bit_sw;
reg [15:0] disp_data;

LedEncoder(.Number(disp_bit), .LedCode(Led));

always @(posedge disp_clk) begin
    bit_sw <= bit_sw + 1;
    case (bit_sw)
        2'b00: begin
            disp_bit <= disp_data[15:12];
            LedSw    <= ~4'b1000;
        end
        2'b01: begin
            disp_bit <= disp_data[11:8];
            LedSw    <= ~4'b0100;
        end
        2'b10: begin
            disp_bit <= disp_data[7:4];
            LedSw    <= ~4'b0010;
        end
        2'b11: begin
            disp_bit <= disp_data[3:0];
            LedSw    <= ~4'b0001;
        end
        default: begin
            disp_bit <= 4'b0000;
            LedSw    <= ~4'b0000;
        end
    endcase
end

always @(Sw, PcDisp, NextPcDisp, RsId, RsVal, RtId, RtVal, AluVal, MemVal, MemData) begin
    case (Sw)
        2'b00: disp_data   <= {PcDisp[7:0], NextPcDisp[7:0]};
        2'b01: disp_data   <= {RsId[7:0], RsVal[7:0]};
        2'b10: disp_data   <= {RtId[7:0], RtVal[7:0]};
        2'b11: disp_data   <= {MemVal[27:24], MemVal[19:16], MemVal[11:8], MemVal[3:0]};
        default: disp_data <= 0;
    endcase
end

endmodule
