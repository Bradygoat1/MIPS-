`timescale 1ns / 1ps

module mem(
    input wire rst,
    
    //�Ӧ�EX stage���H��
    input wire [`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire [`RegBus] wdata_i,
    
    //�X�s���q(MEM, MEM/WB)�����G
    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [`RegBus] wdata_o
    );

//MEM�Ҷ��ĥβզX�޿�q��(*)
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
