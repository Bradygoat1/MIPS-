`timescale 1ns / 1ps
//ID stage 的工作為
    //確認要讀取的暫存器情況，要執行的運算與要寫入的暫存器。

module id(
    input wire rst,
    input wire[`InstAddrBus] pc_i,
    input wire[`InstBus] inst_i,
    
    //讀取的Regfile的值
    input wire[`RegBus] reg1_data_i,
    input wire[`RegBus] reg2_data_i,
    
    //處於EXstage的指令運算結果
    input wire ex_wreg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    
    //處於訪存(MEM, MEM/WB)stage的指令運算結果
    input wire mem_wreg_i,
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,
    
    //輸出到Regfile的信息
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,
    
    //送到執行階段的信息
    output reg[`AluOpBus] aluop_o,
    output reg[`AluSelBus] alusel_o,
    output reg[`RegBus] reg1_o,
    output reg[`RegBus] reg2_o,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o
    );
    
//取得指令的指令碼&功能碼
//對於ori指令只需通過判斷第26-31bit的值，即可判斷是否為ori指令
wire[5:0] op = inst_i[31:26];       //指令碼
wire[4:0] op2 = inst_i[10:6];       
wire[5:0] op3 = inst_i[5:0];        //功能碼
wire[4:0] op4 = inst_i[20:16];

//保存指令執行需要的立即數
reg[`RegBus] imm;

//指示指令是否有效
reg instvalid;

