`timescale 1ns / 1ps
//    IF/ID模塊只是簡單的將IF stage的結果在每個clk周期的上升緣傳遞給ID stage
module if_id(
    input wire clk,
    input wire rst,
    //來自IF stage的信號，其中宏定義InstBus表示指令寬度為32bit
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus]if_inst,
    
    //對應ID stage的信號
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
);
    
always @(posedge clk)begin
    if(rst == `RstEnable)begin
        id_pc <= `ZeroWord; //復位的時候pc為0
        id_inst <= `ZeroWord; //復位的時候指令也為0，也就是空指令
    end
    else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end

endmodule
