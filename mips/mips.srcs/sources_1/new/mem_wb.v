`timescale 1ns / 1ps

module mem_wb(
    input wire clk,
    input wire rst,
    
    //�X�s���q(MEM, MEM/WB)�����G
    input wire [`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire [`RegBus] mem_wdata,
    
    //�e��WB stage���H��
    output reg [`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg [`RegBus] wb_wdata
    );

//MEM/WB �Ҷ��ϥΪ��O�ɧ��޿�q���A�Y�b�����W�ɽt�~�o�ͫH���ǻ�
always @(posedge clk) begin 
    if(rst == `RstEnable)begin
        wb_wd <= `NOPRegAddr;
        wb_wreg <= `WriteDisable;
        wb_wdata <= `ZeroWord;
    end
    else begin
        wb_wd <= mem_wd;        //�n�g���Ȧs���a�}
        wb_wreg <= mem_wreg;    //�X�s���q���O�O�_�n�g�J�ت��Ȧs��
        wb_wdata <= mem_wdata;  //�n�g�J���ƾ�
    end
end

endmodule