//對指令進行譯碼
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
        reg1_addr_o <= inst_i[25:21]; //默認通過Regfile讀端口1讀取的暫存器地址
        reg2_addr_o <= inst_i[20:16]; //默認通過Regfile讀端口2讀取的暫存器地址
        imm <= `ZeroWord;
        
        case(op)
            `EXE_SPECIAL_INST: begin //指令碼為SPECIAL
                case(op2)
                    5'b00000: begin
                        case(op3)

                            `EXE_AND: begin //宏定義 `EXE_AND 為6'b100100
                                //and指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是邏輯"及"運算
                                aluop_o <= `EXE_AND_OP;
                                //運算類型的邏輯運算
                                alusel_o <= `EXE_RES_LOGIC;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end            
                        
                            `EXE_OR: begin //宏定義 `EXE_OR 為6'b100101
                                //or指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是邏輯"或"運算
                                aluop_o <= `EXE_OR_OP;
                                //運算類型的邏輯運算
                                alusel_o <= `EXE_RES_LOGIC;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_XOR: begin //宏定義 `EXE_XOR 為6'b100110
                                //xor指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是邏輯"互斥或"運算
                                aluop_o <= `EXE_XOR_OP;
                                //運算類型的邏輯運算
                                alusel_o <= `EXE_RES_LOGIC;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end     
                                
                            `EXE_NOR: begin //宏定義 `EXE_NOR 為6'b100111
                                //nor指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是邏輯"反或"運算
                                aluop_o <= `EXE_NOR_OP;
                                //運算類型的邏輯運算
                                alusel_o <= `EXE_RES_LOGIC;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end   
                            
                            
                            `EXE_SLLV: begin //宏定義 `EXE_SLLV 為6'b000100
                                //sllv指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是"邏輯左移"運算，移位位數由地址為rs的暫存器值的0-4bit確定。
                                aluop_o <= `EXE_SLL_OP;
                                //移位類型的邏輯運算
                                alusel_o <= `EXE_RES_SHIFT;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SRLV: begin //宏定義 `EXE_SRLV 為6'b000110
                                //srlv指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是"邏輯右移"運算，移位位數由地址為rs的暫存器值的0-4bit確定。
                                aluop_o <= `EXE_SRL_OP;
                                //移位類型的邏輯運算
                                alusel_o <= `EXE_RES_SHIFT;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SRAV: begin //宏定義 `EXE_SRAV 為6'b000111
                                //srav指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                                wreg_o <= `WriteEnable;
                                //運算的子類型是"算術右移"運算，移位位數由地址為rs的暫存器值的0-4bit確定。
                                aluop_o <= `EXE_SRA_OP;
                                //移位類型的邏輯運算
                                alusel_o <= `EXE_RES_SHIFT;
                                //需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b1;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
                                instvalid <= `InstValid;
                            end
                            
                            `EXE_SYNC: begin //宏定義 `EXE_SYNC 為6'b001111
                                //sync指令不需要將結果寫入目的暫存器，所以wreg_o為WriteDisable
                                wreg_o <= `WriteDisable;
                                //運算的子類型是NOP
                                aluop_o <= `EXE_NOP_OP;
                                //NOP類型的邏輯運算
                                alusel_o <= `EXE_RES_NOP;
                                //不需要通過Regfile的讀端口1讀取暫存器
                                reg1_read_o <= 1'b0;
                                //需要通過Regfile的讀端口2讀取暫存器
                                reg2_read_o <= 1'b1;
                                //此指令是有效指令
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
            
            //立即值指令
            `EXE_ANDI: begin //宏定義 `EXE_ANDI 為6'b001100
                //andi指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是邏輯"及"運算
                aluop_o <= `EXE_AND_OP;
                //運算類型的邏輯運算
                alusel_o <= `EXE_RES_LOGIC;
                //需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b1;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b0;
                //指令執行需要的立即數
                imm <= {16'h0, inst_i[15:0]};
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[20:16];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            `EXE_ORI: begin //宏定義 `EXE_ORI 為6'b001101
                //ori指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是邏輯"或"運算
                aluop_o <= `EXE_OR_OP;
                //運算類型的邏輯運算
                alusel_o <= `EXE_RES_LOGIC;
                //需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b1;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b0;
                //指令執行需要的立即數
                imm <= {16'h0, inst_i[15:0]};
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[20:16];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            `EXE_XORI: begin //宏定義 `EXE_XORI 為6'b001110
                //xori指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是邏輯"或"運算
                aluop_o <= `EXE_XOR_OP;
                //運算類型的邏輯運算
                alusel_o <= `EXE_RES_LOGIC;
                //需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b1;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b0;
                //指令執行需要的立即數
                imm <= {16'h0, inst_i[15:0]};
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[20:16];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            //將lui指令轉化為ori指令來執行 lui rt, immediate = ori rt, $0, (immediate || 0^16)
            //把一個16位的立即數填入到寄存器的高16位，低16位補零
            `EXE_LUI: begin //宏定義 `EXE_XORI 為6'b001111
                //lui指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是邏輯"或"運算
                aluop_o <= `EXE_OR_OP;
                //運算類型的邏輯運算
                alusel_o <= `EXE_RES_LOGIC;
                //需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b1;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b0;
                //指令執行需要的立即數
                imm <= {inst_i[15:0], 16'h0}; //低16位補零
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[20:16];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            `EXE_PREF: begin //宏定義 `EXE_PREF 為6'b110011
                //pref指令不需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteDisable;
                //運算的子類型是邏輯"或"運算
                aluop_o <= `EXE_NOP_OP;
                //運算類型的邏輯運算
                alusel_o <= `EXE_RES_NOP;
                //不需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b0;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b0;
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            default:begin
            end
        endcase
        
        if(inst_i[31:21] == 11'b00000000000)begin
            if(op3 == `EXE_SLL)begin //sll指令
                //sll指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是"邏輯左移"運算
                aluop_o <= `EXE_SLL_OP;
                //位移類型的邏輯運算
                alusel_o <= `EXE_RES_SHIFT;
                //不需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b0;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b1;
                //指令執行需要的立即數
                imm[4:0] <= inst_i[10:6];
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[15:11];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            else if(op3 == `EXE_SRL)begin //srl指令
                //sll指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是"邏輯右移"運算
                aluop_o <= `EXE_SRL_OP;
                //位移類型的邏輯運算
                alusel_o <= `EXE_RES_SHIFT;
                //不需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b0;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b1;
                //指令執行需要的立即數
                imm[4:0] <= inst_i[10:6];
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[15:11];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
            else if(op3 == `EXE_SRA)begin //sra指令
                //sll指令需要將結果寫入目的暫存器，所以wreg_o為WriteEnable
                wreg_o <= `WriteEnable;
                //運算的子類型是"算數右移"運算
                aluop_o <= `EXE_SRA_OP;
                //位移類型的邏輯運算
                alusel_o <= `EXE_RES_SHIFT;
                //不需要通過Regfile的讀端口1讀取暫存器
                reg1_read_o <= 1'b0;
                //不需要通過Regfile的讀端口2讀取暫存器
                reg2_read_o <= 1'b1;
                //指令執行需要的立即數
                imm[4:0] <= inst_i[10:6];
                //指令執行要寫的目的暫存器地址 $rt
                wd_o <= inst_i[15:11];
                //此指令是有效指令
                instvalid <= `InstValid;
            end
            
        end      
    end        
end

// 確定進行運算的源操作數1
always @(*)begin
    if(rst == `RstEnable)begin
        reg1_o <= `ZeroWord;
    end

    
    //防止data dependency造成data hazard
    else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o))begin
        reg1_o <= ex_wdata_i;
    end
    else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o))begin
        reg1_o <= mem_wdata_i;
    end  
    //
    
    else if (reg1_read_o == 1'b1)begin
        reg1_o <= reg1_data_i;  //Regfile讀端口1的輸出值
    end
    else if(reg1_read_o == 1'b0)begin
        reg1_o <= imm;    //立即值
    end
    else begin
        reg1_o <= `ZeroWord;
    end
end

//確定進行運算的源操作數2
always @(*)begin
    if(rst == `RstEnable)begin
        reg2_o <= `ZeroWord;
    end
    //防止data dependency造成data hazard
    //EX stage to ID stage 的data forwarding
    //MEM & MEM/WB to ID stage 的data forwarding
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
