`timescale 1ns / 1ps

module pc_reg(
    input wire clk,
    input wire rst,
    
    output reg[`InstAddrBus] pc, //要讀取的指令地址
    output reg ce //指令存儲器
    );
    
always @(posedge clk)begin
    if(rst == `RstEnable)begin
        ce <= `ChipDisable;  //復位的時候指令存儲器禁用
    end 
    else begin
        ce <= `ChipEnable;//復位結束後，指令存儲器使能
    end
end

always @(posedge clk)begin
    if(ce == `ChipDisable)begin
        pc <= 32'h00000000;
    end
    else begin
        pc <= pc + 4'h4; //指令存儲氣始能的時候，PC的值每時鐘週期加4
        //即指向下一條指令地址
    end
end

endmodule
