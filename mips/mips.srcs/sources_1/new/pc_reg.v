`timescale 1ns / 1ps

module pc_reg(
    input wire clk,
    input wire rst,
    
    output reg[`InstAddrBus] pc, //�nŪ�������O�a�}
    output reg ce //���O�s�x��
    );
    
always @(posedge clk)begin
    if(rst == `RstEnable)begin
        ce <= `ChipDisable;  //�_�쪺�ɭԫ��O�s�x���T��
    end 
    else begin
        ce <= `ChipEnable;//�_�쵲����A���O�s�x���ϯ�
    end
end

always @(posedge clk)begin
    if(ce == `ChipDisable)begin
        pc <= 32'h00000000;
    end
    else begin
        pc <= pc + 4'h4; //���O�s�x��l�઺�ɭԡAPC���ȨC�����g���[4
        //�Y���V�U�@�����O�a�}
    end
end

endmodule
