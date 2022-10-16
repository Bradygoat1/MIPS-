`timescale 1ns / 1ps

module mem_wb(
    input wire clk,
    input wire rst,
    
    //訪存階段(MEM, MEM/WB)的結果
    input wire [`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire [`RegBus] mem_wdata,
    
    //送到WB stage的信息
    output reg [`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg [`RegBus] wb_wdata
    );

//MEM/WB 模塊使用的是時序邏輯電路，即在時鐘上升緣才發生信號傳遞
always @(posedge clk) begin 
    if(rst == `RstEnable)begin
        wb_wd <= `NOPRegAddr;
        wb_wreg <= `WriteDisable;
        wb_wdata <= `ZeroWord;
    end
    else begin
        wb_wd <= mem_wd;        //要寫的暫存器地址
        wb_wreg <= mem_wreg;    //訪存階段指令是否要寫入目的暫存器
        wb_wdata <= mem_wdata;  //要寫入的數據
    end
end

endmodule
