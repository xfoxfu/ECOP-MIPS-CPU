module MemRotate(
    input [1:0] RotTy,
    input [31:0] MemV,
    output reg [31:0] RotV
);

always @(*) begin
    case (RotTy)
        2'b00: RotV <= MemV;
        2'b01: RotV <= {0, MemV[31:16]};
        2'b10: RotV <= {0, MemV[31:24]};
        2'b11: RotV <= MemV; // unused
        default: RotV <= MemV;
    endcase
end

endmodule // MemRotate