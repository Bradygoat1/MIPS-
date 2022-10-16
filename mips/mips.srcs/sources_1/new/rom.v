`timescale 1ns / 1ps

module rom(
    input wire ce, //作動信號
    input wire[5:0] addr,//要讀取的指令地址
    output reg[31:0] inst //讀出的指令(32bit)
    );
reg [31:0] rom[63:0]; //使用二維向量定義存儲器

initial $readmemh ("C:/fpga_labs/mips/mips.srcs/sources_1/new/rom1.data", rom);//將rom.data的數據讀到rom中

always @(*)begin
    if(ce == 1'b0)begin
        inst <= 32'h0;
    end
    else begin
        inst <= rom[addr];
    end
end
    
endmodule
