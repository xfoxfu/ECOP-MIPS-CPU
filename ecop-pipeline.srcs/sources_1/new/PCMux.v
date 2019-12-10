`timescale 1ns / 1ps

module PCMux(input [31:0] PC4,
             input [27:0] J,
             input [31:0] B,
             input [31:0] Jr,
             input [2:0] Sw,
             input Zf,
             output reg [31:0] NextPC);

always @(*) begin
    case (Sw)
        3'b000: NextPC <= PC4;
        3'b001: NextPC <= PC4 - 8 + (B<<2);
        3'b010: NextPC <= {PC4[31:28], J};
        3'b011: NextPC <= PC4 - 4;
        3'b100: NextPC <= Jr;
        3'b101: begin
            if (Zf == 0)
                NextPC <= PC4 + (B<<2);
            else
                NextPC <= PC4;
        end
        3'b110: begin
            if (Zf == 1)
                NextPC <= PC4 + (B<<2);
            else
                NextPC <= PC4;
        end
        default: NextPC <= PC4; // not used
    endcase
end

endmodule
