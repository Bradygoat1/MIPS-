`timescale 1ns / 1ps
//    IF/ID�Ҷ��u�O²�檺�NIF stage�����G�b�C��clk�P�����W�ɽt�ǻ���ID stage
module if_id(
    input wire clk,
    input wire rst,
    //�Ӧ�IF stage���H���A�䤤���w�qInstBus��ܫ��O�e�׬�32bit
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus]if_inst,
    
    //����ID stage���H��
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
);
    
always @(posedge clk)begin
    if(rst == `RstEnable)begin
        id_pc <= `ZeroWord; //�_�쪺�ɭ�pc��0
        id_inst <= `ZeroWord; //�_�쪺�ɭԫ��O�]��0�A�]�N�O�ū��O
    end
    else begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end

endmodule
