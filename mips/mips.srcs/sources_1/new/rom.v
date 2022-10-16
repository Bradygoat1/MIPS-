`timescale 1ns / 1ps

module rom(
    input wire ce, //�@�ʫH��
    input wire[5:0] addr,//�nŪ�������O�a�}
    output reg[31:0] inst //Ū�X�����O(32bit)
    );
reg [31:0] rom[63:0]; //�ϥΤG���V�q�w�q�s�x��

initial $readmemh ("C:/fpga_labs/mips/mips.srcs/sources_1/new/rom1.data", rom);//�Nrom.data���ƾ�Ū��rom��

always @(*)begin
    if(ce == 1'b0)begin
        inst <= 32'h0;
    end
    else begin
        inst <= rom[addr];
    end
end
    
endmodule
