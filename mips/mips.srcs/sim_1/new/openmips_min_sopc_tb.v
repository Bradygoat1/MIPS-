`timescale 1ns / 1ps

module openmips_min_sopc_tb();
reg CLOCK_50;
reg rst;

//�C�j10ns�ACLOCK_50�H��½��̦��A�ҥH�@�өP���O20ns�A����50MHz
initial begin 
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end

//�̪�ɨ�A�_��H�����ġA�b��195ns�ɡA�_��H���L�ġA�̤pSOPC�}�l�B��
//�B��1000ns��A�Ȱ���u
initial begin
    rst = `RstEnable;
    #195 rst =`RstDisable;
    #1000 $stop;
end

//�ҥ~�̤pSOPC
openmips_min_sopc openmips_min_sopc0(
    .clk(CLOCK_50),
    .rst(rst)
);

endmodule
