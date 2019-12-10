module StageIfId(input Clk,
                 input [31:0] PcIn,
                 output reg [31:0] PcOut,
                 );
    
    always @(negedge Clk) begin
        PcOut <= PcIn;
    end
    
endmodule // StageIfId
