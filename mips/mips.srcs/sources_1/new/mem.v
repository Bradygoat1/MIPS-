`timescale 1ns / 1ps

module mem(
    input wire rst,
    
    //來自EX stage的信息
    input wire [`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire [`RegBus] wdata_i,
    
    //訪存階段(MEM, MEM/WB)的結果
    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [`RegBus] wdata_o
    );

//MEM模塊採用組合邏輯電路(*)
always @(*) begin
    if(rst == `RstEnable)begin
        wd_o <= `NOPRegAddr;
        wreg_o <= `WriteDisable;
        wdata_o <= `ZeroWord;
    end
    else begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        wdata_o <= wdata_i;
    end
end

endmodule
