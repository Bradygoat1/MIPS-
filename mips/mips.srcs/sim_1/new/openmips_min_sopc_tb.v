`timescale 1ns / 1ps

module openmips_min_sopc_tb();
reg CLOCK_50;
reg rst;

//每隔10ns，CLOCK_50信號翻轉依次，所以一個周期是20ns，對應50MHz
initial begin 
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end

//最初時刻，復位信號有效，在第195ns時，復位信號無效，最小SOPC開始運行
//運行1000ns後，暫停仿真
initial begin
    rst = `RstEnable;
    #195 rst =`RstDisable;
    #1000 $stop;
end

//例外最小SOPC
openmips_min_sopc openmips_min_sopc0(
    .clk(CLOCK_50),
    .rst(rst)
);

endmodule
