`timescale 1ns / 1ps

module ButtonStabilizer(input Clk,              
                        input PushButton,       
                        output reg ButtonState);
                        
    reg SavedState0;
    always @(posedge Clk) SavedState0 <= PushButton;
    reg SavedState1;
    always @(posedge Clk) SavedState1 <= SavedState0;
    
    // Debounce the switch
    reg [15:0] state;
    always @(posedge Clk)
        if (ButtonState == SavedState1)
            state <= 0;
        else
        begin
            state <= state + 1'b1;
            if (state == 16'hffff) begin
                ButtonState <= ~ButtonState;
            end
        end
endmodule
