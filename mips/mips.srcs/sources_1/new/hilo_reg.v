`timescale 1ns / 1ps

module hilo_reg(
    input wire clk,
    input wire rst,
    
    //¼gºÝ¤f
    input wire we,
    input wire [`RegBus] hi_i,
    input wire [`RegBus] lo_i,
    
    //ÅªºÝ¤f
    output reg [`RegBus] hi_o.
    output reg [`RegBus] lo_o.

    );
endmodule
