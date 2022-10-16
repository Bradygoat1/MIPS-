`timescale 1ns / 1ps

module ex(
    input wire rst,
    
    //譯碼階段送到執行階段的信息
    input wire [`AluOpBus] aluop_i,
    input wire [`AluSelBus] alusel_i,
    input wire [`RegBus] reg1_i,
    input wire [`RegBus] reg2_i,
    input wire wd_i,
    input wire wreg_i,
    
    //執行的結果
    output reg [`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg [`RegBus] wdata_o
    );
    
//保存邏輯運算的結果
reg [`RegBus] logicout;
reg [`RegBus] shiftres;

//依據aluop_i只是的運算子類型進行運算，此處只有邏輯"或"運算
always @(*)begin
    if(rst == `RstEnable)begin
        logicout <= `ZeroWord;
    end
    else begin
        case(aluop_i)
        
            `EXE_AND_OP: begin
                logicout <= reg1_i & reg2_i; //運算結果保存在logicout中
            end
        
            `EXE_OR_OP: begin
                logicout <= reg1_i | reg2_i; //運算結果保存在logicout中
            end
            
            `EXE_XOR_OP: begin
                logicout <= reg1_i ^ reg2_i; //運算結果保存在logicout中
            end
            
            `EXE_NOR_OP: begin
                logicout <= ~(reg1_i | reg2_i); //運算結果保存在logicout中
            end
            
            default: begin
                logicout <= `ZeroWord;
            end
        endcase
    end
end

//進行移位運算
always @(*)begin
    if(rst == `RstEnable)begin
        shiftres <= `ZeroWord;
    end
    else begin
        case(aluop_i)
            `EXE_SLL_OP: begin //邏輯左移
                shiftres <= reg2_i << reg1_i[4:0];
            end
            
            `EXE_SRL_OP: begin //邏輯右移
                shiftres <= reg2_i >> reg1_i[4:0];
            end
            
            `EXE_SRA_OP: begin //算數右移
                shiftres <= ({32{reg2_i[31]}} << (6'd32 - {1'b0,reg1_i[4:0]})) | reg2_i >> reg1_i[4:0];
            end
            default:begin
                shiftres <= `ZeroWord;
            end
        endcase
    end
end

//依據alusel_i只是的運算類型，選擇一個運算結果作為最終結果，此處只有邏輯運算結果
always @(*)begin
    wd_o <= wd_i; // wd_o 等於 wd_i 時，要寫入目的暫存器地址
    wreg_o <= wreg_i; //wreg_o 等於 wreg_i ，表示是否要寫目的暫存器
    case(alusel_i) //wdata_o的值要要依據運算類型進行選擇
    
        `EXE_RES_LOGIC: begin //此為邏輯運算
            wdata_o <= logicout; //wdata_o中存放運算結果
        end
        
        `EXE_RES_SHIFT: begin //此為移位運算
            wdata_o <= shiftres; //wdata_o中存放移位結果
        end
        
        default: begin
            wdata_o <= `ZeroWord;
        end
    endcase
end
        
endmodule
