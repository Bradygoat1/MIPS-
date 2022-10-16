`timescale 1ns / 1ps

module inst_rom(
    input wire clk,
    input wire ce,
    input wire [`InstAddrBus] addr,
    
    output reg[`InstBus] inst
    );
    
//�w�q�@�ӼƲաA�j�p��InstMemNum�A�����e�׬OInstBus
reg[`InstBus] inst_mem[0:`InstMemNum-1];

//�ϥΤ��inst_rom.data��l�ƫ��O�s�x��
//initial�y�y�u����@���A�q�`�Ω��u�Ҷ�����E�y�V�q���y�z�ΥΩ��ܶq�ᤩ���
//$readmemh�|�Ninst_rom.data�����ƾڨ̦���g��inst_mem�Ʋդ�
initial $readmemh ("C:/fpga_labs/mips/mips.srcs/sources_1/new/inst_rom.data", inst_mem); //inst_rom.data�s�x���O���O

//��_��H���L�ĮɡA�̾ڿ�J���a�}�A���X���O�s�x��ROM������������
always @(*)begin
    if(ce == `ChipDisable)begin
        inst <= `ZeroWord;
    end
    else begin
        //MIPS�O���Ӧ۵��M�}���A�Ӧ��B�w�q�����O�s�x�𪺨C�Ӧa�}�O�@��32bit���r
        //�ҥH�n�NMIPS���X�����O�a�}���H4�A�ϥ�(�Y�k��2��)
        //InstMemLog2�����O�s�x������ڦa�}�e��
        //�p�Ginst_mem��1024�Ӥ����A����InstMemNum����1024�AInstMemNumlog2����10�A��ܹ�ڦa�}�e�׬�10
        inst <= inst_mem[addr[`InstMemNumLog2+1:2]]; 
    end
end

endmodule
