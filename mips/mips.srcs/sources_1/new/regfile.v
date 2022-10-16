`timescale 1ns / 1ps
//ID stage 將指令進行譯碼，並給出要進行的運算類型，以及參與運算的操作數
module regfile(
    input wire clk,
    input wire rst,
    //write 端口
    input wire we, //寫的使能信號
    input wire [`RegAddrBus]waddr, //要寫入的寄存器地址
    input wire [`RegBus] wdata, //要寫入的數據
    
    //read 端口1
    input wire re1, //第一個讀寄存器端口的讀使能信號
    input wire [`RegAddrBus]raddr1, //第一個讀寄存器端口要讀取的寄存器地址
    output reg [`RegBus]rdata1, //第一個讀寄存器端口輸出的寄存器值
    
    //read 端口1
    input wire re2, //第二個讀寄存器端口的讀使能信號
    input wire [`RegAddrBus]raddr2, //第二個讀寄存器端口要讀取的寄存器地址
    output reg [`RegBus]rdata2 //第二個讀寄存器端口輸出的寄存器值
    );
    
//定義32個 32 bit register
reg[`RegBus] regs[0: `RegNum -1];

//寫暫存器操作是時序邏輯電路，寫操作發生在clk信號的上升緣
//write 端口寫操作
always @(posedge clk)begin
    if(rst == `RstDisable)begin                                  //復位信號無效
        if((we == `WriteEnable)&&(waddr != `RegNumLog2'h0))begin //WriteEnable以及寫操作寄存器不等於0時，MIPS($0 == 0)
           regs[waddr] <= wdata;                                 //將寫輸入數據保存到目的暫存器
        end
    end
end

//讀暫存器的操作為組合邏輯電路，也就是一旦輸入的要讀取的暫存器地址raddr1或raddr2發生變化
//那麼會立即給出新地址的暫存器的值，這樣可以保證在譯碼階段取得要讀取的暫存器的值
//read端口1的讀操作
always @(*)begin
    if(rst == `RstEnable)begin //當復位信號有效時，第一個讀暫存器端口的輸出始終為0
        rdata1 <= `ZeroWord;
    end 
    else if (raddr1 == `RegNumLog2'h0)begin //當復位信號無效時，如果讀取的是$0，那麼直接給出0
        rdata1 <= `ZeroWord;
    end
    else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))begin
        rdata1 <= wdata;    //如果第一個第一個讀暫存器端口要讀取的目標暫存器語要寫入的相同
    end                     //那麼直接將要寫入的值作為第一個讀暫存器端口的輸出
    else if(re1 == `ReadEnable)begin //如果上述的情況都不滿足，那麼給出第一個讀暫存器端口要讀取的目標暫存器
        rdata1 <= regs[raddr1];      //地址對應的暫存器的值
    end
    else begin
        rdata1 <= `ZeroWord; //第一個讀暫存器端口不能使用時，直接輸出0
    end
end

//read端口2的讀操作
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
