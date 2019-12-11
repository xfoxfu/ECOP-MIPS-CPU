`timescale 1ns / 1ps

module PCMux(input [31:0] PC4,
             input [31:0] EPC,
             input [27:0] J,
             input [31:0] B,
             input [31:0] Jr,
             input [2:0] Sw,
             input Zf,
             output reg [31:0] NextPC,
             output reg        Branched);

always @(*) begin
    case (Sw)
        3'b000: begin
            NextPC <= PC4;
            Branched <= 0;
        end
        3'b001: begin
            NextPC <= (EPC+4) + (B<<2);
            Branched <= 1;
        end
        3'b010: begin
            NextPC <= {EPC[31:28], J};
            Branched <= 1;
        end
        3'b011: begin
            NextPC <= EPC;
            Branched <= 1;
        end
        3'b100: begin
            NextPC <= Jr;
            Branched <= 1;
        end
        3'b101: begin
            if (Zf == 0) begin
                    NextPC <= (EPC+4) + (B<<2);
                    Branched <= 1;
            end else begin
                    NextPC <= PC4;
                    Branched <= 0;
            end
        end
        3'b110: begin
            if (Zf == 1) begin
                    NextPC <= (EPC+4) + (B<<2);
                    Branched <= 1;
            end else begin
                    NextPC <= PC4;
                    Branched <= 0;
            end
        end
        default: begin
            NextPC <= PC4; // not used
            Branched <= 0;
        end
    endcase
end

endmodule
