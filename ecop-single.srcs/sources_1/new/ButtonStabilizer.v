`timescale 1ns / 1ps

// Debouncer from https://www.eecs.umich.edu/courses/eecs270/270lab/270_docs/debounce.html
// This is definitely not written by xfoxfu (aka. 17341039).

module ButtonStabilizer(input Clk,               //this is a 50MHz clock provided on FPGA pin PIN_Y2
                        input PushButton,        //this is the input to be debounced
                        output reg ButtonState); //this is the debounced switch
    /*This module debounces the pushbutton PushButton.
     *It can be added to your project files and called as is:
     *DO NOT EDIT THIS MODULE
     */
    
    // Synchronize the switch input to the clock
    reg PB_sync_0;
    always @(posedge Clk) PB_sync_0 <= PushButton;
    reg PB_sync_1;
    always @(posedge Clk) PB_sync_1 <= PB_sync_0;
    
    // Debounce the switch
    reg [15:0] PB_cnt;
    always @(posedge Clk)
        if (ButtonState == PB_sync_1)
            PB_cnt <= 0;
        else
        begin
            PB_cnt <= PB_cnt + 1'b1;
            if (PB_cnt == 16'hffff) begin
                ButtonState <= ~ButtonState;
            end
        end
endmodule
