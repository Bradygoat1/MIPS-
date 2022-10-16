`timescale 1ns / 1ps
//ID stage �N���O�i��Ķ�X�A�õ��X�n�i�檺�B�������A�H�ΰѻP�B�⪺�ާ@��
module regfile(
    input wire clk,
    input wire rst,
    //write �ݤf
    input wire we, //�g���ϯ�H��
    input wire [`RegAddrBus]waddr, //�n�g�J���H�s���a�}
    input wire [`RegBus] wdata, //�n�g�J���ƾ�
    
    //read �ݤf1
    input wire re1, //�Ĥ@��Ū�H�s���ݤf��Ū�ϯ�H��
    input wire [`RegAddrBus]raddr1, //�Ĥ@��Ū�H�s���ݤf�nŪ�����H�s���a�}
    output reg [`RegBus]rdata1, //�Ĥ@��Ū�H�s���ݤf��X���H�s����
    
    //read �ݤf1
    input wire re2, //�ĤG��Ū�H�s���ݤf��Ū�ϯ�H��
    input wire [`RegAddrBus]raddr2, //�ĤG��Ū�H�s���ݤf�nŪ�����H�s���a�}
    output reg [`RegBus]rdata2 //�ĤG��Ū�H�s���ݤf��X���H�s����
    );
    
//�w�q32�� 32 bit register
reg[`RegBus] regs[0: `RegNum -1];

//�g�Ȧs���ާ@�O�ɧ��޿�q���A�g�ާ@�o�ͦbclk�H�����W�ɽt
//write �ݤf�g�ާ@
always @(posedge clk)begin
    if(rst == `RstDisable)begin                                  //�_��H���L��
        if((we == `WriteEnable)&&(waddr != `RegNumLog2'h0))begin //WriteEnable�H�μg�ާ@�H�s��������0�ɡAMIPS($0 == 0)
           regs[waddr] <= wdata;                                 //�N�g��J�ƾګO�s��ت��Ȧs��
        end
    end
end

//Ū�Ȧs�����ާ@���զX�޿�q���A�]�N�O�@����J���nŪ�����Ȧs���a�}raddr1��raddr2�o���ܤ�
//����|�ߧY���X�s�a�}���Ȧs�����ȡA�o�˥i�H�O�ҦbĶ�X���q���o�nŪ�����Ȧs������
//read�ݤf1��Ū�ާ@
always @(*)begin
    if(rst == `RstEnable)begin //��_��H�����ĮɡA�Ĥ@��Ū�Ȧs���ݤf����X�l�׬�0
        rdata1 <= `ZeroWord;
    end 
    else if (raddr1 == `RegNumLog2'h0)begin //��_��H���L�ĮɡA�p�GŪ�����O$0�A���򪽱����X0
        rdata1 <= `ZeroWord;
    end
    else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))begin
        rdata1 <= wdata;    //�p�G�Ĥ@�ӲĤ@��Ū�Ȧs���ݤf�nŪ�����ؼмȦs���y�n�g�J���ۦP
    end                     //���򪽱��N�n�g�J���ȧ@���Ĥ@��Ū�Ȧs���ݤf����X
    else if(re1 == `ReadEnable)begin //�p�G�W�z�����p���������A���򵹥X�Ĥ@��Ū�Ȧs���ݤf�nŪ�����ؼмȦs��
        rdata1 <= regs[raddr1];      //�a�}�������Ȧs������
    end
    else begin
        rdata1 <= `ZeroWord; //�Ĥ@��Ū�Ȧs���ݤf����ϥήɡA������X0
    end
end

//read�ݤf2��Ū�ާ@
always @(*)begin
    if(rst == `RstEnable)begin
        rdata2 <= `ZeroWord;
    end 
    else if (raddr2 == `RegNumLog2'h0)begin
        rdata2 <= `ZeroWord;
    end
    else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable))begin
        rdata2 <= wdata;
    end
    else if(re2 == `ReadEnable)begin
        rdata2 <= regs[raddr2];
    end
    else begin
        rdata2 <= `ZeroWord;
    end
end

endmodule
