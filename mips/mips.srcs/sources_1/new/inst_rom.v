`timescale 1ns / 1ps

module inst_rom(
    input wire clk,
    input wire ce,
    input wire [`InstAddrBus] addr,
    
    output reg[`InstBus] inst
    );
    
//定義一個數組，大小為InstMemNum，元素寬度是InstBus
reg[`InstBus] inst_mem[0:`InstMemNum-1];

//使用文件inst_rom.data初始化指令存儲器
//initial語句只執行一次，通常用於仿真模塊中對激勵向量的描述或用於給變量賦予初值
//$readmemh會將inst_rom.data中的數據依次填寫到inst_mem數組中
initial $readmemh ("C:/fpga_labs/mips/mips.srcs/sources_1/new/inst_rom.data", inst_mem); //inst_rom.data存儲的是指令

//當復位信號無效時，依據輸入的地址，給出指令存儲氣ROM中對應的元素
always @(*)begin
    if(ce == `ChipDisable)begin
        inst <= `ZeroWord;
    end
    else begin
        //MIPS是按照自結尋址的，而此處定義的指令存儲氣的每個地址是一個32bit的字
        //所以要將MIPS給出的指令地址除以4再使用(即右移2位)
        //InstMemLog2為指令存儲器的實際地址寬度
        //如果inst_mem有1024個元素，那麼InstMemNum等於1024，InstMemNumlog2等於10，表示實際地址寬度為10
        inst <= inst_mem[addr[`InstMemNumLog2+1:2]]; 
    end
end

endmodule
