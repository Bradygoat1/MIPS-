`timescale 1ns / 1ps

module ex(
    input wire rst,
    
    //Ķ�X���q�e����涥�q���H��
    input wire [`AluOpBus] aluop_i,
    input wire [`AluSelBus] alusel_i,
    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire wd_i,
    input wire wreg_i,
    
    //���檺���G
    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [`RegBus] wdata_o
    );
    
//�O�s�޿�B�⪺���G
reg [`RegBus] logicout;
reg [`RegBus] shiftres;

//�̾�aluop_i�u�O���B��l�����i��B��A���B�u���޿�"��"�B��
always @(*)begin
    if(rst == `RstEnable)begin
        logicout <= `ZeroWord;
    end
    else begin
        case(aluop_i)
        
            `EXE_AND_OP: begin
                logicout <= reg1_i & reg2_i; //�B�⵲�G�O�s�blogicout��
            end
        
            `EXE_OR_OP: begin
                logicout <= reg1_i | reg2_i; //�B�⵲�G�O�s�blogicout��
            end
            
            `EXE_XOR_OP: begin
                logicout <= reg1_i ^ reg2_i; //�B�⵲�G�O�s�blogicout��
            end
            
            `EXE_NOR_OP: begin
                logicout <= ~(reg1_i | reg2_i); //�B�⵲�G�O�s�blogicout��
            end
            
            default: begin
                logicout <= `ZeroWord;
            end
        endcase
    end
end

//�i�沾��B��
always @(*)begin
    if(rst == `RstEnable)begin
        shiftres <= `ZeroWord;
    end
    else begin
        case(aluop_i)
            `EXE_SLL_OP: begin //�޿襪��
                shiftres <= reg2_i << reg1_i[4:0];
            end
            
            `EXE_SRL_OP: begin //�޿�k��
                shiftres <= reg2_i >> reg1_i[4:0];
            end
            
            `EXE_SRA_OP: begin //��ƥk��
                shiftres <= ({32{reg2_i[31]}} << (6'd32 - {1'b0,reg1_i[4:0]})) | reg2_i >> reg1_i[4:0];
            end
            default:begin
                shiftres <= `ZeroWord;
            end
        endcase
    end
end

//�̾�alusel_i�u�O���B�������A��ܤ@�ӹB�⵲�G�@���̲׵��G�A���B�u���޿�B�⵲�G
always @(*)begin
    wd_o <= wd_i; // wd_o ���� wd_i �ɡA�n�g�J�ت��Ȧs���a�}
    wreg_o <= wreg_i; //wreg_o ���� wreg_i �A��ܬO�_�n�g�ت��Ȧs��
    case(alusel_i) //wdata_o���ȭn�n�̾ڹB�������i����
    
        `EXE_RES_LOGIC: begin //�����޿�B��
            wdata_o <= logicout; //wdata_o���s��B�⵲�G
        end
        
        `EXE_RES_SHIFT: begin //��������B��
            wdata_o <= shiftres; //wdata_o���s�񲾦쵲�G
        end
        
        default: begin
            wdata_o <= `ZeroWord;
        end
    endcase
end
        
endmodule
