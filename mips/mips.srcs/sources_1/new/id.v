`timescale 1ns / 1ps
//ID stage ���u�@��
    //�T�{�nŪ�����Ȧs�����p�A�n���檺�B��P�n�g�J���Ȧs���C

module id(
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,
    
    //Ū����Regfile����
    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,
    
    //�B��EXstage�����O�B�⵲�G
    input wire ex_wreg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    
    //�B��X�s(MEM, MEM/WB)stage�����O�B�⵲�G
    input wire mem_wreg_i,
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,
    
    //��X��Regfile���H��
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,
    
    //�e����涥�q���H��
    output reg[`AluOpBus] aluop_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`RegBus] reg1_o,
    output reg[`RegBus] reg2_o,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o
    );
    
//���o���O�����O�X&�\��X
//���ori���O�u�ݳq�L�P�_��26-31bit���ȡA�Y�i�P�_�O�_��ori���O
wire[5:0] op = inst_i[31:26];       //���O�X
wire[4:0] op2 = inst_i[10:6];       
wire[5:0] op3 = inst_i[5:0];        //�\��X
wire[4:0] op4 = inst_i[20:16];

//�O�s���O����ݭn���ߧY��
reg[`RegBus] imm;

//���ܫ��O�O�_����
reg instvalid;

//����O�i��Ķ�X
always @(*)begin
    if(rst == `RstEnable) begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= `NOPRegAddr;
        wreg_o <= `WriteDisable;
        instvalid <= `InstValid;
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
        imm <= 32'h0;
    end
    else begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o <= inst_i[15:11];
        wreg_o <= `WriteDisable;
        instvalid <= `InstInvalid;
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= inst_i[25:21]; //�q�{�q�LRegfileŪ�ݤf1Ū�����Ȧs���a�}
        reg2_addr_o <= inst_i[20:16]; //�q�{�q�LRegfileŪ�ݤf2Ū�����Ȧs���a�}
        imm <= `ZeroWord;
        
        case(op)
            `EXE_SPECIAL_INST: begin //���O�X��SPECIAL
                case(op2)
                    5'b00000: begin
                        case(op3)

                            `EXE_AND: begin //���w�q `EXE_AND ��6'b100100
                                //and���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O�޿�"��"�B��
                                aluop_o <= `EXE_AND_OP;
                                //�B���������޿�B��
                                alusel_o <= `EXE_RES_LOGIC;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end            
                        
                            `EXE_OR: begin //���w�q `EXE_OR ��6'b100101
                                //or���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O�޿�"��"�B��
                                aluop_o <= `EXE_OR_OP;
                                //�B���������޿�B��
                                alusel_o <= `EXE_RES_LOGIC;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_XOR: begin //���w�q `EXE_XOR ��6'b100110
                                //xor���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O�޿�"������"�B��
                                aluop_o <= `EXE_XOR_OP;
                                //�B���������޿�B��
                                alusel_o <= `EXE_RES_LOGIC;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end     
                                
                            `EXE_NOR: begin //���w�q `EXE_NOR ��6'b100111
                                //nor���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O�޿�"�ϩ�"�B��
                                aluop_o <= `EXE_NOR_OP;
                                //�B���������޿�B��
                                alusel_o <= `EXE_RES_LOGIC;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end   
                            
                            
                            `EXE_SLLV: begin //���w�q `EXE_SLLV ��6'b000100
                                //sllv���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O"�޿襪��"�B��A�����ƥѦa�}��rs���Ȧs���Ȫ�0-4bit�T�w�C
                                aluop_o <= `EXE_SLL_OP;
                                //�����������޿�B��
                                alusel_o <= `EXE_RES_SHIFT;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SRLV: begin //���w�q `EXE_SRLV ��6'b000110
                                //srlv���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O"�޿�k��"�B��A�����ƥѦa�}��rs���Ȧs���Ȫ�0-4bit�T�w�C
                                aluop_o <= `EXE_SRL_OP;
                                //�����������޿�B��
                                alusel_o <= `EXE_RES_SHIFT;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SRAV: begin //���w�q `EXE_SRAV ��6'b000111
                                //srav���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                                wreg_o <= `WriteEnable;
                                //�B�⪺�l�����O"��N�k��"�B��A�����ƥѦa�}��rs���Ȧs���Ȫ�0-4bit�T�w�C
                                aluop_o <= `EXE_SRA_OP;
                                //�����������޿�B��
                                alusel_o <= `EXE_RES_SHIFT;
                                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b1;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SYNC: begin //���w�q `EXE_SYNC ��6'b001111
                                //sync���O���ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteDisable
                                wreg_o <= `WriteDisable;
                                //�B�⪺�l�����ONOP
                                aluop_o <= `EXE_NOP_OP;
                                //NOP�������޿�B��
                                alusel_o <= `EXE_RES_NOP;
                                //���ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                                reg1_read_o <= 1'b0;
                                //�ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                                reg2_read_o <= 1'b1;
                                //�����O�O���ī��O
                                instvalid <= `InstValid;
                            end                                                          
                            default:begin
                        end
                        endcase
                    end
                    default:begin
                end
                endcase
            end
            
            //�ߧY�ȫ��O
            `EXE_ANDI: begin //���w�q `EXE_ANDI ��6'b001100
                //andi���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O�޿�"��"�B��
                aluop_o <= `EXE_AND_OP;
                //�B���������޿�B��
                alusel_o <= `EXE_RES_LOGIC;
                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b1;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b0;
                //���O����ݭn���ߧY��
                imm <= {16'h0, inst_i[15:0]};
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[20:16];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            `EXE_ORI: begin //���w�q `EXE_ORI ��6'b001101
                //ori���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O�޿�"��"�B��
                aluop_o <= `EXE_OR_OP;
                //�B���������޿�B��
                alusel_o <= `EXE_RES_LOGIC;
                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b1;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b0;
                //���O����ݭn���ߧY��
                imm <= {16'h0, inst_i[15:0]};
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[20:16];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            `EXE_XORI: begin //���w�q `EXE_XORI ��6'b001110
                //xori���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O�޿�"��"�B��
                aluop_o <= `EXE_XOR_OP;
                //�B���������޿�B��
                alusel_o <= `EXE_RES_LOGIC;
                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b1;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b0;
                //���O����ݭn���ߧY��
                imm <= {16'h0, inst_i[15:0]};
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[20:16];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            //�Nlui���O��Ƭ�ori���O�Ӱ��� lui rt, immediate = ori rt, $0, (immediate || 0^16)
            //��@��16�쪺�ߧY�ƶ�J��H�s������16��A�C16��ɹs
            `EXE_LUI: begin //���w�q `EXE_XORI ��6'b001111
                //lui���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O�޿�"��"�B��
                aluop_o <= `EXE_OR_OP;
                //�B���������޿�B��
                alusel_o <= `EXE_RES_LOGIC;
                //�ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b1;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b0;
                //���O����ݭn���ߧY��
                imm <= {inst_i[15:0], 16'h0}; //�C16��ɹs
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[20:16];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            `EXE_PREF: begin //���w�q `EXE_PREF ��6'b110011
                //pref���O���ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteDisable;
                //�B�⪺�l�����O�޿�"��"�B��
                aluop_o <= `EXE_NOP_OP;
                //�B���������޿�B��
                alusel_o <= `EXE_RES_NOP;
                //���ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b0;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b0;
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            default:begin
            end
        endcase
        
        if(inst_i[31:21] == 11'b00000000000)begin
            if(op3 == `EXE_SLL)begin //sll���O
                //sll���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O"�޿襪��"�B��
                aluop_o <= `EXE_SLL_OP;
                //�첾�������޿�B��
                alusel_o <= `EXE_RES_SHIFT;
                //���ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b0;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b1;
                //���O����ݭn���ߧY��
                imm[4:0] <= inst_i[10:6];
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[15:11];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            else if(op3 == `EXE_SRL)begin //srl���O
                //sll���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O"�޿�k��"�B��
                aluop_o <= `EXE_SRL_OP;
                //�첾�������޿�B��
                alusel_o <= `EXE_RES_SHIFT;
                //���ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b0;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b1;
                //���O����ݭn���ߧY��
                imm[4:0] <= inst_i[10:6];
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[15:11];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
            else if(op3 == `EXE_SRA)begin //sra���O
                //sll���O�ݭn�N���G�g�J�ت��Ȧs���A�ҥHwreg_o��WriteEnable
                wreg_o <= `WriteEnable;
                //�B�⪺�l�����O"��ƥk��"�B��
                aluop_o <= `EXE_SRA_OP;
                //�첾�������޿�B��
                alusel_o <= `EXE_RES_SHIFT;
                //���ݭn�q�LRegfile��Ū�ݤf1Ū���Ȧs��
                reg1_read_o <= 1'b0;
                //���ݭn�q�LRegfile��Ū�ݤf2Ū���Ȧs��
                reg2_read_o <= 1'b1;
                //���O����ݭn���ߧY��
                imm[4:0] <= inst_i[10:6];
                //���O����n�g���ت��Ȧs���a�} $rt
                wd_o <= inst_i[15:11];
                //�����O�O���ī��O
                instvalid <= `InstValid;
            end
            
        end      
    end        
end

// �T�w�i��B�⪺���ާ@��1
always @(*)begin
    if(rst == `RstEnable)begin
        reg1_o <= `ZeroWord;
    end

    
    //����data dependency�y��data hazard
    else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o))begin
        reg1_o <= ex_wdata_i;
    end
    else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o))begin
        reg1_o <= mem_wdata_i;
    end  
    //
    
    else if (reg1_read_o == 1'b1)begin
        reg1_o <= reg1_data_i;  //RegfileŪ�ݤf1����X��
    end
    else if(reg1_read_o == 1'b0)begin
        reg1_o <= imm;    //�ߧY��
    end
    else begin
        reg1_o <= `ZeroWord;
    end
end

//�T�w�i��B�⪺���ާ@��2
always @(*)begin
    if(rst == `RstEnable)begin
        reg2_o <= `ZeroWord;
    end
    //����data dependency�y��data hazard
    //EX stage to ID stage ��data forwarding
    //MEM & MEM/WB to ID stage ��data forwarding
    else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o))begin
        reg2_o <= ex_wdata_i;
    end
    else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o))begin
        reg2_o <= mem_wdata_i;
    end
    //
    
    else if(reg2_read_o == 1'b1)begin
        reg2_o <= reg2_data_i;
    end
    else if(reg2_read_o == 1'b0)begin
        reg2_o <= imm;
    end
    else begin
    reg2_o <= `ZeroWord;
    end
end 
    
endmodule
