`timescale 1ns / 1ps

module PCMux(
    input      [31:0] PC4,
    input      [27:0] J,
    input      [31:0] B,
    input      [1:0]  Sw,
    output reg [31:0] NextPC
    );

    always @(*) begin
        case (Sw)
            2'b00: NextPC <= PC4;
            2'b01: NextPC <= PC4 + (B<<2);
            2'b10: NextPC <= {PC4[31:28], J};
            2'b11: NextPC <= PC4 - 4;
            default: NextPC <= PC4; // not used
        endcase
    end

endmodule
